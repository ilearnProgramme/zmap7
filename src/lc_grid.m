function LC_grid(line_type,line_width)
    
    %LC_PLOT_GRID
    %
    %	LC_plot_grid(line_type,line_width)
    %
    %	Function to plot a grid on the map generated by LC_MAP
    %	This function sets the size of the grid automatically according
    %	to the scale of the map.
    %	LINE_TYPE is the grid line style as available for the PLOT command
    %	(ie: [ - | -- | : | -. ]). The default is [ - ].
    %	LINE_WIDTH is the line thickness to be used for the grid. It has
    %	to be a value > [0.01].
    %
    %	NOTE: The LC_MAP function has to have been called before
    %	you can use this function as it needs some global variables
    %	to be set.
    
    report_this_filefun(mfilename('fullpath'));
    
    global torad
    global maxlatg minlatg maxlong minlong
    
    if nargin < 2
        line_width = [0.01];
        if nargin < 1
            line_type = '-';
        end
    end
    
    dlat = maxlatg - minlatg;
    dlon = maxlong - minlong;
    
    % figure out the grid increment for latitude and longitude
    if fix(dlat / 5) >= 1
        latinc = infix(dlat / 5);
    else
        if 2.5 < round(dlat)  && round(dlat) <= 5
            latinc = 1;
        elseif 1.5 < round(dlat)  &&  round(dlat) <= 2.5
            latinc = 1/2;
        else
            latinc = 1/4;
        end
    end
    
    if fix(dlon / 5) >= 1
        loninc = infix(dlon / 5);
    else
        if 2.5 < round(dlon)  && round(dlon) <= 5
            loninc = 1;
        elseif 1.5 < round(dlon)  &&  round(dlon) <= 2.5
            loninc = 1/2;
        else
            loninc = 1/4;
        end
    end
    
    % figure out at which latitude/longitude the grid starts
    % This is the best trick I found to do this in one step!
    ylatgr1 = ceil(minlatg/latinc)*latinc;
    xlongr1 = ceil(minlong/loninc)*loninc;
    
    % plot the parallel grid & labels
    k = 1;
    while ylatgr1 + (latinc * (k-1)) < maxlatg
        xlatgr = minlong:dlon/99:maxlong;
        ylatgr = ones(1,100) .* (ylatgr1 + (latinc * (k-1)));
        [x, y] = lc_tocart(ylatgr,xlatgr);
        plot(x,y,'LineWidth',line_width,'LineStyle',line_type)
        text(x(1),y(1),[num2str(ylatgr(1)) blanks(1)],'Units','data',...
            'HorizontalAlignment','right','VerticalAlignment','middle',...
            'FontWeight','bold','FontSize',12)
        k = k + 1;
    end
    
    % plot the meridian grid & labels
    k = 1;
    while xlongr1 + (loninc * (k-1)) < maxlong
        xlongr = ones(1,100) .* (xlongr1 + (loninc * (k-1)));
        ylongr = minlatg:dlat/99:maxlatg;
        [x, y] = lc_tocart(ylongr,xlongr);
        plot(x,y,'LineWidth',line_width,'LineStyle',line_type)
        text(x(1),y(1),[num2str(xlongr(1),5) blanks(1)],'Units','data',...
            'HorizontalAlignment','center','VerticalAlignment','top',...
            'FontWeight','bold','FontSize',12)
        
        k = k + 1;
    end
    
end
