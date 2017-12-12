function LC_borde(line_type,line_thick)
    
    %LC_PLOT_BORDER
    %
    %	LC_plot_border(line_type,line_thick)
    %
    %	Function to plot a border on the map generated by LC_MAP
    %	LINE_TYPE is any of the line types used by the PLOT command.
    %	LINE_THICK is the width of the line in "points".
    %	   (1 point = 1/72 inch).
    %	If no values are given, it will use the defaults: '-' & 2.
    %
    %	NOTE: The LC_MAP function has to have been called first
    %	to set some required global variables.
    
    report_this_filefun(mfilename('fullpath'));
    
    global torad
    global maxlatg minlatg maxlong minlong
    
    if nargin < 2
        line_thick = 2;
        if nargin < 1
            line_type = '-';
        end
    end
    
    bdlon(1:100) = minlong:(maxlong-minlong)/99:maxlong;
    bdlon(101:200) = ones(1,100) * maxlong;
    bdlon(201:300) = maxlong:-(maxlong-minlong)/99:minlong;
    bdlon(301:400) = ones(1,100) * minlong;
    
    bdlat(1:100) = ones(1,100) * maxlatg;
    bdlat(101:200) = maxlatg:-(maxlatg-minlatg)/99:minlatg;
    bdlat(201:300) = ones(1,100) * minlatg;
    bdlat(301:400) = minlatg:(maxlatg-minlatg)/99:maxlatg;
    
    [xbd, ybd] = lc_tocart(bdlat,bdlon);
    
    plot(xbd,ybd,line_type,'LineWidth',line_thick)
    
end