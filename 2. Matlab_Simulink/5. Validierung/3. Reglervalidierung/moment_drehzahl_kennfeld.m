function moment_drehzahl_kennfeld()
    anz_loops           = 3;
    winde               = [9 10 11];
    legendString        = strings(1,anz_loops);
    t_vec               = zeros(60001,1);
    vec_n_r             = zeros(60001,anz_loops);
    vec_P_G             = zeros(60001,anz_loops);
    vec_M_R_M_G_nenn    = zeros(60001,anz_loops);
    for i=1:anz_loops
        Winddaten = winde(i).* ones(60001,2);
        Winddaten(:,1) = 0:0.01:600;
        
        %% Setzen der Parameter für die Simulation der WEA
        dT   = 0.01; % sample time
        Tmax = 600;  % total simulation time
        assignin('base','dT',dT);
        assignin('base','Tmax',Tmax);
        assignin('base','Winddaten',Winddaten);
        soptions = simset('Solver','ode4','FixedStep', dT);
        
        %% Simulation der WEA
        wea_simout = sim('AutoRS_Simulation', Tmax, soptions);
        
        %% Anzeige der Simulationsergebnisse
        P_G_nenn                = 5*10e5;
        M_G_nenn                = (41*10e3)*10;
        t_vec(:,1)              = wea_simout.tout;
        vec_P_G(:,i)            = wea_simout.P_G(1,:).Data/P_G_nenn;
        vec_M_R_M_G_nenn(:,i)   = wea_simout.M_R(1,:).Data/M_G_nenn;
        vec_n_r(:,i)            = (wea_simout.omega_r(1,:).Data/(2*pi))*60;

        legendString(i) = sprintf('$%.0f \\frac{m}{s}$',winde(i));
    end
    legendString(1,4) = 'Generatorleistung $P_{\mathrm{G}}$ [$kW$]';
        
    % Plotten der Simulationsergebnisse
    figure
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    linestyles = {'-', '-', '-', '--', ':', '-.'};
    for j=1:anz_loops
        % P_R; P_G; n_R
        plot(vec_n_r(:,j),vec_M_R_M_G_nenn(:,j),linestyles{j},'Color','green')
        hold on
    end
    plot(vec_n_r(:,3),vec_P_G(:,3),'LineWidth',2,'Color','red')
    hold off
    ylabel('$\frac{M_{\mathrm{R}}}{M_{\mathrm{G,nenn}}}$','interpreter','latex')
    xlabel('Drehzahl $n$ [$\frac{1}{min}$]','interpreter','latex')
    title('Moment-Drehzahl-Kennfeld')
    legend(legendString,'Location','northwest','interpreter','latex')
    grid on
    grid minor
    set(gca,'XMinorTick','on','YMinorTick','on')

    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[-100 -100 100 100])
    filename = fullfile('./5. Validierung/3. Reglervalidierung/moment_drehzahl_kennfeld.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end