% VOREINSTELLUNGEN
clear;
clc;

% DATEIPFADE HINZUFÜGEN
addpath('./1. Konstanten/', './2. LookUp-Table/', './3. Simulationen/', './4. Linearisierung/');

% KONSTANTEN BERECHNEN
global param_const;
param_const = Param_Const();

% LOOK-UP-TABLES LADEN
load('CQ_CT_maps.mat');

% BERECHNUNG LAMBDA_OPT UND CP_MAX
global param_opt;
param_opt = Param_Opt(CQ_entries, lambda_array);

% LINEARISIERUNGSKOEFFIZIENTEN
v_Test = 12;
omega_r_Test = 12.1;
theta_Test = 4;
[k_v, k_omega_r, k_theta] = Linearisierungskoeffizienten(v_Test, omega_r_Test, theta_Test, param_const);


% SIMULATION ÖFFNEN UND STARTEN
% mdlName = 'AutoRs_Simulation.slx';
% open('./3. Simulationen/AutoRS_Simulation.slx');
% sim(mdlName);