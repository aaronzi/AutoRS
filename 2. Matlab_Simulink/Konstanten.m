% KONSTANTEN
function c = Konstanten()
    c.n_g = 97.0;                       	    % Getriebeübersetzungsverhältnis - wird hier zunächst nicht benötigt
    c.J_r = 38759.227e3;                      % Rotor Trägheitsmoment [kg m^2]
    c.J_g = 534.1;                              % Generator Trägheitsmoment [kg m^2]
    c.k_s = 867637000/((97.0)^2);              % Triebstrangsteifigkeit bezogen auf schnelle Welle 
    c.d_s = 6215000/((97.0)^2);                % Dämpfungsfaktor Triebstrang bezogen auf schnelle Welle
end