function circmo() 
    %   This subroutine "circle"  selects the Ni closest earthquakes
    %   around a interactively selected point.  Resets ZG.newcat and ZG.newt2
    %   Operates on "primeCatalog".
    %
    % axis: hmo
    % plots to: plos as xk
    % inCatalog: a
    % outCatalog: newt2, newcat
    % mouse controlled
    % closest events
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    %  Input Ni:
    %
    report_this_filefun();
    ZG=ZmapGlobal.Data;
    
    delete(findobj('Tag','plos1'))
    
    axes(hmo)

    % interactively get the circle of interest
    shape=ShapeCircle();

    [ZG.newt2, max_km] = selectCircle(newa, shape.toStruct());
    
    disp(['Radius of selected Circle: ' num2str(max_km)  ' km' ])
    
    set(gca,'NextPlot','add')
    plot(ZG.newt2.Longitude,ZG.newt2.Latitude,'xk','Tag','plos1');
    
    ZG.newcat = ZG.newt2;                   % resets ZG.newcat and ZG.newt2
    
    % plot cumulative number
    ctp=CumTimePlot(ZG.newt2);
    ctp.plot();
    
end
