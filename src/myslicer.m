function myslicer(ac2) 
    % MYSLICER
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    global pli
    sl1=[]; % used to track my axes
    if ~exist('ac2','var')
        ac2 = 'new';
    end
    
    switch(ac2)
        case 'load'
            my_load()
        case 'new'
            my_new();
        case 'topo'
            my_topo();
        case 'topos'
            my_topos();
        case 'equal'
            my_equal();
        case 'setr'
            my_setr();
        case 'setc'
            my_setc();
    end
    
    %% behavioral functions
    
    function my_load()
        [file1,path1] = uigetfile( '*.mat',' 3D b-value gridfile ');
        %
        if length(path1) < 2
            return
        else
            lopa = [path1 file1];
            messtext=...
                ['Thank you! Now loading data'
                'Hang on...                 '];
            ZmapMessageCenter.set_message('  ',messtext);
            
            try
                load(lopa)
            catch ME
                error_handler(ME,'Error loading data! Are they in the right *.mat format?');
            end
        end
        if ~exist('zv2','var'); zv2 = zvg; end
        if ~exist('R','var') ; R = 5; end
        my_new();
        
    end
    
    function my_new()
        
        mac = max(zv2(:))-0.05;
        mic = min(zv2(:));
        
        
        slfig = figure_w_normalized_uicontrolunits( ...
            'Name','3D Data Slicer',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'NextPlot','add', ...
            'Visible','on', ...
            'Position',[ (ZG.fipo(3:4) - [600 500]) 800 800],...
            'Tag','3dslicerfig');
        movegui(slfig,'center');
        
        uicontrol('Units','normal',...
            'Position',[.45 .88 .2 .06],'String','Define X-section ',...
            'callback',@callbackfun_001)
        
        uicontrol('BackGroundColor',[0.8 0.8 0.6],'Units','normal',...
            'Position',[.0 .93 .2 .06],'String','Refresh ',...
            'callback',@(~,~)my_newax())
        
        uicontrol('Units','normal',...
            'Position',[.3 .8 .2 .06],'String','New vert. Slice ',...
            'callback',@(~,~)my_newslice())
        
        
        uicontrol('Units','normal',...
            'Position',[.6 .8 .2 .06],'String','Add vert Slice ',...
            'callback',@(~,~)my_addslice())
        
        
        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.3 .72 .2 .06],'String','New horz. Slice ',...
            'callback',@(~,~)my_newhorslice())
        
        
        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.6 .72 .2 .06],'String','Add horz. Slice ',...
            'callback',@(~,~)my_addhorslice())
        
        uicontrol('BackGroundColor',[0.8 0.8 0.6],'Units','normal',...
            'Position',[.0 .0 .2 .06],'String','Help',...
            'callback',@(~,~)my_help)
        
        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .83 .2 .06],'String','Show b-value (wls)',...
            'callback',@(~,~)@callbackfun_008)
        
        
        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .73 .2 .06],'String','Show goodness of fit ',...
            'callback',@callbackfun_showgoodness)
        
        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .63 .2 .06],'String','Show Mc ',...
            'callback',@callbackfun_010)
        
        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .53 .2 .06],'String','Show Resolution ',...
            'callback',@callbackfun_011)
        
        uicontrol('Units','normal',...
            'Position',[.85 .95 .15 .04],'String','Slicer-map',...
            'callback',@callbackfun_012)
        
        
        axis off
        my_newax();
        
    end
    
    function my_newax()
        try
            delete(sl1)
        catch ME
            error_handler(ME, @do_nothing);
        end
        % Plot the first axes - the map to select xsec orientation
        axes('position',[0.35,  0.10, 0.55, 0.45]);
        
        dep1 = 0.3*max(ZG.primeCatalog.Depth); dep2 = 0.6*max(ZG.primeCatalog.Depth); dep3 = max(ZG.primeCatalog.Depth);
        
        deplo1 =plot(ZG.primeCatalog.aLongitude(ZG.primeCatalog.Depth<=dep1),ZG.primeCatalog.Latitude(ZG.primeCatalog.Depth<=dep1),'.b'); hold
        set(deplo1,'MarkerSize',ZG.ms6,'Marker',ty1)
        deplo2 =plot(ZG.primeCatalog.Longitude(ZG.primeCatalog.Depth<=dep2&ZG.primeCatalog.Depth>dep1),ZG.primeCatalogLatitude(ZG.primeCatalog.Depth<=dep2&ZG.primeCatalog.Depth>dep1),'.g');
        set(deplo2,'MarkerSize',ZG.ms6,'Marker',ty2);
        deplo3 =plot(ZG.primeCatalog.Longitude(ZG.primeCatalog.Depth<=dep3&ZG.primeCatalog.Depth>dep2),ZG.primeCatalog.Latitude(ZG.primeCatalog.Depth<=dep3&ZG.primeCatalog.Depth>dep2),'.r');
        set(deplo3,'MarkerSize',ZG.ms6,'Marker',ty3)
        hold on;
        
        zmap_update_displays();
        whitebg(gcf,[0 0 0]);
        sl1 = gca; axis equal
        axis([ s2 s1 s4 s3])
    end
    
    function my_newslice()
        
        zvg = zv2;
        l = ram > R;
        zvg(l)=nan;
        zv2 = zvg;
        
        prev = 'ver';
        try
            x = get(pli,'Xdata');
        catch ME
            errordlg(' Please Define a X-section first! ');
            return;
        end
        y = get(pli,'Ydata');
        gx2 = linspace(x(1),x(2),30);
        gy2 = linspace(y(1),y(2),30);
        gz2 = linspace(min(gz),max(gz),30);
        
        [Y2,Z2] = meshgrid(gy2,gz2);
        X2 = repmat(gx2,30,1);
        
        [X,Y,Z] = meshgrid(gy,gx,gz);
        
        sl2=findobj('Type','Figure','-and','Name','Slice');
        
        if ~exist(sl2)
            chooseint();
            sl2=findobj('Type','Figure','-and','Name','Slice');
        else
            figure(sl2)
            delete(findobj(sl2,'Type','axes'));
        end
        
        hold on;
        my_plotslice();
        
    end
    
    function my_addslice()
        
        zvg = zv2;
        l = ZG.ra > R;
        zvg(l)=nan;
        prev = 'ver';
        
        try
            x = get(pli,'Xdata');
        catch ME
            error_handler(ME,@do_nothing);
            errordlg(' Please Define a X-section first! ');
            return
        end
        y = get(pli,'Ydata');
        gx2 = linspace(x(1),x(2),30);
        gy2 = linspace(y(1),y(2),30);
        gz2 = linspace(min(gz),max(gz),30);
        
        [Y2,Z2] = meshgrid(gy2,gz2);
        X2 = repmat(gx2,30,1);
        
        my_plotslice();
    end
    
    function my_addhorslice()
        
        def = {'33'};
        ni2 = inputdlg('Depth of horizontal slice in [km]','Input',1,def);
        l = ni2{:};
        ds = str2double(l);
        prev = 'hor';
        
        
        zvg = zv2;
        l = ZG.ra > R;
        zvg(l)=nan;
        
        
        gx2 = linspace(min(gx),max(gx),30);
        gy2 = linspace(min(gy),max(gy),30);
        gz2 = linspace(min(gz),max(gz),30);
        
        [X2,Y2] = meshgrid(gx2,gy2);
        Z2 = (X2*0 - ds);
        my_plotslice();
    end
    
    function my_newhorslice()
        
        def = {'33'};
        ni2 = inputdlg('Depth of horizontal slice in [km]','Input',1,def);
        l = ni2{:};
        ds = str2double(l);
        prev = 'hor';
        
        
        zvg = zv2;
        l = ZG.ra > R;
        zvg(l)=nan;
        
        %y = get(pli,'Ydata');
        gx2 = linspace(min(gx),max(gx),30);
        gy2 = linspace(min(gy),max(gy),30);
        gz2 = linspace(min(gz),max(gz),30);
        
        [X,Y,Z] = meshgrid(gy,gx,gz);
        [X2,Y2] = meshgrid(gx2,gy2);
        Z2 = (X2*0 - ds);
        
        sl2=findobj('Type','Figure','-and','Name','Slice');
        
        if ~exist(sl2);
            chooseint();
        else
            figure(sl2)
            delete(findobj(sl2,'Type','axes'));
        end
        
        hold on;
        my_plotslice();
    end
    
    function my_plotslice()
        figure(sl2)
        delete(findobj(sl2,'Type','axes'));
        hold on; axis manual ; axis ij
        
        sl = slice(X,Y,Z,zvg,Y2,X2,Z2);
        if prev == 'hor'; set(sl,'tag','slice'); end
        box on
        rotate3d on
        shading interp
        axis([min(gy) max(gy) min(gx) max(gx) min(gz) max(gz)+1 ]);
        view([-120 24]); box on;
        hold on
        whitebg(gcf,[0 0 0]);
        
        cl = coastline;
        l = cl(:,1) > min(gx) & cl(:,1) < max(gx) & cl(:,2) > min(gy) & cl(:,2) < max(gy);
        cl = cl*inf; cl(l,:) = coastline(l,:);
        if prev == 'hor' % plot coastline
            plot3(cl(:,2),cl(:,1),cl(:,2)*0-ds,'color',[0.5 0.5 0.5])
        end
        
        
        ax = axis;
        f = findobj('tag','slice');
        if ~isempty(f)
            set(f(:),'EdgeColor',[0.3 0.3 0.3 ]);
            
        end
        
        caxis([mic mac])
        
        set(gca,'FontSize',12,'FontWeight','bold');
        set(gcf,'Color','k','InvertHardcopy','off');
        slax = gca;
        
        [mic, mac] = caxis;
        vx =  (mic:0.1:mac);
        v = [vx ; vx];
        v = v';
        rect = [0.82 0.03 0.015 0.25];
        ax3=axes('position',rect);
        pcolor((1:2),vx,v);
        shading interp
        set(ax3,'XTickLabels',[])
        set(ax3,'FontSize',12,'FontWeight','bold',...
            'LineWidth',1.0,'YAxisLocation','right',...
            'Box','on','SortMethod','childorder','TickDir','out','Tag','ax3');
        ij = flipud(jet);
        colormap(jet);
        axes(slax);
        set(slax,'pos',[0.15 0.1 0.6 0.8]);
    end
    
    function tmap=general_topo(nanval,spacing)
        s1 = max(gx); s2 = min(gx);
        s3 = max(gy); s4 = min(gy);
        region = [s4 s3 s2 s1];
        if ~exist('mydem','var')
            try
                [mydem,my,mx] = mygrid_sand(region);
            catch ME
                error_handler(ME, @do_nothing);
                plt = 'err2';
                pltopo
            end
        end
        
        if max(mx) > 180; mx = mx-360;end
        
        l2 = min(find(mx >= s2));
        l1 = max(find(mx <= s1));
        l3 = max(find(my <= s3));
        l4 = min(find(my >= s4));
        tmap = mydem(l4:l3,l2:l1);
        vlat = my(l4:l3);
        vlon = mx(l2:l1);
        if max(vlon) > 180
            vlon = vlon - 360;
        end
        tmap(isnan(tmap))=nanval;
            
        [m,n] = size(tmap);
        
        axes(slax); 
        axis off;
        po = get(slax,'pos');
        axes('pos',[po]);
        
        [xx,yy]=meshgrid(vlon,vlat);
        surf(yy,xx,tmap/spacing),shading interp;
    end
    
    function general_topo_endpart(tmap,spacing)
        % TOFIX ax comes from elsewhere
        axis([ax]); axis ij
        ax2 = gca; box on ; grid off
        
        set(gca,'FontSize',14,'FontWeight','bold',...
            'LineWidth',1.5,...
            'Box','on','SortMethod','childorder','TickDir','out')
        set(ax2,'view',get(slax,'view'))
        set(ax2,'Color','none')
        
        [tco, clim] = demcmap(tmap/spacing,64);
        caxis([clim(1) clim(2)]);
        
        set(slax,'CLim',newclim(65,128,mic,mac,128))
        set(ax3,'CLim',newclim(65,128,mic,mac,128))
        set(ax2,'CLim',newclim(3,63,clim(1),clim(2),128))
        hold on
    end
    
    function my_topo()
        tmap=general_topo(nan,1000);
        
        hc = jet(64);
        mycolormap = [tco; hc];
        colormap(mycolormap)
        
        general_topo_endpart(tmap,1000)
    end
    
    function my_topos()
        tmap=general_topo(-100,400);
        
        li = light('Position',[ 5 0  100],'Style','infinite');
        li = light('Position',[ 0 5  100],'Style','infinite');
        material([.2 .2 0.6]);
        lighting gouraud
        
        hc2 = gray(64); hc2 = hc2(64:-1:1,:);
        mycolormap = [hc2; jet(64)];
        colormap(mycolormap)
        
        general_topo_endpart(1000);
    end
    
    function my_topos2()
        tmap = general_topo(-100,800);
        
        li = light('Position',[ 5 0  100],'Style','infinite');
        li = light('Position',[ 0 5  100],'Style','infinite');
        material dull;
        lighting phong;
        
        hc = jet(64);
        mycolormap = [tco; hc];
        colormap(mycolormap)
        
        general_topo_endpart(tmap,800);
    end
    
    function my_help()
        try
            web([hodi '/help/3dgrid.htm']);
        catch ME
            errordlg(' Error while opening, please open the browser first and try again or open the file ./help/slicer.hmt manually');
        end
    end
    
    function my_equal()
        set(slax,'view',get(ax2,'view'));
    end
    
    function my_setr()
        
        def = {num2str(mean(mean(mean(ZG.ra))))};
        ni2 = inputdlg('Maximum radius of sphere to be plotted [km]','Input',1,def);
        l = ni2{:};
        R = str2double(l);
    end
    
    function my_setc()
        mac = max(zv2(:));
        mic = min(zv2(:));
        
        def = {num2str(mac), num2str(mic)};
        prompt = {'Maximum Color scale','Minimu Color scale'};
        ni2 = inputdlg(prompt,'Input',1,def);
        l = ni2{1};
        mac = str2double(l);
        l = ni2{2};
        mic = str2double(l);
        caxis([mic mac]);
        
        l = zv2 < mic;
        zv2(l) = mic;
        l = zv2 > mac;
        zv2(l) = mac;
    end
    
    %% callback functions
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        figure(findobj('Tag','3dslicerfig'));
        animator('start',[]);
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zv2 = zvg;
    end
    
    function callbackfun_showgoodness(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zv2 = go;
    end
    
    function callbackfun_010(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zv2 = mcma;
    end
    
    function callbackfun_011(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zv2 = ZG.ra;
    end
    
    function callbackfun_012(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        slicemap();
    end
    
end
