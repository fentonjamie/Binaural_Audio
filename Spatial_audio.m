clc

clear

%load in background nature audio to run the whole way through

[background, Fs] = audioread('Scripts and Audio/Background audio.wav'); 

%create a variable for the total number of samples in the clip, this will
%be used to place each seperate audio compenent

NSamples = length(background);

%load in each of the seperate scripts
run('Scripts and Audio/Bomb');
run('Scripts and Audio/gunshot_2');
run('Scripts and Audio/Jeep');
run('Scripts and Audio/Bird');
run('Scripts and Audio/Church');
run('Scripts and Audio/Horse');
run('Scripts and Audio/Gunshot');
run('Scripts and Audio/Walk');
run('Scripts and Audio/Running');


%Add together all the final matrixes from the different audio script

all = background + birdMoveFinal + bellFinal + backgroundWalkFinal +...
    horseFinal + gunshotFinal + runFinal + jeepFinal + gun2Final +...
    bombFinal + bombFinal2;

%create the sound 

sound (all, Fs)

