classdef Preparation < squirrellab.sources.Preparation
    
    methods
        
        function obj = Preparation()
            import symphonyui.core.*;
            
			obj.addProperty('region', {}, ...
    			'type', PropertyType('cellstr', 'row', {'superior', 'inferior'}));
			obj.addProperty('eye', {}, ...
    			'type', PropertyType('cellstr', 'row', {'left', 'right'}));
			obj.addProperty('viral transfection', {}, ...
    			'type', PropertyType('cellstr', 'row', {'', 'subretinal', 'intravitreal'}));
			obj.addProperty('viral serotype', '', ...
    			'type', PropertyType('char', 'row', 'datestr'), ...
            obj.addProperty('viral transfection date', datestr(now), ...
                'type', PropertyType('char', 'row', 'datestr'), ...
                'description', 'Date virus was injected');
			
            obj.addAllowableParentType('squirrellab.sources.squirrel.Squirrel');
        end
        
    end
    
end

