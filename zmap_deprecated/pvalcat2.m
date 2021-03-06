function pvalcat2(catalog) \
    %PVALCAT2 computes a map of p as function of minimum magnitude and initial time
    %Modified May, 2001 Bogdan Enescu
    % turned into function by Celso G Reyes 2017
    
    %This file is called from timeplot.m and helps for the computation of p-value from Omori formula. for different values of Mcut and Minimum time. The value of p is then displayed as a isoline map.
   
    % FIXME : This doesn't produce answers... why? units on the thresholds?
    
    ZG=ZmapGlobal.Data;
    report_this_filefun();
    
    prompt = {'If you wish a fixed c, please enter a negative value'};
    title_str = 'Input parameter';
    lines = 1;
    valeg2 = 2;
    def = {num2str(valeg2)};
    answer = inputdlg(prompt,title_str,lines,def);
    valeg2=str2double(answer{1});
    
    CO = 0; % c-value (initial?)
    if valeg2 <= 0
        prompt = {'Enter c'};
        title_str = 'Input parameter';
        lines = 1;
        def = {num2str(CO)};
        answer = inputdlg(prompt,title_str,lines,def);
        CO=str2double(answer{1});
    end
    
    pvmat = [];
    prompt = {'Min. threshold. magnitude',...
        'Max. threshold magnitude',...
        'Magnit. step',...
        'Min. threshold time', ...
        'Max. threshold time',...
        'Time step'};
    title_str = 'Input parameters';
    lines = 1;
    minThreshMag = min(catalog.Magnitude);
    maxThreshMag = minThreshMag + 2;
    magStep = 0.1;
    minThreshTime = 0;
    maxThreshTime = 0.5;
    timeStep =  0.01 ; % TODO figure out what units this actually is
    def = {num2str(minThreshMag), num2str(maxThreshMag), num2str(magStep), num2str(minThreshTime), num2str(maxThreshTime), num2str(timeStep)};
    answer = inputdlg(prompt,title_str,lines,def);
    minThreshMag=str2double(answer{1});
    maxThreshMag = str2num(answer{2});
    magStep=str2num(answer{3});
    minThreshTime = days(str2double(answer{4}));
    maxThreshTime = days(str2num(answer{5}));
    timeStep = days(str2num(answer{6}));
    
    if ~ensure_mainshock()
        return
    end
    % cut catalog at mainshock time:
    l = catalog.Date > ZG.maepi.Date(1);
    catalog = catalog.subset(l);
    
    % cat at selecte magnitude threshold
    l = catalog.Magnitude >= minThreshMag;
    catalog = catalog.subset(l);
    
    ZG.hold_state2=true;
    ctp=CumTimePlot(catalog);
    ctp.plot();
    drawnow
    ZG.hold_state2=false;
    
    allcount = 0;
    itotal = length(minThreshMag:magStep:maxThreshMag) * length(minThreshTime:timeStep:maxThreshTime);
    wai = waitbar(0,' Please Wait ...  ');
    set(wai,'NumberTitle','off','Name',' 3D gridding - percent done');
    drawnow
    mainshockDate = ZG.maepi.Date(1);
    timeSinceMainshock = catalog.Date - mainshockDate;
    
    for valm = minThreshMag:magStep:maxThreshMag
        paramc1 = (catalog.Magnitude >= valm);
        pcat = mainshockDate + timeSinceMainshock(paramc1); 
        
        for valtm = minThreshTime:timeStep:maxThreshTime
            allcount = allcount + 1;
            
            paramc2 = pcat >= (mainshockDate+valtm);
            [pv, pstd, cv, cstd, kv, kstd] = mypval2m(pcat(paramc2),catalog.Magnitude(paramc2),'date',valeg2,CO,minThreshMag);
            
            
            if isnan(pv)
                disp('Not a value');
            end
            pvmat = [pvmat; valm days(valtm) pv pstd cv cstd kv kstd];
            waitbar(allcount/itotal)
            
        end
    end
    
    close(wai)
    pmap=findobj('Type','Figure','-and','Name','p-value map');
    
    
    if isempty(pmap)
        pmap = figure_w_normalized_uicontrolunits( ...
            'Name','p-value-map',...
            'NumberTitle','off', ...
            'NextPlot','new', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',position_in_current_monitor(ZG.map_len(1), ZG.map_len(2)));
    end
    
    figure(pmap);
    delete(findobj(pmap,'Type','axes'));
    set(gca,'NextPlot','add');
    axis off
    
    
    X1 = [minThreshMag:magStep:maxThreshMag]; m = length(X1);
    Y1= [minThreshTime:timeStep:maxThreshTime]; n=length(Y1);
    
    [X,Y] = meshgrid(minThreshMag:magStep:maxThreshMag,minThreshTime:timeStep:maxThreshTime);
    %The following line can be modified to display other maps: c, k or b - for b other few lines have to be added.
    Z = reshape(pvmat(:,3), n, m);
    clear X1; clear Y1;
    pcolor(X,days(Y),Z);
    shading flat
    ylabel(['c in days'])
    xlabel(['Min. Magnitude'])
    shading interp
    set(gca,'box','on',...
        'SortMethod','childorder','TickDir','out',...
        'FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1,'Ticklength',[ 0.02 0.02])
    
    
    % Create a colorbar
    %
    h5 = colorbar('horiz');
    set(h5,'Pos',[0.35 0.08 0.4 0.02],...
        'FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s,'TickDir','out')
    
    rect = [0.00,  0.0, 1 1];
    axes('position',rect)
    axis('off')
    %  Text Object Creation
    txt1 = text(...
        'Units','normalized',...
        'Position',[ 0.33 0.09 0 ],...
        'HorizontalAlignment','right',...
        'FontSize',ZmapGlobal.Data.fontsz.m,....
        'String','p-value');
end
