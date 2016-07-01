classdef uLCDCenterSurroundGenerator < squirrellab.stimuli.uLCDStimulus
    properties
        spotpreTime               % Spot leading duration (ms)
        spotstimTime             % Spot duration (ms)
        spottailTime              % Spot trailing duration (ms)
        ringdelayTime               % Ring leading duration (ms)
        ringstimTime              % Ring duration (ms)
        spotDiameter               % Spot diameter size (pixels)
        ringDiameter              % Spot diameter size (pixels)
        centerX                   % Spot x center (pixels)
        centerY
        spotFlag = 0;
        ringFlag = 1;
    end
    
    methods
    end
    
end

