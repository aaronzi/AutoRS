%% VOREINSTELLUNGEN
clear;
clc;

%% DATEIPFADE HINZUFÜGEN
addpath('./1. Konstanten/', './2. LookUp-Table/', './3. Simulationen/', './4. Reglerkoeffizienten/', './5. Validierung/');  % Hauptverzeichnisse
addpath('./5. Validierung/1. Antriebsstrang/', './5. Validierung/2. Turm und Blatt/');                                      % Validierungsverzeichnisse

%% KONSTANTEN BERECHNEN
global param_const;
param_const = Param_Const();

%% LOOK-UP-TABLES LADEN
load('CQ_CT_maps.mat');             % WEA Kennfelder (cM & cT)
load('kpw_II_array.mat');           % kpw_II_array
load('kpw_III_array.mat');          % kpw_III_array
load('kiw_II_array.mat');           % kiw_II_array
load('kiw_III_array.mat');          % kiw_III_array
load('kpz_II_array.mat');           % kpz_II_array
load('kpz_III_array.mat');          % kpz_III_array
load('kiz_II_array.mat');           % kiz_II_array
load('kiz_III_array.mat');          % kiz_III_array
load('theta_array.mat');            % theta_array
load('M_G_array.mat');              % M_G_array
 
%% BERECHNUNG LAMBDA_OPT UND CP_MAX
global param_opt;
param_opt = Param_Opt(CQ_entries, lambda_array);

%% LINEARISIERUNGS- UND REGLERKOEFFIZIENTEN
% Reglerkoeffizienten(param_const);

%% GENERATORMOMENT BERECHNEN
%{
open('./3. Simulationen/Berechnung_Generatormoment.slx');
SimOut = sim('Berechnung_Generatormoment.slx');
M_G_array = SimOut.M_G.Data;
save(fullfile('2. LookUp-Table/', 'M_G_array.mat'), 'M_G_array');
%}

%% SIMULATION ÖFFNEN UND STARTEN
% mdlName = 'AutoRs_Simulation.slx';
% open('./3. Simulationen/AutoRS_Simulation.slx');
% sim(mdlName);
