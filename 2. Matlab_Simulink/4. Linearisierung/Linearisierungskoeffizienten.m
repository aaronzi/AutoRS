function [k_v, k_omega_r, k_theta] = Linearisierungskoeffizienten(v, omega_r, theta, param_const)
    % BENÖTIGTE KONSTANTEN
    c = [0.005, 1.53, 0.5, 0.18, 121, 27.9, 198, 2.36, 5.74, 11.35, 16.1, 201];   

    % SCHNELLLAUFZAHL BERECHNEN
    lambda = (omega_r*param_const.R)/v;

    % SYMBOLISCHE FUNKTION UND ABLEITUNGEN FÜR MOMENTENBEIWERT
    syms lambda_sym theta_sym
    lambda_i = @(lambda_sym, theta_sym) (1/(lambda_sym+0.08*theta_sym)) - (0.035/(c(11)+c(12)*theta_sym^3));
    cM_Gl = @(lambda_sym, theta_sym) c(1) * (1+c(2)*sqrt(theta_sym+c(3))) + (c(4)/lambda_sym)*(c(5)*lambda_i(lambda_sym, theta_sym)-c(6)*theta_sym-c(7)*theta_sym^(c(8))-c(9))*exp(-c(10)*lambda_i(lambda_sym, theta_sym));
    diff_cM_lambda_Gl = @(lambda_sym, theta_sym) diff(cM_Gl, lambda_sym);
    diff_cM_theta_Gl = @(lambda_sym, theta_sym) diff(cM_Gl, theta_sym);
    
    % EINSETZEN
    cM = double(subs(cM_Gl, {lambda_sym, theta_sym}, {lambda, theta}));
    diff_cM_lambda = double(subs(diff_cM_lambda_Gl, {lambda_sym, theta_sym}, {lambda, theta}));
    diff_cM_theta = double(subs(diff_cM_theta_Gl, {lambda_sym, theta_sym}, {lambda, theta}));

    % LINEARISIERUNGSKOEFFIZIENTEN (GLEICHUNGEN)
    k_v = 0.5*param_const.rho*pi*param_const.R^3*(2*v*cM - omega_r*param_const.R*diff_cM_lambda);
    k_omega_r = 0.5*param_const.rho*v^2*pi*param_const.R^3*((param_const.R/v)*diff_cM_lambda);
    k_theta = 0.5*param_const.rho*v^2*pi*param_const.R^3*diff_cM_theta;
end