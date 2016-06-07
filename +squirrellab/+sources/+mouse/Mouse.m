classdef Mouse < squirrellab.sources.Subject
    
    methods
        
        function obj = Mouse()
            import symphonyui.core.*;
            
            obj.addProperty('genotype', {}, ...
                'type', PropertyType('cellstr', 'row', {'C57B6', 'Rho 19', 'Rho 18', 'STM', 'TTM', 'Arr1 KO', 'GRK1 KO', 'GCAP KO', 'GJD2-GFP', 'DACT2-GFP', 'PLCXD2-GFP', 'NeuroD6 Cre', 'Grm6-tdTomato', 'Grm6-cre1', 'Ai27 (floxed ChR2-tdTomato)', 'Cx36-/-'}), ... 
                'description', 'Genetic strain');
            
            photoreceptors = containers.Map();
            photoreceptors('SCone') = struct('collectingArea', 0.20, 'lambdaMax', 360);
			photoreceptors('MCone') = struct('collectingArea', 0.20, 'lambdaMax', 508);
            photoreceptors('Rod')   = struct('collectingArea', 0.50, 'lambdaMax', 498);
            obj.addResource('photoreceptors', photoreceptors);
            ;
            
            obj.addAllowableParentType([]);
        end
        
    end
    
    properties (Constant)

    end
    
end

