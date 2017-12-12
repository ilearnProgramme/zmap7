function nlammap2() % autogenerated function wrapper
    % lammap2 displays a map view of the seismicity in Lambert projection and ask for two input
    % points select with the cursor. These input points are
    % the endpoints of the crossection.
    %
    % Stefan Wiemer 2/95
    
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals

    report_this_filefun(mfilename('fullpath'));
    
    xpos = get(gca,'pos');
    set(gca,'pos',[0.15 0.3 0.8 0.4]);
    figure(xsec_fig);
    
    try
        
        if ~isempty(vo)
            [vox, voy] = lc_xsec2(vo.Latitude',vo.Longitude',vo.Longitude*0,ZG.xsec_width_km,leng,lat1,lon1,lat2,lon2);
        end
        
        if ~isempty(ZG.maepi)
            [maex, maey] = lc_xsec2(ZG.maepi.Latitude',ZG.maepi.Longitude',ZG.maepi.Depth,ZG.xsec_width_km,leng,lat1,lon1,lat2,lon2);
        end
        
        if ~isempty(well)
            i = find(well(:,1) == inf);wellx = []; welly = [];
            for k = 1:length(i)-1
                [wx, wy] = lc_xsec2(well(i(k):i(k+1),2)',well(i(k):i(k+1),1)',well(i(k):i(k+1),3),ZG.xsec_width_km,leng,lat1,lon1,lat2,lon2);
                [m1,m2] = size(wy) ; if m1 > m2 ; wy = wy', end
                wellx = [wellx  inf  wx];
                welly = [welly  inf  wy];
            end
        end
        
        if ~isempty(main)
            [maix, maiy] = lc_xsec2(main(:,2)',main(:,1)',main(:,1)*0,ZG.xsec_width_km,leng,lat1,lon1,lat2,lon2);
            maiy = -maiy;
        end
        
        
        if exist('maix', 'var')
            hold on
            pl = plot(maix,maiy,'*k');
            set(pl,'MarkerSize',12,'LineWidth',2)
        end
        
        if exist('maex', 'var')
            hold on
            pl = plot(maex,-maey,'hk');
            set(pl,'LineWidth',1.5,'MarkerSize',12,...
                'MarkerFaceColor','y','MarkerEdgeColor','k')
            
        end
        
        if exist('vox', 'var')
            hold on
            plovo = plot(vox,-voy,'^r')
            set(plovo,'LineWidth',1.5,'MarkerSize',6,...
                'MarkerFaceColor','w','MarkerEdgeColor','r');
        end
        
        if exist('wellx', 'var')
            hold on
            plwe = plot(wellx,-welly,'k')
            set(plwe,'LineWidth',2);
        end
        
    catch
    end
    
    create_my_menu();
    figure(mapl);
    uic2 = uicontrol('BackGroundColor',[0.9 0.9 0.9],'Units','normal',...
        'Position',[.8 .92 .20 .06],'String','Refresh ',...
        'callback',@cb_refresh);
    % create the selected catalog
    %
    newa  = ZG.primeCatalog.subset(inde);
    % Check size of catalog, then decide where to put the xsex values
    [nY,nX] = size(a);
    % if nX < 11
    newa = [newa xsecx'];
    %     disp('xsecx values stored in last column!');
    % else
    %     newa(:,11) = xsecx';
    %     disp('xsecx values stored in column 11!');
    % end
    sel = 'in';
    
    
    %% ui functions
    function create_my_menu()
        add_menu_divider();
        options = uimenu('Label','Select');
        uimenu(options,'Label','Select EQ inside Polygon ',...
            'callback',@cb_select_eq_inside_poly);
        uimenu(options,'Label','Refresh ',...
            'callback',@cb_refresh);
        
        options = uimenu('Label','Ztools');
        
        
        uimenu(options,'Label', 'differential b ',...
            'callback',@cb_diff_b);
        
        uimenu(options,'Label','Fractal Dimension',...
            'callback',@cb_fractaldim);
        
        uimenu(options,'Label','Mean Depth',...
            'callback',@cb_meandepth);
        
        uimenu(options,'Label','z-value grid',...
            'callback',@cb_zvaluegrid);
        
        uimenu(options,'Label','b and Mc grid ',...
            'callback',@cb_b_mc_grid);
        
        uimenu(options,'Label','Prob. forecast test',...
            'callback',@cb_probforecast_test);
        
        uimenu(options,'Label','beCubed',...
            'callback',@cb_becubed);
        
        uimenu(options,'Label','b diff (bootstrap)',...
            'callback',@cb_b_diff_boot);
        
        uimenu(options,'Label','Stress Variance',...
            'callback',@cb_stressvariance);
        
        
        uimenu(options,'Label','Time Plot ',...
            'callback',@cb_timeplot);
        
        uimenu(options,'Label',' X + topo ',...
            'callback',@cb_xplustopo);
        
        uimenu(options,'Label','Vert. Exaggeration',...
            'callback',@cb_vertexaggeration);
        
        uimenu(options,'Label','Rate change grid',...
            'callback',@cb_ratechangegrid);
        
        uimenu(options,'Label','Omori parameter grid',...
            'callback',@cb_omoriparamgrid); % formerly pcross
        
    end
    
    %% callback functions
    
    function cb_select_eq_inside_poly(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        stri = 'Polygon';
        selectp;
    end
    
    function cb_refresh(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        [xsecx xsecy,  inde] =mysect(tmp1,tmp2,ZG.primeCatalog.Depth,ZG.xsec_width_km,0,lat1,lon1,lat2,lon2);
    end
    
    function cb_diff_b(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1=gca;
        bcrossVt2();
    end
    
    function cb_fractaldim(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        Dcross();
    end
    
    function cb_meandepth(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        meandepx;
    end
    
    function cb_zvaluegrid(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        magrcros();
    end
    
    function cb_b_mc_grid(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        sel = 'in';
        bcross(sel);
    end
    
    function cb_probforecast_test(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rContainer.fXSWidth = ZG.xsec_width_km;
        rContainer.Lon1 = lon1;
        rContainer.Lat1 = lat1;
        rContainer.Lon2 = lon2;
        rContainer.Lat2 = lat2;
        pt_start(newa, xsec_fig, 0, rContainer, name);
    end
    
    function cb_becubed(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rContainer.fXSWidth = ZG.xsec_width_km;
        rContainer.Lon1 = lon1;
        rContainer.Lat1 = lat1;
        rContainer.Lon2 = lon2;
        rContainer.Lat2 = lat2;
        bc_start(newa, xsec_fig, 0, rContainer);
    end
    
    function cb_b_diff_boot(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rContainer.fXSWidth = ZG.xsec_width_km;
        rContainer.Lon1 = lon1;
        rContainer.Lat1 = lat1;
        rContainer.Lon2 = lon2;
        rContainer.Lat2 = lat2;
        st_start(newa, xsec_fig, 0, rContainer);
    end
    
    function cb_stressvariance(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        cross_stress();
    end
    
    function cb_timeplot(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        timcplo;
    end
    
    function cb_xplustopo(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        xsectopo;
    end
    
    function cb_vertexaggeration(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        vexa;
    end
    
    function cb_ratechangegrid(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rc_cross_a2();
    end
    
    function cb_omoriparamgrid(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        calc_Omoricross();
    end
    
    function cb_refresh(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        delete(uic2);
        delete(findobj(mapl,'Type','axes'));
        nlammap2;
    end
    
end
