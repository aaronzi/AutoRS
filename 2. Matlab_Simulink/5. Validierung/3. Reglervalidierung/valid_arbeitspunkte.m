function valid_arbeitspunkte()
    anz_loops    = 6;
    winde        = [9 10 11 12 14 18];
    legendString = strings(1,anz_loops);
    t_vec        = zeros(60001,1);
    vec_n_r      = zeros(60001,anz_loops);
    vec_P_G      = zeros(60001,anz_loops);
    vec_P_R      = zeros(60001,anz_loops);
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
        t_vec(:,1)      = wea_simout.tout;
        vec_P_G(:,i)    = wea_simout.P_G(1,:).Data*10e-3;
        vec_P_R(:,i)    = wea_simout.P_R(1,:).Data*10e-3;
        vec_n_r(:,i)    = (wea_simout.omega_r(1,:).Data/(2*pi))*60;
        vec_theta(:,i)  = rad2deg(wea_simout.theta(1,:).Data);
        
        legendString(i) = sprintf('$\\theta _%.f  = %2.0f^\\circ \\quad ( %.0f \\frac{m}{s} )$',i,vec_theta(end,i),winde(i));
    end
    legendString(1,7) = 'Generatorleistung $P_{\mathrm{G}}$ [$kW$]';
        
    % Plotten der Simulationsergebnisse
    figure
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    linestyles = {'-', '-', '-', '--', ':', '-.'};
    for j=1:anz_loops
        % P_R; P_G; n_R
        plot(vec_n_r(:,j),vec_P_R(:,j),linestyles{j},'Color','green')
        hold on
    end
    plot(vec_n_r(:,3),vec_P_G(:,3),'LineWidth',2,'Color','red')
    hold off
    ylabel('Rotorleistung $P_{\mathrm{R}}$ [$kW$]','interpreter','latex')
    xlabel('Rotordrehzahl $n_\mathrm{R}$ [$\frac{1}{min}$]','interpreter','latex')
    title('Arbeitspunkte der Leistungsoptimierung')
    legend(legendString,'Location','northwest','interpreter','latex')
    grid on
    grid minor
    set(gca,'XMinorTick','on','YMinorTick','on')

    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[-100 -100 100 100])
    filename = fullfile('./5. Validierung/3. Reglervalidierung/valid_arbeitspunkte.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end