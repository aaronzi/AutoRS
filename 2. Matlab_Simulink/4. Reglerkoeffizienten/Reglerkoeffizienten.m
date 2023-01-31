function Reglerkoeffizienten(param_const)
    % BENÖTIGTE KONSTANTEN
    c = [0.005, 1.53, 0.5, 0.18, 121, 27.9, 198, 2.36, 5.74, 11.35, 16.1, 201]; % siehe Skript 10 Seite 22
    v_II = 8:3/19:11;
    v_III = [11.3000,11.3222,11.3479,11.3771,11.4098,11.4459,11.4854,11.5283,11.5745,11.6239,11.6766,11.7326,11.7917,11.8539,11.9192,11.9876,12.0591,12.1335,12.2109,12.2912,12.3744,12.4605,12.5493,12.6410,12.7354,12.8325,12.9323,13.0347,13.1397,13.2472,13.3573,13.4699,13.5850,13.7024,13.8223,13.9445,14.0690,14.1957,14.3248,14.4560,14.5894,14.7249,14.8625,15.0022,15.1439,15.2876,15.4332,15.5808,15.7302,15.8815,16.0345,16.1894,16.3460,16.5043,16.6642,16.8258,16.9890,17.1537,17.3200,17.4877,17.6569,17.8275,17.9994,18.1727,18.3473,18.5232,18.7003,18.8786,19.0581,19.2387,19.4203,19.6030,19.7868,19.9715,20.1572,20.3437,20.5312,20.7194,20.9085,21.0984,21.2889,21.4802,21.6721,21.8646,22.0577,22.2514,22.4456,22.6402,22.8353,23.0308,23.2267,23.4229,23.6193,23.8161,24.0131,24.2102,24.4075,24.6049,24.8025,25.0000];
    v = horzcat(v_II,v_III);
    theta_array_II = zeros(1,20);
    theta_array_III = [0.0000,0.2694,0.5380,0.8058,1.0728,1.3390,1.6043,1.8688,2.1325,2.3954,2.6574,2.9186,3.1789,3.4384,3.6970,3.9547,4.2116,4.4676,4.7227,4.9769,5.2302,5.4827,5.7342,5.9848,6.2346,6.4834,6.7313,6.9782,7.2242,7.4693,7.7135,7.9567,8.1989,8.4402,8.6806,8.9199,9.1583,9.3957,9.6322,9.8676,10.1021,10.3356,10.5680,10.7995,11.0299,11.2594,11.4878,11.7152,11.9415,12.1668,12.3911,12.6143,12.8365,13.0576,13.2777,13.4967,13.7146,13.9314,14.1472,14.3618,14.5754,14.7879,14.9993,15.2096,15.4187,15.6268,15.8337,16.0395,16.2442,16.4477,16.6501,16.8513,17.0514,17.2503,17.4481,17.6447,17.8401,18.0344,18.2275,18.4194,18.6100,18.7995,18.9878,19.1749,19.3608,19.5454,19.7289,19.9111,20.0921,20.2718,20.4503,20.6275,20.8035,20.9783,21.1517,21.3239,21.4949,21.6645,21.8329,22.0000];
    theta_array = deg2rad(horzcat(theta_array_II,theta_array_III));

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
        cM = double(subs(cM_Gl, {lambda_sym, theta_sym}, {lambda, theta_array(i)}));
        diff_cM_lambda = double(subs(diff_cM_lambda_Gl, {lambda_sym, theta_sym}, {lambda, theta_array(i)}));
        diff_cM_theta = double(subs(diff_cM_theta_Gl, {lambda_sym, theta_sym}, {lambda, theta_array(i)}));

        % LINEARISIERUNGSKOEFFIZIENTEN (GLEICHUNGEN) siehe Skript 10 Seite 34
        k_v = 0.5*param_const.rho*pi*param_const.R^3*(2*v(i)*cM - param_const.omega_r_Nenn*param_const.R*diff_cM_lambda);
        k_omega_r = 0.5*param_const.rho*v(i)^2*pi*param_const.R^3*((param_const.R/v(i))*diff_cM_lambda);
        k_theta = 0.5*param_const.rho*v(i)^2*pi*param_const.R^3*diff_cM_theta;
       
        % ERGEBNISSE SPEICHERN
        erg = [k_v; k_omega_r; k_theta];

        if theta_array(i) == 0
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
        kiw_II_array = horzcat(kiw_II_array, -(3*k_linear_OTLB(2, i))/(param_const.T_Aus*param_const.n_g));
        % kpz_II_array = horzcat(kpz_II_array, (param_const.J/param_const.n_g)*(2*param_const.D*param_const.omega_0+k_linear_OTLB(2, i)/param_const.J));
        % kiz_II_array = horzcat(kiz_II_array, (param_const.omega_0^2*param_const.J)/param_const.n_g);
    end

    % Vollastbereich
    for i = 1:1:size(k_linear_VLB, 2)
        kpw_III_array = horzcat(kpw_III_array, (3*param_const.J)/(param_const.T_Aus*k_linear_VLB(3, i)));
        kiw_III_array = horzcat(kiw_III_array, -(3*k_linear_VLB(2, i))/(param_const.T_Aus*k_linear_VLB(3, i)));
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
    save(fullfile('2. LookUp-Table/', 'theta_array_II.mat'), 'theta_array_II');
    save(fullfile('2. LookUp-Table/', 'theta_array_III.mat'), 'theta_array_III');
    save(fullfile('2. LookUp-Table/', 'k_omega_r_II.mat'), 'k_omega_r_II');
    save(fullfile('2. LookUp-Table/', 'k_omega_r_III.mat'), 'k_omega_r_III');
    save(fullfile('2. LookUp-Table/', 'k_theta_III.mat'), 'k_theta_III');
end