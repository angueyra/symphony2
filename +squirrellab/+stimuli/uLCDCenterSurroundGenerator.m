classdef uLCDCenterSurroundGenerator < squirrellab.stimuli.uLCDStimulus
    properties
        preTime               % Spot leading duration (ms)
        stimTime             % Spot duration (ms)
        tailTime              % Spot trailing duration (ms)
        ringdelayTime               % Ring leading duration (ms)
        ringstimTime              % Ring duration (ms)
        spotDiameter               % Spot diameter size (pixels)
        ringDiameter              % Spot diameter size (pixels)
        centerX                   % Spot x center (pixels)
        centerY
        spotFlag = 1;
        ringFlag = 1;
        clearFlag = 1;
    end
    
    methods
    end
    
end

