% KONSTANTEN
function [param_opt] = Param_Opt(cM, lambda)
    % BERECHNUNG LEISTUNGSBEIWERT-WERTE (CP)
    cP = cM(:, 1) .* lambda;

    % MAXIMALEN WERT VON CP SUCHEN
    [param_opt.cP_max, i_max] = max(cP);

    % LAMBDA_OPT SUCHEN
    param_opt.lambda_opt = lambda(i_max);
end