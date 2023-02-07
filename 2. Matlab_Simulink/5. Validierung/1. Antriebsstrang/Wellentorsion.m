function Wellentorsion()
    warning('off','all')
    param_const = Param_Const();

    % Simulationskonstanten setzen
    M_g_final = (1/param_const.n_g) * 100;
    M_r_final = 100;

    % M_g und M_r als Eingänge der Simulation setzen
    assignin('base','M_g_final',M_g_final);
    assignin('base','M_r_final',M_r_final);

    % Aufruf der Simulation
    simOut = sim('AutoRS_Antriebsstrang_Simulink','StartTime','0','StopTime','30','FixedStep','1/1e4');

    % Abholen der Winkeldifferenz (Wellentorsion) aus der Simulation
    vec_wellentorsion = simOut.Wellentorsion(1,:).Data;
    t_vec = simOut.tout;

    % Plotten der Simulationsergebnisse
    figure
    plot(t_vec,vec_wellentorsion)
    xlabel('Zeit t [s]','interpreter','latex')
    ylabel('Winkeldifferenz $\Delta\varphi$ [$^{\circ}$]','interpreter','latex')
    legend('$\varphi_r - \varphi_g$','interpreter','latex')
    title('Wellentorsion des Antriebsstranges')
    grid on

    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[0 -100 0 100])
    filename = fullfile('./5. Validierung/1. Antriebsstrang/', 'Wellentorsion.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end