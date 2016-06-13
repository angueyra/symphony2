classdef iTwoPhoton_NonAmp < symphonyui.core.descriptions.RigDescription
    
    methods
        
        function obj = iTwoPhoton_NonAmp()
            import symphonyui.builtin.daqs.*;
            import symphonyui.builtin.devices.*;
            import symphonyui.core.*;
            
            daq = HekaDaqController();
            obj.daqController = daq;

            frame = UnitConvertingDevice('FrameMonitor', symphonyui.core.Measurement.UNITLESS).bindStream(daq.getStream('DIGITAL_IN.0'));
            daq.getStream('DIGITAL_IN.0').setBitPosition(frame, 0);
            obj.addDevice(frame);

            mx405LED = UnitConvertingDevice('mx405LED', 'V').bindStream(daq.getStream('ANALOG_OUT.2'));
            mx405LED.addConfigurationSetting('ndfs', {}, ...
                'type', PropertyType('cellstr', 'row', {'0.3', '0.6', '1.2', '3.0', '4.0'}));
            mx405LED.addConfigurationSetting('gain', '', ...
                'type', PropertyType('char', 'row', {'', 'low', 'medium', 'high'}));
            obj.addDevice(mx405LED);
            
            mx590LED = UnitConvertingDevice('mx590LED', 'V').bindStream(daq.getStream('ANALOG_OUT.3'));
            mx590LED.addConfigurationSetting('ndfs', {}, ...
                'type', PropertyType('cellstr', 'row', {'0.3', '0.6', '1.2', '3.0', '4.0'}));
            mx590LED.addConfigurationSetting('gain', '', ...
                'type', PropertyType('char', 'row', {'', 'low', 'medium', 'high'}));
            obj.addDevice(mx590LED);
            
            T5Controller = UnitConvertingDevice('T5Controller', 'V','manufacturer','Bioptechs').bindStream(daq.getStream('ANALOG_IN.7'));
            obj.addDevice(T5Controller);

            trigger = UnitConvertingDevice('Trigger', symphonyui.core.Measurement.UNITLESS).bindStream(daq.getStream('DIGITAL_OUT.1'));
            daq.getStream('DIGITAL_OUT.1').setBitPosition(trigger, 0);
            obj.addDevice(trigger);
            
        end
        
    end
    
end
