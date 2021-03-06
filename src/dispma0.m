function dispma0() 
    % selects t1p, t2p and t3p calls displaymagsig to calc Mag Signatures
    %
    % turned into function by Celso G Reyes 2017
    
    % FIXME not attached to any specific figure
    report_this_filefun();
    
    seti = uicontrol('Units','normal','Position',[.5 .01 .2 .05],'String','Select T1  ');
    
    pause(1)
    
    par2 = 0.1 * max(cumu2);
    par3 = 0.12 * max(cumu2);
    t1 = ginput(1);
    t1p = [  t1 ; t1(1) t1(2)-par2; t1(1)   t1(2)+par2 ];
    plot(t1p(:,1),t1p(:,2),'r')
    text( t1(1),t1(2)+par3,['t1: ', num2str(t1p(1))] )
    
    set(seti','String','Select T2')
    
    pause(1)
    
    t2 = ginput(1);
    t2p = [  t2 ; t2(1) t2(2)-par2; t2(1)   t2(2)+par2 ];
    plot(t2p(:,1),t2p(:,2),'r')
    text( t2(1),t2(2)+par3,['t2: ', num2str(t2p(1))] )
    set(seti','String','Select T3')
    
    pause(0.1)
    
    t3 = ginput(1);
    t3p = [  t3 ; t3(1) t3(2)-par2; t3(1)   t3(2)+par2 ];
    plot(t3p(:,1),t3p(:,2),'r')
    text( t3(1),t3(2)+par3,['t3: ', num2str(t3p(1))] )
    delete(seti)
    
    pause(0.1)
    
    dispma()
    
end
