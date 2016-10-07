classdef vPulseFamily < squirrellab.protocols.SquirrelLabProtocol
    
    properties
        amp                             % Output amplifier
        preTime = 100                   % Pulse leading duration (ms)
        stimTime = 500                  % Pulse duration (ms)
        tailTime = 2000                 % Pulse trailing duration (ms)
        firstPulseSignal = -100         % First pulse signal value (mV or pA)
        incrementPerPulse = 10          % Increment value per each pulse (mV or pA)
        leakSub = true                  % Attempt leak subtraction with 5mV pulses
        leakN = uint16(2)                 % Number of pairs of low voltage stimuli to run for leak subtraction
        pulsesInFamily = uint16(15)     % Number of pulses in family
        numberOfAverages = uint16(3)    % Number of families
        interpulseInterval = 0          % Duration between pulses (s)
    end
    
    properties (Hidden)
        ampType
        leakPulses
        nLeakPulses
        nPulses
        pulseAmp
    end
    
    methods
        
        function didSetRig(obj)
            didSetRig@squirrellab.protocols.SquirrelLabProtocol(obj);
        end
        
        function p = getPreview(obj, panel)
            p = symphonyui.builtin.previews.StimuliPreview(panel, @()createPreviewStimuli(obj));
            function s = createPreviewStimuli(obj)
                s = cell(1, obj.nPulses);
                for i = 1:numel(s)
                    s{i} = obj.createAmpStimulus(i);
                end
            end
        end
        
        function prepareRun(obj)           
            prepareRun@squirrellab.protocols.SquirrelLabProtocol(obj);
            
            %% Where is the right spot for this. Needs to update if parameters update
            % Right now, getPreview does not update untila fter it's run
            [obj.amp, obj.ampType] = obj.createDeviceNamesProperty('Amp');
            obj.leakPulses = repmat([-5 5],1,obj.leakN);
            obj.nLeakPulses = size(obj.leakPulses,2);
            obj.nPulses = obj.pulsesInFamily + obj.nLeakPulses;
%             fprintf('nL = %g\n',obj.nLeakPulses)
%             fprintf('nP = %g\n',obj.pulsesInFamily)
            obj.pulseAmp = [obj.leakPulses ((0:double(obj.pulsesInFamily)-1) * obj.incrementPerPulse) + obj.firstPulseSignal];
%             fprintf('PoRDER = %g\n',obj.pulseAmp)

            obj.showFigure('symphonyui.builtin.figures.ResponseFigure', obj.rig.getDevice(obj.amp));
%             obj.showFigure('symphonyui.builtin.figures.MeanResponseFigure', obj.rig.getDevice(obj.amp), ...
%                 'groupBy', {'pulseSignal'});
            if ~obj.leakSub
            obj.showFigure('squirrellab.figures.vPulseFamilyIVFigure', obj.rig.getDevice(obj.amp), ...
                'prepts',obj.timeToPts(obj.preTime),...
                'stmpts',obj.timeToPts(obj.stimTime),...
                'nPulses',double(obj.pulsesInFamily),...
                'pulseAmp',obj.pulseAmp,...
                'groupBy', {'pulseSignal'});
            else % this should make a leak sub figure (not done yet)
                obj.showFigure('squirrellab.figures.vPulseFamilyIVFigure', obj.rig.getDevice(obj.amp), ...
                'prepts',obj.timeToPts(obj.preTime),...
                'stmpts',obj.timeToPts(obj.stimTime),...
                'nPulses',double(obj.pulsesInFamily),...
                'pulseAmp',obj.pulseAmp,...
                'groupBy', {'pulseSignal'});
            end
            obj.showFigure('symphonyui.builtin.figures.ResponseStatisticsFigure', obj.rig.getDevice(obj.amp), {@mean, @var}, ...
                'baselineRegion', [0 obj.preTime], ...
                'measurementRegion', [obj.preTime obj.preTime+obj.stimTime]);
        end
        
        function [stim, pulseSignal] = createAmpStimulus(obj, pulseNum)
            
            pulseSignal = obj.pulseAmp(pulseNum);
            
            gen = symphonyui.builtin.stimuli.PulseGenerator();
            
            gen.preTime = obj.preTime;
            gen.stimTime = obj.stimTime;
            gen.tailTime = obj.tailTime;
            gen.mean = obj.rig.getDevice(obj.amp).background.quantity;
            gen.amplitude = pulseSignal - gen.mean;
            gen.sampleRate = obj.sampleRate;
            gen.units = obj.rig.getDevice(obj.amp).background.displayUnits;
            
            stim = gen.generate();
        end
        
        function prepareEpoch(obj, epoch)
            prepareEpoch@squirrellab.protocols.SquirrelLabProtocol(obj, epoch);
            
            pulseNum = mod(obj.numEpochsPrepared - 1, obj.nPulses) + 1;
            [stim, pulseSignal] = obj.createAmpStimulus(pulseNum);
            
            epoch.addParameter('pulseSignal', pulseSignal);
            epoch.addStimulus(obj.rig.getDevice(obj.amp), stim);
            epoch.addResponse(obj.rig.getDevice(obj.amp));
        end
        
        function prepareInterval(obj, interval)
            prepareInterval@squirrellab.protocols.SquirrelLabProtocol(obj, interval);
            
            device = obj.rig.getDevice(obj.amp);
            interval.addDirectCurrentStimulus(device, device.background, obj.interpulseInterval, obj.sampleRate);
        end
        
        function tf = shouldContinuePreparingEpochs(obj)
            tf = obj.numEpochsPrepared < obj.numberOfAverages * obj.nPulses;
        end
        
        function tf = shouldContinueRun(obj)
            tf = obj.numEpochsCompleted < obj.numberOfAverages * obj.nPulses;
        end
        
    end
    
end

