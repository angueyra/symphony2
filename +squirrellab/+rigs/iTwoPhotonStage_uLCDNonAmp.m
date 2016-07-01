classdef iTwoPhotonStage_uLCDNonAmp < squirrellab.rigs.iTwoPhotonStage_NonAmp
    properties
        uLCD
        
    end
    
    methods
        
        function obj = iTwoPhotonStage_uLCDNonAmp()
            
            obj.uLCD = squirrellab.devices.uLCDObj('COM9');
            obj.uLCD.connect();
%             import symphonyui.builtin.devices.*;
%             
%             uLCD = squirrellab.devices.uLCDDevice('comPort','COM9');
%             fprintf('Initialized Stage and uLCD\n')
%             % Binding the uLCD to an unused stream only so its configuration settings are written to each epoch.
%             daq = obj.daqController;
%             uLCD.bindStream(daq.getStream('DIGITAL_OUT.2'));
%             daq.getStream('DIGITAL_OUT.2').setBitPosition(uLCD, 15);
%             fprintf('uLCD is bound to DAQ\n')
%             obj.addDevice(uLCD);
%             fprintf('uLCD has been added as device\n')
        end
        
    end
end
    
