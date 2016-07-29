classdef RigA_OneAmp < symphonyui.core.descriptions.RigDescription
    
    methods
        
        function obj = RigA_OneAmp()
            import symphonyui.builtin.daqs.*;
            import symphonyui.builtin.devices.*;
            import symphonyui.core.*;
            
            daq = HekaDaqController();
            obj.daqController = daq;
            
            amp1 = AxopatchDevice('Amp1').bindStream(daq.getStream('ANALOG_OUT.0'));
            amp1.bindStream(daq.getStream('ANALOG_IN.0'), AxopatchDevice.SCALED_OUTPUT_STREAM_NAME);
            amp1.bindStream(daq.getStream('ANALOG_IN.1'), AxopatchDevice.GAIN_TELEGRAPH_STREAM_NAME);
            %missing frequency input here (is that the low pass filter value?)
            amp1.bindStream(daq.getStream('ANALOG_IN.2'), AxopatchDevice.MODE_TELEGRAPH_STREAM_NAME);
            obj.addDevice(amp1);
            
            led455 = UnitConvertingDevice('led455', 'V').bindStream(daq.getStream('ANALOG_OUT.3'));
%             led455.addConfigurationSetting('calvalue', '', ...
%                 'type', PropertyType('char', 'row', {'', 'low', 'medium', 'high'}));
            obj.addDevice(led455);
            
            led530 = UnitConvertingDevice('led530', 'V').bindStream(daq.getStream('ANALOG_OUT.2'));
            obj.addDevice(led530);
            
            led590 = UnitConvertingDevice('led591', 'V').bindStream(daq.getStream('ANALOG_OUT.1'));
            obj.addDevice(led590);
            
            T5Controller = UnitConvertingDevice('T5Controller', 'V','manufacturer','Bioptechs').bindStream(daq.getStream('ANALOG_IN.6'));
            obj.addDevice(T5Controller);
            
            trigger = UnitConvertingDevice('Trigger', symphonyui.core.Measurement.UNITLESS).bindStream(daq.getStream('DIGITAL_OUT.1'));
            daq.getStream('DIGITAL_OUT.1').setBitPosition(trigger, 0);
            obj.addDevice(trigger);
            
            
        end
        
    end
    
end
