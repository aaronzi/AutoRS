function Auslenkungen()
    warning('off','all')
    param_const = Param_Const();

    % Simulationskonstanten setzen
    F_s_final = (1/2)*param_const.rho*param_const.R^2*pi*0.8*10^2;

    % F_s als Eingang der Simulation setzen
    assignin('base','F_s_final',F_s_final);

    % Aufruf der Simulation
    simOut = sim('AutoRS_Blatt_und_Turm','StartTime','0','StopTime','70','FixedStep','1/1e4');

    % Abholen der Winkeldifferenz (Wellentorsion) aus der Simulation
    vec_y_T = simOut.y_T(1,:).Data;
    vec_y_B = simOut.y_B(1,:).Data;
    t_vec = simOut.tout;

    % Plotten der Simulationsergebnisse
    plot(t_vec,vec_y_T,t_vec,vec_y_B)
    xlabel('Zeit t [s]','interpreter','latex')
    ylabel('Auslenkung $y$ [$m$]','interpreter','latex')
    legend('$y_T$','$y_B$','interpreter','latex')
    title('Auslenkung des Turmes und der Blätter')
    grid(gca,'minor')
    grid on
    % Ausgabe in PDF
    pos = get(gcf, 'Position');
    set(gcf, 'Position',pos+[0 -100 0 100])
    filename = fullfile('./5. Validierung/2. Turm und Blatt/', 'Auslenkungen.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')
    disp('Successfully created PDF')
end