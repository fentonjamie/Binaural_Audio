[gun2] = audioread('Scripts and Audio/Gun2.wav'); %load the audio

% place the gunshot by sample number it should join

position = 500000;

%use the move function to spaitally place the gun (it is stationary fixed spatial position)

gunMove2 = move(gun2, 3, 3, 0.8);

%place the audio by zero padding either side


if position + length(gunMove2) < NSamples

gun2Final = [zeros(position, 2); gunMove2;...
  zeros(NSamples - length([zeros(position, 2); gunMove2]), 2)]; 

else disp("error");
    
end
