classdef vPulseFamilyIVFigure < symphonyui.core.FigureHandler
    % Plots the mean response of a specified device for all epochs run.
    
    properties (SetAccess = private)
        device
        prepts
        stmpts
        nPulses
        pulseAmp
        
        groupBy
        sweepColor
        storedSweepColor
    end
    
    properties (Access = private)
        axH
        sweeps
        storedSweeps
        pulseResp
        ivH
        currPulseIndex
    end
    
    methods
        
        function obj = vPulseFamilyIVFigure(device, varargin)
            co = get(groot, 'defaultAxesColorOrder');
            
            ip = inputParser();
            ip.addParameter('prepts', [], @(x)isvector(x));
            ip.addParameter('stmpts', [], @(x)isvector(x));
            ip.addParameter('nPulses', [], @(x)isnumeric(x));
            ip.addParameter('pulseAmp', [], @(x)isvector(x));
            
            ip.addParameter('groupBy', [], @(x)iscellstr(x));
            ip.addParameter('sweepColor', co(1,:), @(x)ischar(x) || isvector(x));
            ip.addParameter('storedSweepColor', 'r', @(x)ischar(x) || isvector(x));
            
            ip.parse(varargin{:});
            
            obj.device = device;
            obj.prepts = ip.Results.prepts;
            obj.stmpts = ip.Results.stmpts;
            
            obj.nPulses = ip.Results.nPulses;
            obj.pulseAmp = ip.Results.pulseAmp;
            obj.pulseResp = zeros(size(obj.pulseAmp));

            obj.groupBy = ip.Results.groupBy;
            obj.sweepColor = ip.Results.sweepColor;
            obj.storedSweepColor = ip.Results.storedSweepColor;
            
            obj.currPulseIndex = 0;
            
            obj.createUi();
        end
        
        function createUi(obj)
            import appbox.*;
            
            obj.axH=gobjects(2,1);
            
            toolbar = findall(obj.figureHandle, 'Type', 'uitoolbar');
            storeSweepsButton = uipushtool( ...
                'Parent', toolbar, ...
                'TooltipString', 'Store Sweeps', ...
                'Separator', 'on', ...
                'ClickedCallback', @obj.onSelectedStoreSweeps);
            setIconImage(storeSweepsButton, symphonyui.app.App.getResource('icons', 'sweep_store.png'));
            
            obj.axH(1) = axes(...
                'Position',[.05 .1 .42 .85],...
                'Parent', obj.figureHandle, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'XTickMode', 'auto');
            xlabel(obj.axH(1), 'time(s)');
            obj.sweeps = {};
            obj.setTitle([obj.device.name ' Mean Response']);
            
            
            obj.axH(2) = axes(...
                'Position',[.525 .1 .42 .85],...
                'Parent', obj.figureHandle, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'XTickMode', 'auto');
            xlabel(obj.axH(2), 'V (mV)');
            ylabel(obj.axH(2), 'I (pA)');
            
            obj.ivH=gobjects(obj.nPulses,1);
            
            colors=util.pmkmp(obj.nPulses);
            for i=1:obj.nPulses
                obj.ivH(i) = line(obj.pulseAmp(i),obj.pulseResp(i),'Parent',obj.axH(2));
                set(obj.ivH(i),'Marker','o','Color',colors(i,:),'MarkerFaceColor',colors(i,:));
            end
            
            line(obj.pulseAmp,obj.pulseResp,'Parent',obj.axH(2),'Marker','none','Color',[.7 .7 .7],'LineStyle','--')
        end
        
        function setTitle(obj, t)
            set(obj.figureHandle, 'Name', t);
            title(obj.axH(1), t);
        end
        
        function clear(obj)
            cla(obj.axH(1));
            obj.sweeps = {};
        end
        
        function handleEpoch(obj, epoch)
            if ~epoch.hasResponse(obj.device)
                error(['Epoch does not contain a response for ' obj.device.name]);
            end
            
            response = epoch.getResponse(obj.device);
            [quantities, units] = response.getData();
            if numel(quantities) > 0
                x = (1:numel(quantities)) / response.sampleRate.quantityInBaseUnits;
                y = quantities;
            else
                x = [];
                y = [];
            end
            
            p = epoch.parameters;
            if isempty(obj.groupBy) && isnumeric(obj.groupBy)
                parameters = p;
            else
                parameters = containers.Map();
                for i = 1:length(obj.groupBy)
                    key = obj.groupBy{i};
                    parameters(key) = p(key);
                end
            end
            
            if isempty(parameters)
                t = 'All epochs grouped together';
            else
                t = ['Grouped by ' strjoin(parameters.keys, ', ')];
            end
            obj.setTitle([obj.device.name ' Mean Response (' t ')']);
            
            sweepIndex = [];
            for i = 1:numel(obj.sweeps)
                if isequal(obj.sweeps{i}.parameters, parameters)
                    sweepIndex = i;
                    break;
                end
            end
            
            if isempty(sweepIndex)
                sweep.line = line(x, y, 'Parent', obj.axH(1), 'Color', obj.sweepColor);
                sweep.parameters = parameters;
                sweep.count = 1;
                obj.sweeps{end + 1} = sweep;
            else
                sweep = obj.sweeps{sweepIndex};
                cy = get(sweep.line, 'YData');
                set(sweep.line, 'YData', (cy * sweep.count + y) / (sweep.count + 1));
                sweep.count = sweep.count + 1;
                obj.sweeps{sweepIndex} = sweep;
            end
            
            ylabel(obj.axH(1), units, 'Interpreter', 'none');
            
            obj.currPulseIndex = mod(obj.currPulseIndex+1,obj.nPulses);
            if obj.currPulseIndex==0
                obj.currPulseIndex=obj.nPulses;
            end
            
            pulseResp = mean(y(obj.prepts+obj.stmpts*3/4:obj.prepts+obj.stmpts));
            
            set(obj.ivH(obj.currPulseIndex),'YData',pulseResp);
        end
        
    end
    
    methods (Access = private)
        
        function onSelectedStoreSweeps(obj, ~, ~)
            if ~isempty(obj.storedSweeps)
                for i = 1:numel(obj.storedSweeps)
                    delete(obj.storedSweeps{i});
                end
                obj.storedSweeps = {};
            end
            for i = 1:numel(obj.sweeps)
                obj.storedSweeps{i} = copyobj(obj.sweeps{i}.line, obj.axH(1));
                set(obj.storedSweeps{i}, ...
                    'Color', obj.storedSweepColor, ...
                    'HandleVisibility', 'off');
            end
        end
        
    end
        
end

