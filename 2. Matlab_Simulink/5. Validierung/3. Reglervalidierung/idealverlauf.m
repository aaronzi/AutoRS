function idealverlauf()
    %% Erstellen der Winddaten
    Winddaten = 11.4.* ones(20001,2);
    %% Ab 6689 * 0.01s muss der wind von 11.4m/s bis 25m/s bei 20001 * 0.01s steigen
    rampWind = 11.4:(25-11.4)/(20001-6688):25;
    Winddaten(6688:20001,2) = rampWind;
    % Winddaten(20002:end,2) = 25.* ones(10000,1);
    Winddaten(:,1) = 0:0.01:200;
    
    %% Setzen der Parameter für die Simulation der WEA
    dT   = 0.01; % sample time
    Tmax = 200;  % total simulation time
    assignin('base','dT',dT);
    assignin('base','Tmax',Tmax);
    assignin('base','Winddaten',Winddaten);
    soptions = simset('Solver','ode4','FixedStep', dT);
    
    %% Simulation der WEA
    wea_simout = sim('AutoRS_Simulation', Tmax, soptions);
    
    %% Anzeige der Simulationsergebnisse
    t_vec               = wea_simout.tout;
    vec_omega_g         = wea_simout.omega_g(1,:).Data;
    vec_P_G             = wea_simout.P_G(1,:).Data;
    vec_M_G             = wea_simout.M_G(1,:).Data;
    vec_theta           = rad2deg(wea_simout.theta(1,:).Data);
    vec_M_R             = wea_simout.M_R(1,:).Data;
    vec_omega_r         = wea_simout.omega_r(1,:).Data;
    vec_v_1             = wea_simout.v_1(1,:).Data;
    vec_F_s             = wea_simout.F_s(1,:).Data;
    vec_State           = wea_simout.State(1,:).Data;

    % valUTLB = vec_State;
    % valUTLB(valUTLB>=3)=1;
    % [~, locUTLB] = max(valUTLB);
    valOTLB = vec_State;
    valOTLB(valOTLB>=4)=1;
    [~, locOTLB] = max(valOTLB);
    valVLB = vec_State;
    [~, locVLB] = max(valVLB);
    
    % Plotten der Simulationsergebnisse
    figure
    set(groot,'defaultAxesTickLabelInterpreter','latex');

    subplot(2,2,1)
    yyaxis left
    plot(t_vec,vec_M_G,'LineWidth',2)
    ylabel('Generatordrehmoment $M_{\mathrm{G}}$ [$Nm$]','interpreter','latex')
    yyaxis right
    plot(t_vec,vec_M_R,'LineWidth',2)
    ylabel('Rotordrehmoment $M_{\mathrm{R}}$ [$Nm$]','interpreter','latex')
    xl1 = xline(locOTLB*0.01,'-.','unterer Teillastbereich');
    xl2 = xline(locVLB*0.01,'-.','Volllastbereich');
    xl1.LabelHorizontalAlignment = 'left';
    xl2.LabelHorizontalAlignment = 'right';
    xlabel('Zeit t [s]','interpreter','latex')
    title('Drehmomente des Antriebsstrangs')
    grid on

    subplot(2,2,2)
    yyaxis left
    plot(t_vec,vec_omega_g,'LineWidth',2)
    ylabel('Generatorwinkelgeschwindigkeit $\omega_{\mathrm{g}}$ [$\frac{rad}{s}$]','interpreter','latex')
    yyaxis right
    plot(t_vec,vec_omega_r,'LineWidth',2)
    ylabel('Rotorwinkelgeschwindigkeit $\omega_{\mathrm{r}}$ [$\frac{rad}{s}$]','interpreter','latex')
    xl1 = xline(locOTLB*0.01,'-.','unterer Teillastbereich');
    xl2 = xline(locVLB*0.01,'-.','Volllastbereich');
    xl1.LabelHorizontalAlignment = 'left';
    xl2.LabelHorizontalAlignment = 'right';
    xlabel('Zeit t [s]','interpreter','latex')
    title('Winkelgeschwindigkeiten des Antriebsstrangs')
    grid on

    subplot(2,2,3)
    yyaxis left
    plot(t_vec,vec_v_1,'LineWidth',2)
    ylabel('Windgeschwindigkeit $v_1$ [$\frac{m}{s}$]','interpreter','latex')
    yyaxis right
    plot(t_vec,vec_theta,'LineWidth',2)
    ylabel('Pitchwinkel $\theta$ [$^\circ$]','interpreter','latex')
    xl1 = xline(locOTLB*0.01,'-.','unterer Teillastbereich');
    xl2 = xline(locVLB*0.01,'-.','Volllastbereich');
    xl1.LabelHorizontalAlignment = 'left';
    xl2.LabelHorizontalAlignment = 'right';
    xlabel('Zeit t [s]','interpreter','latex')
    title('Windgeschwindigkeit und Pitchwinkel')
    grid on

    subplot(2,2,4)
    yyaxis left
    plot(t_vec,vec_P_G,'LineWidth',2)
    ylabel('Generatorleistung $P_{\mathrm{G}}$ [$W$]','interpreter','latex')
    yyaxis right
    plot(t_vec,vec_F_s,'LineWidth',2)
    ylabel('Schubkraft $F_{\mathrm{S}}$ [$N$]','interpreter','latex')
    xl1 = xline(locOTLB*0.01,'-.','unterer Teillastbereich');
    xl2 = xline(locVLB*0.01,'-.','Volllastbereich');
    xl1.LabelHorizontalAlignment = 'left';
    xl2.LabelHorizontalAlignment = 'right';
    xlabel('Zeit t [s]','interpreter','latex')
    title('Generatorleistung und Schubkraft')
    grid on

    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[-1800 -400 1800 400])
    filename = fullfile('./5. Validierung/3. Reglervalidierung/idealverlauf.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end