classdef uLCDhcf < squirrellab.protocols.SquirrelLabProtocolStage
    
    properties
        amp                             % Output amplifier
        uLCD                            % uLCD screen
        centerX = 110                   % Spot x center (pixels)
        centerY = 110                   % Spot y center (pixels)
        spotpreTime = 500               % Spot leading duration (ms)
        spotstimTime = 1000             % Spot duration (ms)
        spottailTime = 500              % Spot trailing duration (ms)
        ringdelayTime = 250               % Ring leading duration (ms)
        ringstimTime = 500              % Ring duration (ms)
        spotDiameter = 10               % Spot diameter size (pixels)
        ringDiameter = 100              % Spot diameter size (pixels)
        numberOfAverages = uint16(1)    % Number of epochs
        interpulseInterval = 0          % Duration between spots (s)
    end
    
    properties (Hidden)
        ampType
        uLCDType
    end
    
    methods
        
        function didSetRig(obj)
            didSetRig@squirrellab.protocols.SquirrelLabProtocolStage(obj);
            
            [obj.amp, obj.ampType] = obj.createDeviceNamesProperty('Amp');
            [obj.uLCD, obj.uLCDType] = obj.createDeviceNamesProperty('uLCD');
        end
        
%         function p = getPreview(obj, panel)
%             if isempty(obj.rig.getDevices('Stage'))
%                 p = [];
%                 return;
%             end
%             p = io.github.stage_vss.previews.StagePreview(panel, @()obj.createPresentation(), ...
%                 'windowSize', obj.rig.getDevice('Stage').getCanvasSize());
%         end
        
        function prepareRun(obj)
            prepareRun@edu.washington.riekelab.protocols.RiekeLabStageProtocol(obj);
            
            obj.showFigure('symphonyui.builtin.figures.ResponseFigure', obj.rig.getDevice(obj.amp));
            obj.showFigure('symphonyui.builtin.figures.MeanResponseFigure', obj.rig.getDevice(obj.amp));
%             obj.showFigure('edu.washington.riekelab.figures.FrameTimingFigure', obj.rig.getDevice('Stage'), obj.rig.getDevice('Frame Monitor'));
        end
        
        function p = createPresentation(obj)
            device = obj.rig.getDevice('Stage');
            canvasSize = device.getCanvasSize();
            
            p = stage.core.Presentation((obj.spotpreTime + obj.spotstimTime + obj.spottailTime) * 1e-3);
            
            uLCDStim=squirrellab.stimuli.uLCDCenterSurroundGenerator();
            uLCDStim.centerX=obj.centerX;
            uLCDStim.centerY=obj.centerY;
            uLCDStim.spotpreTime=obj.spotpreTime;
            uLCDStim.spotstimTime=obj.spotstimTime;
            uLCDStim.spottailTime=obj.spottailTime;
            uLCDStim.ringdelayTime=obj.ringpreTime;
            uLCDStim.ringstimTime=obj.ringstimTime;
            uLCDStim.spotDiameter=obj.spotDiameter;
            uLCDStim.ringDiameter=obj.ringDiameter;
            uLCDStim.uLCD=obj.uLCD;
            p.addStimulus(uLCDStim);
            
            uLCDCMD = stage.builtin.controllers.PropertyController(uLCDStim, 'cmdCount', @squirrellab.stage2.uLCDCenterSurroundController);
            p.addController(uLCDCMD);
        end
        
        function prepareEpoch(obj, epoch)
            prepareEpoch@edu.washington.riekelab.protocols.RiekeLabStageProtocol(obj, epoch);
            
            device = obj.rig.getDevice(obj.amp);
            duration = (obj.preTime + obj.stimTime + obj.tailTime) / 1e3;
            epoch.addDirectCurrentStimulus(device, device.background, duration, obj.sampleRate);
            epoch.addResponse(device);
        end
        
        function prepareInterval(obj, interval)
            prepareInterval@edu.washington.riekelab.protocols.RiekeLabStageProtocol(obj, interval);
            
            device = obj.rig.getDevice(obj.amp);
            interval.addDirectCurrentStimulus(device, device.background, obj.interpulseInterval, obj.sampleRate);
        end
        
        function tf = shouldContinuePreparingEpochs(obj)
            tf = obj.numEpochsPrepared < obj.numberOfAverages;
        end
        
        function tf = shouldContinueRun(obj)
            tf = obj.numEpochsCompleted < obj.numberOfAverages;
        end
        
    end
    
end

