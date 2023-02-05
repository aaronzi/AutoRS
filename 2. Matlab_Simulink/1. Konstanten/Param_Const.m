% KONSTANTEN
function param_const = Param_Const()
    % SONSTIGE
    param_const.rho = 1.225;                                % Luftdichte [kg/m³]
    % param_const.D = 0.55;                                 % Dämpfung
    param_const.T_Aus = 15;                                 % Ausregelzeit [s]
    % param_const.omega_0 = 4.189;
    param_const.omega_r_Nenn = 12.1/60*2*pi;                % Nennwinkelgeschwindigkeit [rad/s]
    param_const.v_krit = 25;                                % kritische Windgeschwindigkeit [m/s]
    param_const.M_G_Nenn = 4.068060275635492e+04;           % Nenndrehmoment [Nm] für P = 5MW        
    
    % ANTRIEBSSTRANG
    param_const.n_g = 97.0;                       	        % Getriebeübersetzungsverhältnis
    param_const.J_r = 38759.227e3;                          % Rotor Trägheitsmoment [kg*m²]
    param_const.J_g = 534.1;                                % Generator Trägheitsmoment [kg*m²]
    param_const.k_s = 867637000/((97.0)^2);                 % Triebstrangsteifigkeit bezogen auf schnelle Welle [N/m]
    param_const.d_s = 6215000/((97.0)^2);                   % Dämpfungsfaktor Triebstrang bezogen auf schnelle Welle

    % TURM
    param_const.m_Nac = 240000;                             % Gondelmasse [kg]
    param_const.m_Rot = 110000;                             % Rotormasse [kg] (Blätter und Narbe)
    param_const.m_Tow = 347460;                             % Turmmasse [kg]
    param_const.m_T = 240000+110000+0.25*347460;            % Ersatzmasse der Windkraftanlage
    param_const.k_T = 1981900;                              % Ersatzsteifigkeit für Turm [N/m]
    param_const.d_T = 7e4;                                  % Dämpfungsfaktor für den Turm - Luftkraftdämpfung (konstant in erster Näherung)

    % ROTORBLATT
    param_const.R = 63.0;                                   % Blattradius [m]
    param_const.m_Bla = 17740;                              % Masse eines Rotorblattes [kg]
    param_const.r_B   = 21.975;                             % Effektive Blattlänge (Blattschwerpunkt) für Modell der Blattdynamik
    param_const.m_B   = 0.25*17740;                         % effektive schwingende Blattmasse [kg]
    param_const.k_B   = 40000;                              % Ersatzsteifigkeit für Blatt [N/m]
    param_const.d_B   = 2e4;                                % Dämpfungsfaktor für das Blatt - Luftkraftdämpfung (konstant in erster Näherung)

    % GESAMTMASSENTRÄGHEIT
    param_const.J = 38759.227e3 + 97.0^2*534.1;             % Gesamtmassenträgheit [kg*m^2]
end