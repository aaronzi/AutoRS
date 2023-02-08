function constraint_leistung()
    %% Aufrufen der Simulationsstruktur für die Generierung von Winddaten
    Windtyp                         = 1;  % 1: konstante Windgeschw., 2: IECwind  Windböe, 3: Turbulenter Wind, 4: Windgeschwindigkeitsstufen 
    Windgeschwindigkeit             = 25; % Konstante Windgeschw., wenn Windtyp = 1 ausgewählt wurde
    Durch_Windgeschwindigkeit       = 16; % Durchschnittliche Windgeschwindigkeit als Eingang für den Störungsbeobachter
    Boentyp                         = 8;  % 1: 6 m/s, 2: 8 m/s, 3: 10 m/s, 4: 11 m/s, 5: 12 m/s, 6: 14 m/s, 7: 16 m/s, 8: 18 m/s
    Turbolenter_Windtyp             = 7;  % Auswahl der mittleren Windgeschw. für den turbulenten Wind
                                          % 1: 6 m/s, 2: 8 m/s, 3: 9 m/s, 4: 10 m/s, 5: 11 m/s, 6: 12 m/s, 7: 14 m/s, 8: 16 m/s, 9: 18 m/s, 10: 20 m/s, 11: 22 m/s, 12: 24 m/s
    Winddaten = Windgenerator(Windtyp,Windgeschwindigkeit,Durch_Windgeschwindigkeit,Boentyp,Turbolenter_Windtyp);
    
    %% Setzen der Parameter für die Simulation der WEA
    dT   = 0.01; % sample time
    Tmax = 100;  % total simulation time
    assignin('base','dT',dT);
    assignin('base','Tmax',Tmax);
    assignin('base','Winddaten',Winddaten);
    soptions = simset('Solver','ode4','FixedStep', dT);
    
    %% Simulation der WEA
    wea_simout = sim('AutoRS_Simulation', Tmax, soptions);
    
    %% Anzeige der Simulationsergebnisse
    t_vec               = wea_simout.tout;
    vec_P_G             = wea_simout.P_G(1,:).Data;
    vec_F_s             = wea_simout.F_s(1,:).Data;
    vec_theta           = rad2deg(wea_simout.theta(1,:).Data);

    %vec_omega_g         = wea_simout.omega_g(1,:).Data;
    %vec_State           = wea_simout.State(1,:).Data;
    %vec_M_G             = wea_simout.M_G(1,:).Data;
    %vec_M_R             = wea_simout.M_R(1,:).Data;
    %vec_Torsionswinkel  = wea_simout.Torsionswinkel(1,:).Data;
    %vec_omega_r         = wea_simout.omega_r(1,:).Data;
    %vec_y_B             = wea_simout.y_B(1,:).Data;
    %vec_y_T             = wea_simout.y_T(1,:).Data;
    %vec_v_1             = wea_simout.v_1(1,:).Data;

    Pmax =  6e6.* ones(10001,1);
    Pnenn = 5e6.* ones(10001,1);
    
    % Plotten der Simulationsergebnisse
    figure
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    
    subplot(2,1,1)
    plot(t_vec,vec_P_G,'LineWidth',2,'Color','black')
    ylabel('Generatorleistung $P_{\mathrm{G}}$ [$W$]','interpreter','latex')
    xlabel('Zeit t [s]','interpreter','latex')
    title('Generatorleistung der WEA')
    grid on
    hold on
    plot(t_vec,Pnenn,'-','Color','black')
    plot(t_vec,Pmax,'--','Color','black')
    legend('$P_{\mathrm{G}}$','$P_{\mathrm{G,nenn}}$','$P_{\mathrm{G,max}}$','Interpreter','latex','Location','southeast')
    hold off
    
    subplot(2,1,2)
    yyaxis left
    plot(t_vec,vec_F_s,'LineWidth',2)
    ylabel('Schubkraft $F_{\mathrm{s}}$ [$N$]','interpreter','latex')
    yyaxis right
    plot(t_vec,vec_theta,'LineWidth',2)
    ylabel('Pitchwinkel $\theta$ [$^\circ$]','interpreter','latex')
    xlabel('Zeit t [s]','interpreter','latex')
    title('Schubkraft und Pitchwinkel der Rotorblätter')
    grid on

    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[-300 -200 300 200])
    filename = fullfile('./5. Validierung/3. Reglervalidierung/constraint_leistung.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end