classdef Organoid < squirrellab.sources.Subject
    
    methods
        
        function obj = Organoid()
            import symphonyui.core.*;
            
            obj.addProperty('species', 'hiPSC', ...
                'type', PropertyType('char', 'row', {'all_transRA','9cisRAL','hiPSC', 'H9','PEN8E',''}));
            
            obj.addAllowableParentType([]);
        end
        
    end
    
    properties (Constant)

    end
    
end

