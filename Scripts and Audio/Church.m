%create a low pass filter for the chursch to make it sound further away.
%First create an impulse response by zero padding
y = zeros(1024, 1);  

% than creating a set of ones which mirror each other around the midpoint
% the greater number of ones the greater amount of high frequencies will be
% allowed into the audio, must mirror to create only real values after
% transform

y(2:12) = 1;
y(1014:1024) = 1; 

% create impulse response in time domain by using inverse fast fourier
% transform and circshift 

h = ifft(y); 
h = circshift(h,length(y)/2);


[church]= audioread('Scripts and Audio/church bell.wav') ;

%reduce the church to stereo 

church = church(:,1);

%convolve the impulse response with the audio to apply the low pass impulse
%response created to the audio loaded in

churchConv = conv(church,h); 

% now place into stereo to work with the move function

churchConvStereo = [churchConv churchConv]; 

audiowrite ("Church filtered.wav", churchConvStereo, Fs)

% place the audio spatially using the move function 

bellMove = move(churchConvStereo, 18, 18, 0.1);

%place the bell at the beggining of the audio

bellFinal = [bellMove' zeros(2, (NSamples - length(bellMove)))]';