% ====================================================================
% TRABAJO PRACTICO: CRISP-DM Y PROGRAMACION LOGICA
% Clasificacion de Potabilidad de Agua mediante Arbol de Decision
% ====================================================================

% Predicado principal: interfaz interactiva por consola
iniciar :-
    nl,
    write('SISTEMA DE CLASIFICACION DE POTABILIDAD DE AGUA '), nl, nl,
    write('IMPORTANTE: Ingrese cada numero seguido de un punto (.)'), nl, nl,

    write('1. Ingrese la Dureza del agua (Hardness en mg/L): '),
    read(Hardness),
    
    write('2. Ingrese Solidos disueltos totales (Solids en ppm): '),
    read(Solids),
    
    write('3. Ingrese nivel de Sulfatos (Sulfate en mg/L): '),
    read(Sulfate),
    
    write('4. Ingrese Carbono Organico (Organic_carbon en ppm): '),
    read(Organic_carbon),
    nl,
    evaluar(Hardness, Solids, Sulfate, Organic_carbon).
    
    % Logica de clasificacion y respuesta
    evaluar(H, S, Sulf, OC) :-
    es_potable(H, S, Sulf, OC),
    !,
    write('RESULTADO: El agua es POTABLE (Apta para consumo).'), nl, nl.
    
    evaluar(_, _, _, _) :-
    write('RESULTADO: El agua NO ES POTABLE (Riesgo sanitario).'), nl, nl.
    
    % ====================================================================
    % BASE DE CONOCIMIENTO (Reglas extraidas del Arbol de Decision)
    % ====================================================================
    
    % Regla 1: Dureza extrema (> 306.245)
    es_potable(H, _, _, _) :-
        H > 97.867,
        H > 306.245.
        
    % Regla 2: Dureza moderada y solidos muy bajos (<= 1952.435)
    es_potable(H, S, _, _) :-
        H > 97.867,
        H =< 306.245,
        S =< 1952.435.
        
    % Regla 3: Solidos altos pero sulfatos bajos (<= 196.553)
    es_potable(H, S, Sulf, _) :-
        H > 97.867,
        H =< 306.245,
        S > 1952.435,
        Sulf =< 196.553.
    
    % Regla 4: Rango bajo de carbono organico (5.189 < OC <= 5.339)
    es_potable(H, S, Sulf, OC) :-
        H > 97.867,
        H =< 306.245,
        S > 1952.435,
        Sulf > 196.553,
        OC > 5.189,
        OC =< 5.339.
        
    % Regla 5: Rango especifico alto de carbono organico (23.542 < OC <= 23.636)
    es_potable(H, S, Sulf, OC) :-
        H > 97.867,
        H =< 306.245,
        S > 1952.435,
        Sulf > 196.553,
        OC > 5.189,
        OC > 5.339,
        OC =< 23.636,
        OC > 23.542.
        
    % Regla 6: Dureza muy baja (<= 97.867)
    es_potable(H, _, _, _) :-
    H =< 97.867.