function Regler_Validierung()
    %% Konstante Winde
    const_wind_low();
    const_wind_medium();
    const_wind_high();
    const_wind_vgl();
    
    %% Windböen
    gust_low();
    gust_high();

    %% Turbulente Winde
    turb_low();
    turb_medium();
    turb_high();

    %% Wind-Stufen
    step_medium();

    %% Validierung der Regelziele
    moment_drehzahl_kennfeld();
    valid_arbeitspunkte();

    %% Überprüfung der Constraints
    constraint_leistung();
    constraint_auslenkung();

end