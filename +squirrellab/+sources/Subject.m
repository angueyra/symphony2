classdef (Abstract) Subject < symphonyui.core.persistent.descriptions.SourceDescription
    
    methods
        
        function obj = Subject()
            import symphonyui.core.*;
            
            obj.addProperty('ID#', '', ...
                'description', 'ID of animal');
            obj.addProperty('description', '', ...
                'description', 'Description of subject and where subject came from (eg, breeder, if animal)');
            obj.addProperty('Sex', '', ...
                'type', PropertyType('char', 'row', {'', 'male', 'female'}), ...
                'description', 'Gender of the subject');
            obj.addProperty('DOB', '', ...
                'description', 'Date of birth');
            obj.addProperty('Weight', '', ...
                'description', 'Weight in grams (if possible)');
            obj.addProperty('DarkAdaptation', '', ...
                'type', PropertyType('char', 'row', {'', 'light adapted', 'overnight', '1 hour', '2 hours'}), ...
                'description', 'Period of time the subject was allowed to adjust to the dark');      
        end
        
    end
    
end

