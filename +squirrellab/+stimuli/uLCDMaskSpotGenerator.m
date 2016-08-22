classdef uLCDMaskSpotGenerator < squirrellab.stimuli.uLCDStimulus
    properties
        preTime             % Spot leading duration (ms)
        stimTime            % Spot duration (ms)
        tailTime            % Spot trailing duration (ms)
        spotDiameter        % Spot diameter size (pixels)
        ringDiameter        % Spot diameter size (pixels)
        centerX             % Spot x center (pixels)
        centerY             % Spot x center (pixels)
        spotFlag = 1;
        clearFlag = 1;
    end
    
    methods
    end
    
end

