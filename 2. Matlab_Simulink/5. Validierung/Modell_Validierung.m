function Modell_Validierung()
    %% Antriebsstrang-Modell
    
    % Winkelgeschwindigkeiten Phi_g_Punkt und Phi_r_Punkt
    Winkelgeschwindigkeiten();
    
    % Wellentorsion
    Wellentorsion();
    
    %% Turm- und Blattmodell
    
    % Auslenkungen
    Auslenkungen();
end