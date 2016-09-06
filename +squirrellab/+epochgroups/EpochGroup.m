classdef (Abstract) EpochGroup < symphonyui.core.persistent.descriptions.EpochGroupDescription
    
    methods
        
        function obj = EpochGroup()
            import symphonyui.core.*;
            
            obj.addProperty('externalSolutionAdditions', {}, ...
                'type', PropertyType('cellstr', 'row', {'SR101 (1 uM)', 'SR101 (500 nM)', 'NBQX (10uM)', 'L-AP4 (20uM)', 'GYKI53655 (100uM)', 'ACET (1 uM)' , 'DAPV (50uM)', 'APB (10uM)', 'LY 341495 (10uM)', 'strychnine (0.5uM)', 'strychnine (25uM)', 'gabazine (10uM)', 'gabazine (25uM)', 'TPMPA (50uM)', 'TTX (100nM)', 'TTX (500nM)'}));
            obj.addProperty('pipetteSolution', '', ...
                'type', PropertyType('char', 'row', {'', 'KAsp 0Ca2+', 'CsMs0Ca2+','CsMs', 'KAsp', 'CsCl', 'Ames', 'Ringer', 'HibA'}));
            obj.addProperty('internalSolutionAdditions', '');
            obj.addProperty('recordingTechnique', '', ...
                'type', PropertyType('char', 'row', {'', 'cell-attached', 'whole-cell', 'perforated patch', 'suction'}));
            obj.addProperty('seriesResistanceCompensation', int32(0), ...
                'type', PropertyType('int32', 'scalar', [0 100]));
        end
        
    end
    
end

