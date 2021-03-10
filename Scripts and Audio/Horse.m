[horse, Fs] = audioread('Scripts and Audio/Horse Trotting.wav');

NSamples = length(background);

horseMove = move(horse, 4, 19, 1);

position = 330000;

% set a ramp value so it seems the audio starts falling behind as you
% walk past. The ramp needs to be the same length and have 2 collums to
% multiply by the audio

horseRamp = [linspace(0.5,0,length(horseMove)); linspace(0.5,0,length(horseMove))]';

horseRamped = horseMove.*horseRamp;

%if function makes sure the samples wont run over the length of the audio
%throwing an error
if position + length(horseRamped) < NSamples

horseFinal = [zeros(position, 2); horseRamped;...
    zeros(NSamples - length([zeros(position, 2); horseRamped]), 2)];

else 
    disp ("error")
end