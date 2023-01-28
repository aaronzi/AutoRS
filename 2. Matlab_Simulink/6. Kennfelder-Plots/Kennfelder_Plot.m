function Kennfelder_Plot(CQ_entries, CT_entries, beta_array, lambda_array)
%% KENNFELDER
    % MOMENTENBEIWERTE
    figure;
    surf(beta_array, lambda_array, CQ_entries);                     % Kennfeld der Momentenbeiwerte
    title('Kennfeld der Momentenbeiwerte');
    xlabel('Pitchwinkel $\theta$ [rad]', 'interpreter','latex');
    ylabel('Schnelllaufzahl $\lambda$', 'interpreter','latex');
    zlabel('Momentenbeiwert $c_{\mathrm{M}}$', 'interpreter','latex');
    view(120, 30);

    pos = get(gcf, 'Position');
    set(gcf, 'Position', pos+[0 -100 0 100])
    filename = fullfile('./6. Kennfelder-Plots/', 'Kennfeld_Momentenbeiwert.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')

    % LEISTUNGSBEIWERTE
    figure;
    surf(beta_array, lambda_array, CQ_entries .* lambda_array);     % Kennfeld der Leistungsbeiwerte
    title('Kennfeld der Leistungsbeiwerte');
    xlabel('Pitchwinkel $\theta$ [rad]', 'interpreter','latex');
    ylabel('Schnelllaufzahl $\lambda$', 'interpreter','latex');
    zlabel('Leistungsbeiwert $c_{\mathrm{P}}$', 'interpreter','latex');
    view(120, 30);

    pos = get(gcf, 'Position');
    set(gcf, 'Position', pos+[0 -100 0 100])
    filename = fullfile('./6. Kennfelder-Plots/', 'Kennfeld_Leistungsbeiwert.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')

    % SCHUBKRAFTBEIWERTE
    figure;
    surf(beta_array, lambda_array, CT_entries);                     % Kennfeld der Schubkraftbeiwerte
    title('Kennfeld der Schubkraftbeiwerte');
    xlabel('Pitchwinkel $\theta$ [rad]', 'interpreter','latex');
    ylabel('Schnelllaufzahl $\lambda$', 'interpreter','latex');
    zlabel('Schubkraftbeiwert $c_{\mathrm{T}}$', 'interpreter','latex');
    view(120, 30);

    pos = get(gcf, 'Position');
    set(gcf, 'Position', pos+[0 -100 0 100])
    filename = fullfile('./6. Kennfelder-Plots/', 'Kennfeld_Schubkraftbeiwert.pdf');
    exportgraphics(gcf,filename,'ContentType','vector')

end