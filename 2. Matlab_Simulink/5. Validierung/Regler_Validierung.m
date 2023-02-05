%% Aufrufen der Simulationsstruktur für die Generierung von Winddaten
Windtyp                         = 3;  % 1: konstante Windgeschw., 2: IECwind  Windböe, 3: Turbulenter Wind, 4: Windgeschwindigkeitsstufen 
Windgeschwindigkeit             = 15; % Konstante Windgeschw., wenn Windtyp = 1 ausgewählt wurde
Durch_Windgeschwindigkeit       = 18; % Durchschnittliche Windgeschwindigkeit als Eingang für den Störungsbeobachter
Boentyp                         = 8;  % 1: 6 m/s, 2: 8 m/s, 3: 10 m/s, 4: 11 m/s, 5: 12 m/s, 6: 14 m/s, 7: 16 m/s, 8: 18 m/s
Turbolenter_Windtyp             = 8;  % Auswahl der mittleren Windgeschw. für den turbulenten Wind
                                      % 1: 6 m/s, 2: 8 m/s, 3: 9 m/s, 4: 10 m/s, 5: 11 m/s, 6: 12 m/s, 7: 14 m/s, 8: 16 m/s, 9: 18 m/s, 10: 20 m/s, 11: 22 m/s, 12: 24 m/s
Winddaten = Windgenerator(Windtyp,Windgeschwindigkeit,Durch_Windgeschwindigkeit,Boentyp,Turbolenter_Windtyp);

%% Setzen der Parameter für die Simulation der WEA
dT   = 0.01; % sample time
Tmax = 100;  % total simulation time
assignin('base','dT',dT);
assignin('base','Tmax',Tmax);
soptions = simset('Solver','ode4','FixedStep', dT);

%% Simulation der WEA
wea_simout = sim('AutoRS_Simulation', Tmax, soptions);

%% Anzeige der Simulationsergebnisse
vec_State           = wea_simout.State(1,:).Data;
vec_M_G             = wea_simout.M_G(1,:).Data;
vec_P_G             = wea_simout.P_G(1,:).Data;
vec_Torsionswinkel  = wea_simout.Torsionswinkel(1,:).Data;
vec_omega_r         = wea_simout.omega_r(1,:).Data;
vec_theta           = rad2deg(wea_simout.theta(1,:).Data);
vec_y_B             = wea_simout.y_B(1,:).Data;
vec_y_T             = wea_simout.y_T(1,:).Data;
vec_v_1             = wea_simout.v_1(1,:).Data;
t_vec               = wea_simout.tout;

% Plotten der Simulationsergebnisse
subplot(3,1,1)
yyaxis left
plot(t_vec,vec_M_G,'LineWidth',2)
ylabel('Generatormoment $M_{\mathrm{G}}$ [$Nm$]','interpreter','latex')
yyaxis right
plot(t_vec,vec_omega_r)
ylabel('Rotordrehzahl $\omega_{\mathrm{r,ist}}$ [$\frac{rad}{s}$]','interpreter','latex')
xlabel('Zeit t [s]','interpreter','latex')
title('Generatormoment und Rotordrehzahl der WEA')
grid on

subplot(3,1,2)
yyaxis left
area(t_vec,vec_State)
ylabel('Zustand der WEA','interpreter','latex')
yyaxis right
plot(t_vec,vec_theta,'LineWidth',2)
ylabel('Pitchwinkel $\theta$ [$^{\circ}$]','interpreter','latex')
xlabel('Zeit t [s]','interpreter','latex')
title('Pitchwinkel und Zustand der WEA')
grid on

subplot(3,1,3)
yyaxis left
plot(t_vec,vec_y_T,t_vec,vec_y_B,'LineWidth',2)
ylabel('Auslenkung $y$ [$m$]','interpreter','latex')
yyaxis right
plot(t_vec,vec_v_1)
ylabel('Windgeschwindigkeit $v_1$ [$\frac{m}{s}$]','interpreter','latex')
xlabel('Zeit t [s]','interpreter','latex')
title('Blatt- und Turmauslenkung der WEA')
legend('Turmauslenkung $y_{\mathrm{T}}$','Blattauslenkung $y_{\mathrm{B}}$','Windgeschwindigkeit $v_1$','interpreter','latex')
grid on