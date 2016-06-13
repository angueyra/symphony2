classdef (Abstract) Preparation < symphonyui.core.persistent.descriptions.SourceDescription
    
    methods
        
        function obj = Preparation()
            import symphonyui.core.*;
            
            obj.addProperty('time', datestr(now), ...
                'type', PropertyType('char', 'row', 'datestr'), ...
                'description', 'Time the tissue was prepared');
            obj.addProperty('dissector', 'Angueyra', ...
                'type', PropertyType('char', 'row', {'', 'Angueyra', 'Chen', 'Kunze', 'Zhao', 'Ball', 'Li', 'Ou', 'Qiao'}), ...
                'description', 'LiLab member who performed dissection of tissue');
            obj.addProperty('tissue', 'retina', ...
                'type', PropertyType('char', 'row', {'retina', 'pineal gland', 'other'}),...
                'description', 'experimental tissue');
			obj.addProperty('preparation', '', ...
                'type', PropertyType('char', 'row', {'whole mount cones', 'whole mount RGCs', 'slice', 'chop', 'dissociation', 'culture'}));
            obj.addProperty('bathSolution', '', ...
                'type', PropertyType('char', 'row', {'', 'AmesBicarb', 'AmesHEPES', 'HibA'}), ...
                'description', 'The solution the tissue is bathed in during experiments');   
            obj.addProperty('storageSolution', '', ...
                'type', PropertyType('char', 'row', {'', 'AmesBicarb', 'AmesHEPES', 'HibA'}), ...
                'description', 'The solution the tissue is stored in');
            obj.addProperty('storageTemp', '', ...
                'type', PropertyType('char', 'row', {'', 'fridge', 'room temp', 'warm', 'body temp'}), ...
                'description', 'The temperature of the solution the tissue is stored in');   
        end
        
    end
    
end
