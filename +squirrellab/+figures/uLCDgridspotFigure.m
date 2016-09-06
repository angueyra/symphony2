classdef uLCDgridspotFigure < symphonyui.core.FigureHandler
    
    properties (SetAccess = private)
        ampDevice
        preTime
        stimTime
        delayTime
        spotRadius
    end
    
    properties (Access = private)
        axesHandle
        spotHandles
        realCone
        
        realCenter
        responseCharge
        responseX
        responseY
    end
    
    methods
        
        function obj = uLCDgridspotFigure(ampDevice, varargin)
            obj.ampDevice = ampDevice;            
            ip = inputParser();
            ip.addParameter('preTime', [], @(x)isvector(x));
            ip.addParameter('stimTime', [], @(x)isvector(x));
            ip.addParameter('delayTime', [], @(x)isvector(x));
            ip.addParameter('currentX', [], @(x)isvector(x));
            ip.addParameter('currentY', [], @(x)isvector(x));
            ip.addParameter('spotRadius', [], @(x)isvector(x));
            ip.parse(varargin{:});

            obj.preTime = ip.Results.preTime;
            obj.stimTime = ip.Results.stimTime;
            obj.delayTime = ip.Results.delayTime;
            obj.currentX = ip.Results.currentX;
            obj.currentY = ip.Results.currentY;
            obj.spotRadius = ip.Results.spotRadius;
            
            obj.coneCenter = [];
            obj.Charge = [];
            
            obj.createUi();
        end
        
        function createUi(obj)
            import appbox.*;

            obj.axesHandle = axes( ...
                'Parent', obj.figureHandle, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'XTickMode', 'auto');
            xlabel(obj.axesHandle, 'x-direction (pixels)');
            ylabel(obj.axesHandle, 'y-direction (pixels)');
            title(obj.axesHandle,'Receptive Field');
        end

        
        function handleEpoch(obj, epoch)
            %load amp data
            response = epoch.getResponse(obj.ampDevice);
            epochResponseTrace = response.getData();
            sampleRate = response.sampleRate.quantityInBaseUnits;

            epochResponseTrace = epochResponseTrace-mean(epochResponseTrace(1:sampleRate*obj.preTime/1000)); %baseline
            %take (prePts+1:prePts+stimPts+delayPts)
            epochResponseTrace = epochResponseTrace((sampleRate*obj.preTime/1000)+1:(sampleRate*(obj.preTime + obj.stimTime + obj.delayTime)/1000));
            %charge transfer
            currentCharge = trapz(epochResponseTrace(1:sampleRate*(obj.stimTime + obj.delayTime)/1000)); %pA*datapoint
            currentCharge = currentCharge/sampleRate; %pA*sec = pC
            
            currentX = epoch.parameters.currentX;
            currentY = epoch.parameters.currentY;
            obj.spotRadius = epoch.parameters.spotRadius;
            
            obj.Charge = cat(1,obj.Charge,currentCharge);
            obj.responseX = cat(1,obj.responseX,currentX);
            obj.responseY = cat(1,obj.responseY,currentY);
            
            colors=pmkmp(1000,'cubiclblack');
            currColor=round(1000*(currentCharge/max(max(obj.Charge))));
            
            if isempty(obj.spotHandles)
                currIndex=1;
            else
                currIndex=1+length(obj.spotHandles);
            end
            obj.spotHandles{currIndex}=util.drawCircle(currentX,currentY,obj.spotRadius,obj.axesHandle);
            set(obj.spotHandles{currIndex},'color',colors(currColor,:))
        end
        
    end 
end
