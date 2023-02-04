function Reglerkoeffizienten(param_const, theta, v)
    % BENÖTIGTE KONSTANTEN
    c = [0.005, 1.53, 0.5, 0.18, 121, 27.9, 198, 2.36, 5.74, 11.35, 16.1, 201]; % siehe Skript 10 Seite 22
    
    % PITCHWINKEL [rad]
    theta_rad = deg2rad(theta);

    % ERGEBNISMATRIZEN
    % OTLB
    k_linear_OTLB = [];                     % alle Linearisierungskoeffizienten OTLB
    k_omega_r_II = [];                      
    kpw_II_array = [];                      % Führungsverhalten
    kiw_II_array = [];                      % Führungsverhalten
    % kpz_II_array = [];                    % Störverhalten
    % kiz_II_array = [];                    % Störverhalten    

    % VLB
    k_linear_VLB  = [];                     % alle Linearisierungskoeffizienten VLB
    k_omega_r_III = [];
    k_theta_III = [];
    kpw_III_array = [];                     % Führungsverhalten
    kiw_III_array = [];                     % Führungsverhalten
    % kpz_III_array = [];                   % Störverhalten    
    % kiz_III_array = [];                   % Störverhalten

    % SYMBOLISCHE FUNKTION UND ABLEITUNGEN FÜR MOMENTENBEIWERT
    syms lambda_sym theta_sym
    lambda_i = @(lambda_sym, theta_sym) (1/(lambda_sym+0.08*theta_sym)) - (0.035/(c(11)+c(12)*theta_sym^3)); % siehe Skript 10 Seite 22 (Anmerkung 1)
    cM_Gl = @(lambda_sym, theta_sym) c(1) * (1+c(2)*sqrt(theta_sym+c(3))) + (c(4)/lambda_sym)*(c(5)*lambda_i(lambda_sym, theta_sym)-c(6)*theta_sym-c(7)*theta_sym^(c(8))-c(9))*exp(-c(10)*lambda_i(lambda_sym, theta_sym)); % siehe Skript 10 Seite 22
    diff_cM_lambda_Gl = @(lambda_sym, theta_sym) diff(cM_Gl, lambda_sym);
    diff_cM_theta_Gl = @(lambda_sym, theta_sym) diff(cM_Gl, theta_sym);
    
    % LINEARISIERUNGSKOEFFIZIENTEN
    for i = 1:1:length(v)
        % SCHNELLLAUFZAHL BERECHNEN
        lambda = (param_const.omega_r_Nenn*param_const.R)/v(i);         % siehe Skript 10 Seite 20 (2.2.1)

        % EINSETZEN
        cM = double(subs(cM_Gl, {lambda_sym, theta_sym}, {lambda, theta_rad(i)}));
        diff_cM_lambda = double(subs(diff_cM_lambda_Gl, {lambda_sym, theta_sym}, {lambda, theta_rad(i)}));
        diff_cM_theta = double(subs(diff_cM_theta_Gl, {lambda_sym, theta_sym}, {lambda, theta_rad(i)}));

        % LINEARISIERUNGSKOEFFIZIENTEN (GLEICHUNGEN) siehe Skript 10 Seite 34
        k_v = 0.5*param_const.rho*pi*param_const.R^3*(2*v(i)*cM - param_const.omega_r_Nenn*param_const.R*diff_cM_lambda);
        k_omega_r = 0.5*param_const.rho*v(i)^2*pi*param_const.R^3*((param_const.R/v(i))*diff_cM_lambda);
        k_theta = 0.5*param_const.rho*v(i)^2*pi*param_const.R^3*diff_cM_theta;
       
        % ERGEBNISSE SPEICHERN
        erg = [k_v; k_omega_r; k_theta];

        if theta(i) == 0
            k_linear_OTLB = horzcat(k_linear_OTLB, erg);
        else
            k_linear_VLB = horzcat(k_linear_VLB, erg);
        end
        
        % Ergebnisse für k_v, k_omega_r und k_theta können verglichen werden mit Skript 10 Seite 76    
    end
    
    % LINEARISIERUNGSKOEFFIZIENTEN
    k_omega_r_II = k_linear_OTLB(2, :);
    k_omega_r_III = k_linear_VLB(2, :);
    k_theta_III = k_linear_VLB(3, :);

    % REGLERKOEFFIZIENTEN
    % oberere Teillastbereich
    for i = 1:1:size(k_linear_OTLB, 2)
        kpw_II_array = horzcat(kpw_II_array, (3*param_const.J)/(param_const.T_Aus*param_const.n_g));
        kiw_II_array = horzcat(kiw_II_array, -(3*k_omega_r_II(i))/(param_const.T_Aus*param_const.n_g));
        % kpz_II_array = horzcat(kpz_II_array, (param_const.J/param_const.n_g)*(2*param_const.D*param_const.omega_0+k_linear_OTLB(2, i)/param_const.J));
        % kiz_II_array = horzcat(kiz_II_array, (param_const.omega_0^2*param_const.J)/param_const.n_g);
    end

    % Vollastbereich
    for i = 1:1:size(k_linear_VLB, 2)
        kpw_III_array = horzcat(kpw_III_array, (3*param_const.J)/(param_const.T_Aus*k_theta_III(i)));
        kiw_III_array = horzcat(kiw_III_array, -(3*k_omega_r_III(i))/(param_const.T_Aus*k_theta_III(i)));
        % kpz_III_array = horzcat(kpz_III_array, (param_const.J/k_linear_VLB(3, i))*(2*param_const.D*param_const.omega_0+k_linear_VLB(2, i)/param_const.J));
        % kiz_III_array = horzcat(kiz_III_array, (param_const.omega_0^2*param_const.J)/k_linear_VLB(3, i));
    end

    % ERGEBNISSE SPEICHERN
    save(fullfile('2. LookUp-Table/', 'kpw_II_array.mat'), 'kpw_II_array');
    save(fullfile('2. LookUp-Table/', 'kpw_III_array.mat'), 'kpw_III_array');
    save(fullfile('2. LookUp-Table/', 'kiw_II_array.mat'), 'kiw_II_array');
    save(fullfile('2. LookUp-Table/', 'kiw_III_array.mat'), 'kiw_III_array');
    % save(fullfile('2. LookUp-Table/', 'kpz_II_array.mat'), 'kpz_II_array');
    % save(fullfile('2. LookUp-Table/', 'kpz_III_array.mat'), 'kpz_III_array');
    % save(fullfile('2. LookUp-Table/', 'kiz_II_array.mat'), 'kiz_II_array');
    % save(fullfile('2. LookUp-Table/', 'kiz_III_array.mat'), 'kiz_III_array');
    save(fullfile('2. LookUp-Table/', 'k_omega_r_II.mat'), 'k_omega_r_II');
    save(fullfile('2. LookUp-Table/', 'k_omega_r_III.mat'), 'k_omega_r_III');
    save(fullfile('2. LookUp-Table/', 'k_theta_III.mat'), 'k_theta_III');
end