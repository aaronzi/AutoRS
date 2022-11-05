% KONSTANTEN
function c = Konstanten()
    % ANTRIEBSSTRANG
    c.n_g = 97.0;                       	    % Getriebeübersetzungsverhältnis
    c.J_r = 38759.227e3;                        % Rotor Trägheitsmoment [kg m^2]
    c.J_g = 534.1;                              % Generator Trägheitsmoment [kg m^2]
    c.k_s = 867637000/((97.0)^2);               % Triebstrangsteifigkeit bezogen auf schnelle Welle 
    c.d_s = 6215000/((97.0)^2);                 % Dämpfungsfaktor Triebstrang bezogen auf schnelle Welle

    % TURM
    c.m_Nac = 240000;                           % Gondelmasse [kg]
    c.m_Rot = 110000;                           % Rotormasse [kg] (Blätter und Narbe)
    c.m_Tow = 347460;                           % Turmmasse [kg]
    c.m_T = 240000+110000+0.25*347460;          % Ersatzmasse der Windkraftanlage
    c.k_T = 1981900;                            % Ersatzsteifigkeit für Turm [N/m]
    c.d_T = 7e4;                                % Dämpfungsfaktor für den Turm - Luftkraftdämpfung (konstant in erster Näherung)

    % ROTORBLATT
    c.m_Blade = 17740;                          % Masse eines Rotorblattes [kg]
    c.r_B   = 21.975;                           % Effektive Blattlänge (Blattschwerpunkt) für Modell der Blattdynamik
    c.m_B   = 0.25*m_Blade;                     % effektive schwingende Blattmasse [kg]
    c.k_B   = 40000;                            % Ersatzsteifigkeit für Blatt [N/m]
    c.d_B   = 2e+04;                            % Dämpfungsfaktor für das Blatt - Luftkraftdämpfung (konstant in erster Näherung)
end