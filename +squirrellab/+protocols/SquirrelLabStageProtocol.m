classdef (Abstract) SquirrelLabStageProtocol < io.github.stage_vss.protocols.StageProtocol
    
    methods (Abstract)
       
    end
    
    methods
        
       function pts = timeToPts (obj, t)
            pts = round(t / 1e3 * obj.sampleRate);
        end
    end
    
end

