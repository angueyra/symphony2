classdef ZFRetCell < squirrellab.sources.RetCell
    
    methods
        
        function obj = ZFRetCell()
            import symphonyui.core.*;
            obj.addAllowableParentType('squirrellab.sources.squirrel.SqRetPrep');
        end
        
    end
    
end
