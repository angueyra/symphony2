classdef (Abstract) RetCell < squirrellab.sources.Cell
    
    methods
        
        function obj = RetCell()
            import symphonyui.core.*;
            
            obj.addProperty('type', 'unknown', ...
                'type', PropertyType('char', 'row', containers.Map( ...
                    {'RGC','photoreceptor', 'bipolar', 'horizontal', 'amacrine', 'unknown'}, ...
                    {{'ON-alpha', 'ON-transient', 'OFF-transient', 'OFF-sustained', 'ON/OFF DS', 'ON DS', 'W3/local edge detector'}, ...
                    {'S-cone', 'M-cone', 'rod'}, ...
                    {'rbc', 'cbc', 'on-cbc', 'off-cbc'}, ...
                    {'H1', 'H2'}, ...
                    {'AII', 'A17', 'starburst', 'AC5170'}, ...
                    {}...
                    })), ...
                'description', 'The confirmed type of the recorded cell');
        end
        
    end
    
end