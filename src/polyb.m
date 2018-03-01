function polyb() % autogenerated function wrapper
    %function crosssel
    % crosssel.m                      Alexander Allmann
    % function to select earthquakes in a cross-section and make them the
    % current catalog in the main map windo
    %
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    
    global h2 newa
    
    report_this_filefun(mfilename('fullpath'));
    
    figNumber=findobj('Type','Figure','-and','Name','b-value cross-section');
    figure(figNumber);
    
    %loop to pick points
    %axes(h2)
    hold on
    ax = mainmap('axes');
    [x,y, mouse_points_overlay] = select_polygon(ax);
    
    plot(x,y,'b-');
    YI = -newa(:,7);          % this substitution just to make equation below simple
    XI = newa(:,end);
    ll = polygon_filter(x,y, XI, YI, 'inside');
    
    %plot the selected eqs and mag freq curve
    newa2 = newa.subset(ll);
    ZG.newt2 = newa2;
    newcat = newa.subset(ll);
    pl = plot(newa2(:,end),-newa2(:,7),'xk');
    set(pl,'MarkerSize',5,'LineWidth',1)
    bdiff(newa2)
end
