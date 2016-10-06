classdef vTails < squirrellab.protocols.SquirrelLabProtocol
    
    properties
        amp                             % Output amplifier
        preTime = 100                   % Pulse leading duration (ms)
        stimTime = 500                  % Pulse duration (ms)
        deactTime = 2000                % Duration of tail current
        tailTime = 100                  % Pulse trailing duration (ms)
        actPulseSignal = 0              % activation Pulse signal value (mV or pA)
        deactPulseSignal = -100          % deactivation first signal
        incrementPerPulse = 10          % Increment value per each pulse (mV or pA)
        pulsesInFamily = uint16(15)     % Number of pulses in family
        numberOfAverages = uint16(3)    % Number of families
        interpulseInterval = 0          % Duration between pulses (s)
        % still missing some leak traces
        % can you just extract linear filter from some voltage noise? Try
        % with model cell?
    end
    
    properties (Hidden)
        ampType
        deactAmp = ((0:double(obj.pulsesInFamily)-1) * obj.incrementPerPulse) + obj.deactPulseSignal;
    end
    
    methods
        
        function didSetRig(obj)
            didSetRig@squirrellab.protocols.SquirrelLabProtocol(obj);
            
            [obj.amp, obj.ampType] = obj.createDeviceNamesProperty('Amp');
        end
        
        function p = getPreview(obj, panel)
            p = symphonyui.builtin.previews.StimuliPreview(panel, @()createPreviewStimuli(obj));
            function s = createPreviewStimuli(obj)
                s = cell(1, obj.pulsesInFamily);
                for i = 1:numel(s)
                    s{i} = obj.createAmpStimulus(i);
                end
            end
        end
        
        function prepareRun(obj)           
            prepareRun@squirrellab.protocols.SquirrelLabProtocol(obj);
            
            obj.showFigure('symphonyui.builtin.figures.ResponseFigure', obj.rig.getDevice(obj.amp));
%             obj.showFigure('symphonyui.builtin.figures.MeanResponseFigure', obj.rig.getDevice(obj.amp), ...
%                 'groupBy', {'pulseSignal'});
            obj.showFigure('squirrellab.figures.vPulseFamilyIVFigure', obj.rig.getDevice(obj.amp), ...
                'prepts',obj.timeToPts(obj.preTime),...
                'stmpts',obj.timeToPts(obj.stimTime),...
                'nPulses',double(obj.pulsesInFamily),...
                'pulseAmp',obj.deactAmp,...
                'groupBy', {'deactSignal'});
            obj.showFigure('symphonyui.builtin.figures.ResponseStatisticsFigure', obj.rig.getDevice(obj.amp), {@mean, @var}, ...
                'baselineRegion', [0 obj.preTime], ...
                'measurementRegion', [obj.preTime obj.preTime+obj.stimTime]);
        end
        
        function [stim, deactSignal] = createAmpStimulus(obj, pulseNum)
%             pulseSignal = obj.incrementPerPulse * (double(pulseNum) - 1) + obj.firstPulseSignal;
            deactSignal = obj.deactAmp(pulseNum);
            
            
            gen1 = symphonyui.builtin.stimuli.PulseGenerator();
            
            gen1.preTime = obj.preTime;
            gen1.stimTime = obj.stimTime;
            gen1.tailTime = obj.deactTime + obj.tailTime;
            gen1.mean = obj.rig.getDevice(obj.amp).background.quantity;
            gen1.amplitude = obj.actPulseSignal - gen1.mean;
            gen1.sampleRate = obj.sampleRate;
            gen1.units = obj.rig.getDevice(obj.amp).background.displayUnits;

            pulse1=gen1.generate();
            
            gen2 = symphonyui.builtin.stimuli.PulseGenerator();
            
            gen2.preTime = obj.preTime + obj.stimTime;
            gen2.stimTime = obj.deactTime;
            gen2.tailTime = obj.tailTime;
            gen2.mean = 0;
            gen2.amplitude = deactSignal - gen1.mean;
            gen2.sampleRate = obj.sampleRate;
            gen2.units = obj.rig.getDevice(obj.amp).background.displayUnits;
            
            pulse2 = gen2.generate();
            
            gen=symphonyui.builtin.stimuli.SumGenerator();
            gen.stimuli={pulse1,pulse2};
                        
            stim = gen.generate();
        end
        
        function prepareEpoch(obj, epoch)
            prepareEpoch@squirrellab.protocols.SquirrelLabProtocol(obj, epoch);
            
            pulseNum = mod(obj.numEpochsPrepared - 1, obj.pulsesInFamily) + 1;
            [stim, deactSignal] = obj.createAmpStimulus(pulseNum);
            
            epoch.addParameter('pulseSignal', obj.actPulseSignal);
            epoch.addParameter('deactSignal', deactSignal);
            
            epoch.addStimulus(obj.rig.getDevice(obj.amp), stim);
            epoch.addResponse(obj.rig.getDevice(obj.amp));
        end
        
        function prepareInterval(obj, interval)
            prepareInterval@squirrellab.protocols.SquirrelLabProtocol(obj, interval);
            
            device = obj.rig.getDevice(obj.amp);
            interval.addDirectCurrentStimulus(device, device.background, obj.interpulseInterval, obj.sampleRate);
        end
        
        function tf = shouldContinuePreparingEpochs(obj)
            tf = obj.numEpochsPrepared < obj.numberOfAverages * obj.pulsesInFamily;
        end
        
        function tf = shouldContinueRun(obj)
            tf = obj.numEpochsCompleted < obj.numberOfAverages * obj.pulsesInFamily;
        end
        
    end
    
end

