function [windDataTimeseries] = Windgenerator(windTyp,v,v_mean,gust_nr,turb_nr)
    %% Laden der Winddaten
    cd '5. Validierung'/'3. Reglervalidierung'/Winde/
    
    gust_data = load('gust_data.mat').gust_data;
    % load gust_data_single_gusts.mat
    turb_data = load('turb_data.mat').turb_data;
    % load turb_data_200s.mat
    % load turb_data_highwind.mat
    % load TurbWind_12ms_grid25.mat
    % load turb_data_lowwind.mat
    
    cd ..
    cd ..
    cd ..
    
    %% Auswahl der Winddaten
    
    % Auswahl des Windtyps
    Param_Wind.Windtyp                      = windTyp;                  % 1: konstante Windgeschw., 2: IECwind  Windböe, 3: Turbulenter Wind, 4: Windgeschwindigkeitsstufen 
    
    Param_Wind.v                            = v; % 11.26; %18; %        % Konstante Windgeschw., wenn Windtyp = 1 ausgewählt wurde
    
    Param_Wind.v_mean                       = v_mean;                   % Durchschnittliche Windgeschwindigkeit als Eingang für den Störungsbeobachter
    
    % Auswahl der Anfangswindgeschw. für die IEC-Böe
    gust_nr_intern                          = gust_nr;                  %  1: 6 m/s, 2: 8 m/s, 3: 10 m/s, 4: 11 m/s, 5: 12 m/s, 6: 14 m/s, 7: 16 m/s, 8: 18 m/s
    gust_wind_data.time                     = gust_data(:,1);
    gust_wind_data.signals.values           = gust_data(:,gust_nr_intern+1);
    gust_wind_data.signals.dimensions       = 1;
    
    % Turbulenter Wind
    turb_nr_intern                          = turb_nr;                  % Auswahl der mittleren Windgeschw. für den turbulenten Wind
                                                                        % 1: 6, 2: 8, 3: 9, 4: 10, 5: 11, 6: 12, 7: 14, 8: 16, 9: 18, 10: 20, 11: 22, 12: 24                                                                   % 24
    turb_wind_data.time                     = turb_data(:,1);
    turb_wind_data.signals.values           = turb_data(:,turb_nr_intern+1);
    turb_wind_data.signals.dimensions       = 1;
    
    
    
    %% Erstellen des Wind-Datensatzes für die Simulation
    dT   = 0.01; % sample time
    Tmax = 100;  % total simulation time

    assignin('base','dT',dT);
    assignin('base','Tmax',Tmax);
    assignin('base','Param_Wind',Param_Wind);
    assignin('base','gust_wind_data',gust_wind_data);
    assignin('base','turb_wind_data',turb_wind_data);

    soptions = simset('Solver','ode4','FixedStep', dT);
    simOut = sim('Windgeschwindigkeitsgenerator', Tmax, soptions);
    windData = simOut.Winddaten.signals.values;
    time = simOut.Winddaten.time;
    windDataTimeseries(:,1) = time;
    windDataTimeseries(:,2) = windData;
end