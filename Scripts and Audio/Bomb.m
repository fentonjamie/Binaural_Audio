[bomb] = audioread('Scripts and Audio/explosion.wav');

% create placement values for both audio in sample number

position = 900000;
position2 = 700000;

%use the move function to spatially place the audio

bombMove = move(bomb, 23, 23, 1);

%zero pad before and after the audio to create the placement 

if position + length(bombMove) < NSamples

bombFinal = [zeros(position, 2); bombMove;...
  zeros(NSamples - length([zeros(position, 2); bombMove]), 2)]; 

else
    disp("error");
end

if position2 + length(bombMove) < NSamples

bombMove2 = move (bomb, 19, 17, 0.7);

bombFinal2 = [zeros(position2, 2); bombMove2;...
  zeros(NSamples - length([zeros(position2, 2); bombMove2]), 2)]; 

else
    disp("error")
end


