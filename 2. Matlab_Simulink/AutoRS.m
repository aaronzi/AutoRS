% VOREINSTELLUNGEN
clear;
clc;

% KONSTANTEN AUFRUFEN
global c;
c = Konstanten();

% 1. Setzen der Windturbinen Parameter für den Workspace
load('CQ_CT_maps.mat')     % load aerodynamic maps CQ and CT (look up tables) of rotor blades
mdlName = 'AutoRS_Simulation.slx';
open(mdlName);
sim(mdlName)
