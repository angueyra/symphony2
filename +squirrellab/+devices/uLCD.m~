classdef uLCD < handle
    
    properties %(Access = private, Transient)
        serialPort
    end
    
    methods
        
        function obj = uLCD(port)
            if nargin < 1
                port = 'COM3';
            end

            obj.serialPort = serial(port,'BaudRate',875000);%default=9600%max=875000 
        end
        
        function delete(obj)
            obj.disconnect();
            delete(obj.serialPort);
        end
        
        function connect(obj)
            fopen(obj.serialPort);
            
            % Test connection.
%             fwrite(obj.serialPort, 'T');
%             
%             [~, ~, msg] = fread(obj.serialPort, 3);
%             if ~strcmp(msg, '')
%                 obj.disconnect();
%                 error(['Unable to connect: ' msg]);
%             end
        end
        
        function disconnect(obj)
            fclose(obj.serialPort);
        end
        
        function clear(obj)
            % clear screen
            fwrite(obj.serialPort,255);%fwrite(obj.serialPort,hex2dec('FF'));
            fwrite(obj.serialPort,130);%fwrite(obj.serialPort,hex2dec('82'));
            % Does this work?
            % fwrite(idLCD,[255,130]);
        end
        
        function spot(obj,centerX,centerY,radius,hexcolor1,hexcolor2)
            % spot(obj,centerX,centerY,radius,hexcolor1,hexcolor2)
            % radius in pixels, color in hexadecimal format
            % default color is white
            if isempty(hexcolor1)
                hexcolor1=255;
            end
            if isempty(hexcolor2)
                hexcolor2=255;
            end
            % Clears screen and creates white ring
            obj.clear;        
            centerX(centerX>220)=220/2;
            centerY(centerY>220)=220/2;
            % Outer circle
            fwrite(idLCD,255);fwrite(idLCD,119);%fwrite(idLCD,hex2dec('FF'));fwrite(idLCD,hex2dec('77'));
            fwrite(idLCD,00);fwrite(idLCD,centerX);
            fwrite(idLCD,00);fwrite(idLCD,centerY);
            fwrite(idLCD,00);fwrite(idLCD,radius);
            fwrite(idLCD,hexcolor1);fwrite(idLCD,hexcolor2);
        end
        
        function spot_white(obj,centerX,centerY,radius)
            obj.spot(centerX,centerY,radius,255,255);
        end
        
        function spot_black(obj,centerX,centerY,radius)
            obj.spot(centerX,centerY,radius,0,0);
        end
        
        function spot_red(obj,centerX,centerY,radius)
            obj.spot(centerX,centerY,radius,255/2,0/2);
        end
        
        function ring(obj,centerX,centerY,rInner,rOuter)
            % Outer circle
            spot_white(obj.serialPort,centerX,centerY,rOuter);
            %Inner circle
            spot_black(obj.serialPort,centerX,centerY,rInner); 
        end
        
        function white2black(obj)
            % makes all white pixels black
            fwrite(obj.serialPort,255);fwrite(obj.serialPort,105);%fwrite(idLCD,hex2dec('FF'));fwrite(idLCD,hex2dec('69'));
            fwrite(obj.serialPort,255);fwrite(obj.serialPort,255);
            fwrite(obj.serialPort,0);fwrite(obj.serialPort,0);
        end
        
        function black2white(obj)
             % makes all black pixels white
            fwrite(obj.serialPort,255);fwrite(obj.serialPort,105);%fwrite(idLCD,hex2dec('FF'));fwrite(idLCD,hex2dec('69'));
            fwrite(obj.serialPort,0);fwrite(obj.serialPort,0);
            fwrite(obj.serialPort,255);fwrite(obj.serialPort,255);
        end
        
        function moveRing(obj,stX,stY,fX,fY,rInner,rOuter,frames)
            obj.clear;
            
            deltaX=abs(stX-fX)/frames;
            deltaY=abs(stY-fY)/frames;
            
            for f=0:frames
                if f>0
                    obj.spot_black(obj.serialPort,stX+(deltaX*(f-1)),stY+(deltaY*(f-1)),rOuter);
                end
                obj.spot_white(obj.serialPort,stX+(deltaX*f),stY+(deltaY*f),rOuter);
                obj.spot_black(obj.serialPort,stX+(deltaX*f),stY+(deltaY*f),rInner);
            end
        end
        
    end
    
end
