classdef uLCDhcf < io.github.stage_vss.protocols.StageProtocol
    
    properties
        amp                             % Output amplifier
        ulcd                            % uLCD screen
        centerX = 110                   % Spot x center (pixels)
        centerY = 110                   % Spot y center (pixels)
        preTime = 500                   % Spot leading duration (ms)
        stimTime = 1000                 % Spot duration (ms)
        tailTime = 500                  % Spot trailing duration (ms)
        ringdelayTime = 250             % Ring leading duration (ms)
        ringstimTime = 500              % Ring duration (ms)
        spotDiameter = 10               % Spot diameter size (pixels)
        ringDiameter = 50              % Spot diameter size (pixels)
        numberOfAverages = uint16(1)    % Number of epochs
        interpulseInterval = 0          % Duration between spots (s)
    end
    
    properties (Hidden)
        ampType
        ulcdType
    end
    
    methods
        
        function didSetRig(obj)
            didSetRig@io.github.stage_vss.protocols.StageProtocol(obj);
            
            [obj.amp, obj.ampType] = obj.createDeviceNamesProperty('Amp');
            [obj.ulcd, obj.ulcdType] = obj.createDeviceNamesProperty('uLCD');
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
            prepareRun@io.github.stage_vss.protocols.StageProtocol(obj);
            
            obj.showFigure('symphonyui.builtin.figures.ResponseFigure', obj.rig.getDevice(obj.amp));
            obj.showFigure('symphonyui.builtin.figures.MeanResponseFigure', obj.rig.getDevice(obj.amp));
        end
        
        function p = createPresentation(obj)
%             device = obj.rig.getDevice('Stage');
% %             canvasSize = device.getCanvasSize();
%             uLCD = obj.rig.getDevice('uLCD');
            p = stage.core.Presentation((obj.preTime + obj.stimTime + obj.tailTime) * 1e-3);
            p.setBackgroundColor(0);
            
            uStim=squirrellab.stimuli.uLCDCenterSurroundGenerator();
            uStim.centerX=obj.centerX;
            uStim.centerY=obj.centerY;
            uStim.preTime=obj.preTime*1e-3;
            uStim.stimTime=obj.stimTime*1e-3;
            uStim.tailTime=obj.tailTime*1e-3;
            uStim.ringdelayTime=obj.ringdelayTime*1e-3;
            uStim.ringstimTime=obj.ringstimTime*1e-3;
            uStim.spotDiameter=obj.spotDiameter;
            uStim.ringDiameter=obj.ringDiameter;
            p.addStimulus(uStim);
            
            uLCDCMD = stage.builtin.controllers.PropertyController(uStim, 'cmdCount', @(state)squirrellab.stage2.uLCDCenterSurroundController(state));
            p.addController(uLCDCMD);
            
            center = stage.builtin.stimuli.Ellipse();
            center.color = 1;
            center.radiusX = obj.spotDiameter;
            center.radiusY = obj.spotDiameter;
            center.position = [obj.centerX, obj.centerY];
            p.addStimulus(center);        
            centerVisible = stage.builtin.controllers.PropertyController(center, 'visible',...
                @(state)state.time >= uStim.preTime && state.time < (uStim.preTime + uStim.stimTime));
            p.addController(centerVisible);
            
            surround = stage.builtin.stimuli.Ellipse();
            surround.color = 1;
            surround.radiusX = obj.ringDiameter;
            surround.radiusY = obj.ringDiameter;
            surround.position = [obj.centerX, obj.centerY];
            p.addStimulus(surround);
            surroundVisible = stage.builtin.controllers.PropertyController(surround, 'visible',...
                @(state)state.time >= (uStim.preTime+uStim.ringdelayTime) && state.time < (uStim.preTime+uStim.ringdelayTime+uStim.ringstimTime));
            p.addController(surroundVisible);
        end
        
        function prepareEpoch(obj, epoch)
            prepareEpoch@io.github.stage_vss.protocols.StageProtocol(obj, epoch);
            
            device = obj.rig.getDevice(obj.amp);
            duration = (obj.preTime + obj.stimTime + obj.tailTime) / 1e3;
            epoch.addDirectCurrentStimulus(device, device.background, duration, obj.sampleRate);
            epoch.addResponse(device);
        end
        
        function prepareInterval(obj, interval)
            prepareInterval@io.github.stage_vss.protocols.StageProtocol(obj, interval);
            
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

