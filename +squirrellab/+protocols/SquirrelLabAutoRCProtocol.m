classdef (Abstract) SquirrelLabAutoRCProtocol < squirrellab.protocols.SquirrelLabProtocol
% delivers a 5 mV voltage pulse every time protocol is run to keep track
% of access resistance and membrane capacitance

    properties
       autoRC = true;
    end
    
    properties (Hidden)
		runRC
        RCpreTime = 15
        RCstimTime = 30
        RCtailTime = 15
        RCpulseAmplitude = 5
        RCnumberOfAverages = 1
        RCamp2PulseAmplitude = 0
        RCinterpulseInterval = 0
        RCEpochsPrepared
        RCEpochsCompleted
    end
    
    methods
        
        function prepareRun(obj)
            prepareRun@squirrellab.protocols.SquirrelLabProtocol(obj);
            obj.RCEpochsCompleted = 0;
            obj.RCEpochsPrepared = 0;
            if obj.autoRC
                obj.runRC = true;
                % Open RC figure
                obj.showFigure('squirrellab.figures.RCFigure', obj.rig.getDevice(obj.amp));
            else
                obj.runRC = false;
            end
        end
        
        %%%%%%% Need to handle RCFigure as custom figure with its own
        %%%%%%% updateFigure call and make it not update with the rest of
        %%%%%%% the figures
        function prepareEpoch(obj, epoch)
%           prepareEpoch@squirrellab.protocols.SquirrelLabProtocol(obj, epoch);
            % add remperature controller monitor
            T5Controller = obj.rig.getDevices('T5Controller');
            if ~isempty(T5Controller)
                epoch.addResponse(T5Controller{1});
            end
                      
            if obj.runRC && obj.RCEpochsPrepared < obj.RCnumberOfAverages
                % Add RC epoch parameters
                epoch.addParameter('RCepoch', 1);
                epoch.addParameter('RCpreTime', obj.RCpreTime);
                epoch.addParameter('RCstimTime', obj.RCstimTime);
                epoch.addParameter('RCtailTime', obj.RCtailTime);
                epoch.addParameter('RCpulseAmplitude', obj.RCpulseAmplitude);
                epoch.addParameter('RCnumberOfAverages', obj.RCnumberOfAverages);
                epoch.addParameter('RCamp2PulseAmplitude', obj.RCamp2PulseAmplitude);
                epoch.addParameter('RCinterpulseInterval', obj.RCinterpulseInterval);
                epoch.addStimulus(obj.rig.getDevice(obj.amp), obj.createRCStimulus());
                epoch.addResponse(obj.rig.getDevice(obj.amp));
                obj.RCEpochsPrepared = obj.RCEpochsPrepared + 1;
                fprintf('yas RC: %g of %g\n',obj.RCEpochsPrepared,obj.RCnumberOfAverages)
			else
				obj.runRC = false;
                obj.numEpochsPrepared = obj.numEpochsPrepared + 1;
                fprintf('not RC: %g of %g\n',obj.numEpochsPrepared,obj.numberOfAverages)

            end
        end
        
        function completeEpoch(obj, epoch)

            if epoch.parameters.isKey('RCepoch')
                if epoch.parameters('RCepoch')
                    obj.RCEpochsCompleted = obj.RCEpochsCompleted + 1;
                    fprintf('Completed RC epoch\n')
                    obj.figureHandlerManager.updateFigures(epoch);
                else
                    warning('Epoch is labeled as RCepoch but RCepoch is false\n')
                end
            else
                completeEpoch@squirrellab.protocols.SquirrelLabProtocol(obj, epoch);
            end
        end
        
        function completeRun(obj)
            completeRun@squirrellab.protocols.SquirrelLabProtocol(obj);
        end
        function stim = createRCStimulus(obj)
            gen = symphonyui.builtin.stimuli.PulseGenerator();
            
            gen.preTime = obj.RCpreTime;
            gen.stimTime = obj.RCstimTime;
            gen.tailTime = obj.RCtailTime;
            gen.amplitude = obj.RCpulseAmplitude;
            gen.mean = obj.rig.getDevice(obj.amp).background.quantity;
            gen.sampleRate = obj.sampleRate;
            gen.units = obj.rig.getDevice(obj.amp).background.displayUnits;
            
            stim = gen.generate();
        end
        
        function num = getRCTotalPts(obj)
            num = (obj.RCpreTime + obj.RCstimTime + obj.RCtailTime) * ...
                obj.sampleRate / 1000;
        end
    end
    
end

