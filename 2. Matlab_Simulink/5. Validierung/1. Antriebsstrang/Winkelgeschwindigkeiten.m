function Winkelgeschwindigkeiten()
    warning('off','all')
    param_const = Param_Const();

    % Simulationskonstanten setzen
    M_g_final = (1/param_const.n_g) * 100;
    M_r_final = 100;

    % M_g und M_r als Eingänge der Simulation setzen
    assignin('base','M_g_final',M_g_final);
    assignin('base','M_r_final',M_r_final);

    % Aufruf der Simulation
    simOut = sim('AutoRS_Antriebsstrang_Simulink','StartTime','0','StopTime','25','FixedStep','1/1e4');

    % Abholen der Winkelgeschwindigkeiten aus der Simulation
    vec_Phi_g_Punkt = simOut.Phi_g_Punkt(1,:).Data;
    vec_Phi_r_Punkt = simOut.Phi_r_Punkt(1,:).Data;
    t_vec = simOut.tout;

    % Plotten der Simulationsergebnisse
    subplot(2,1,1)
    plot(t_vec,vec_Phi_g_Punkt)
    xlabel('Zeit t [s]','interpreter','latex')
    ylabel('Winkelgeschwindigkeit $\dot\varphi$ [$\frac{m}{s}$]','interpreter','latex')
    legend('$\dot\varphi_g$','interpreter','latex')
    title('Winkelgeschwindigkeit des Generators')
    grid on
    subplot(2,1,2)
    plot(t_vec,vec_Phi_r_Punkt,'Color','red')
    xlabel('Zeit t [s]','interpreter','latex')
    ylabel('Winkelgeschwindigkeit $\dot\varphi$ [$\frac{m}{s}$]','interpreter','latex')
    legend('$\dot\varphi_r$','interpreter','latex')
    title('Winkelgeschwindigkeit des Rotors')
    grid on

    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[0 -400 0 400])
    filename = fullfile('./5. Validierung/1. Antriebsstrang/', 'Winkelgeschwindigkeiten.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end