classdef MousePrep < squirrellab.sources.Preparation
    
    methods
        
        function obj = MousePrep()
            import symphonyui.core.*;
            
			obj.addProperty('region', {}, ...
    			'type', PropertyType('cellstr', 'row', {'superior', 'inferior', 'nasal', 'temporal'}));
			obj.addProperty('eye', '', ...
    			'type', PropertyType('char', 'row', {'','left', 'right'}));
			obj.addProperty('viral transfection', '', ...
    			'type', PropertyType('char', 'row', {'', 'subretinal', 'intravitreal'}));
            obj.addProperty('viral serotype', '', ...
				'type', PropertyType('char', 'row', {'', 'AAV1', 'AAV2', 'AAV2o1SyniGluSnfr'}));
			obj.addProperty('viral transfection date', datestr(now), ...
                'type', PropertyType('char', 'row', 'datestr'), ...
                'description', 'Date virus was injected');
            
            obj.addAllowableParentType('squirrellab.sources.mouse.Mouse');
        end
        
    end
    
end

