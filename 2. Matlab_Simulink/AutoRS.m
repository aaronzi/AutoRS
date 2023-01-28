%% VOREINSTELLUNGEN
clear;
clc;

%% DATEIPFADE HINZUFÜGEN
addpath('./1. Konstanten/', './2. LookUp-Table/', './3. Simulationen/', './4. Reglerkoeffizienten/', './5. Validierung/');  % Hauptverzeichnisse
addpath('./6. Kennfelder-Plots/');                                                                                          % Hauptverzeichnisse
addpath('./5. Validierung/1. Antriebsstrang/', './5. Validierung/2. Turm und Blatt/');                                      % Validierungsverzeichnisse

%% KONSTANTEN BERECHNEN
global param_const;
param_const = Param_Const();

%% LOOKUP-TABLES DER KENNFELDER LADEN
load('CQ_CT_maps.mat');             % WEA Kennfelder (cM & cT)

%% BERECHNUNG LAMBDA_OPT UND CP_MAX
global param_opt;
param_opt = Param_Opt(CQ_entries, lambda_array);

%% KENNFELDER PLOTEN
% Kennfelder_Plot(CQ_entries, CT_entries, beta_array, lambda_array);

%% LINEARISIERUNGS- UND REGLERKOEFFIZIENTEN
% Reglerkoeffizienten(param_const);

%% GENERATORMOMENT BERECHNEN
%{
open('./3. Simulationen/Berechnung_Generatormoment.slx');
SimOut = sim('Berechnung_Generatormoment.slx');
M_G_array_II = SimOut.M_G.Data(1:3);
M_G_array_III = SimOut.M_G.Data(4:6);
save(fullfile('2. LookUp-Table/', 'M_G_array_II.mat'), 'M_G_array_II');
%}

%% RESTLICHE TABELLEN LADEN
load('k_omega_r_II.mat');           % k_omega_r_II_array
load('k_omega_r_III.mat');          % k_omega_r_III_array
load('k_theta_III.mat');            % k_theta_III_array
load('kpw_II_array.mat');           % kpw_II_array
load('kpw_III_array.mat');          % kpw_III_array
load('kiw_II_array.mat');           % kiw_II_array
load('kiw_III_array.mat');          % kiw_III_array
load('theta_array_III.mat');        % theta_array_III
load('M_G_array_II.mat');           % M_G_array_II 

%% SIMULATION ÖFFNEN UND STARTEN
mdlName = 'AutoRs_Simulation.slx';
open('./3. Simulationen/AutoRS_Simulation.slx');
sim(mdlName);
