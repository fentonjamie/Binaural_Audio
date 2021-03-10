[backgroundWalk] = audioread('Scripts and Audio/Walking Background.wav');

% place background walking at the start until the running has to begin


backgroundWalkFinal = [backgroundWalk(1 : 400000) backgroundWalk(1: 400000);...
    zeros((NSamples - 400000), 2)].*0.4; 
