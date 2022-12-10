% VOREINSTELLUNGEN
clear;
clc;

% DATEIPFADE HINZUFÜGEN
addpath('./1. Konstanten/', '2. LookUp-Table\', '3. Simulationen\');

% KONSTANTEN BERECHNEN
param_const = Param_Const();

% LOOK-UP-TABLES LADEN
load('CQ_CT_maps.mat');

% BERECHNUNG LAMBDA_OPT UND CP_MAX
param_opt = Param_Opt(CQ_entries, lambda_array);

% SIMULATION ÖFFNEN UND STARTEN
mdlName = 'AutoRs_Simulation.slx';
open('./3. Simulationen/AutoRS_Simulation.slx');
sim(mdlName);