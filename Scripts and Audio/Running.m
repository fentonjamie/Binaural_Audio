[run] = audioread('Scripts and Audio/run.wav');

x = NSamples - 400000;

runAmount = [run(1: x); run(1: x)]';

runFinal = [zeros(400000, 2); runAmount].*1.5; 

%Place the running audio from when the walking stops to the end of the
%audio demonstration