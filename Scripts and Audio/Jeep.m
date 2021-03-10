[jeep] = audioread('Scripts and Audio/Jeep.wav');

jeepStereo = [jeep(:, 1) jeep(:, 1)];

jeepMove = move(jeepStereo, 13, 7, 1); %use the move function to pan the jeep around 

rampJeep = [linspace(0,1, length(jeepMove)); linspace(0,1, length(jeepMove))]'; % use a ramp to multiply the jeep by an increasing amplutide and make it sound like its getting closer

jeepRamped = jeepMove.*rampJeep;

    
jeepFinal = [zeros((NSamples-length(jeepRamped)), 2); jeepRamped]; %use the place formulae to place it in the final audio
