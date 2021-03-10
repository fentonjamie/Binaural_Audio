frame_size = 1024;

position = 299990;

%add a reverb effect to make the gunshot sound more confusing and unnerving
%load in a given impulse response with lots of reverb 

[IR, Fs] = audioread('Scripts and Audio/koli_summer_site1_1way_mono_44k.wav'); 
[x, wav_Fs] = audioread('Scripts and Audio/Gunshot.wav'); % Load the sound source
if wav_Fs ~= Fs %make sure sampling frequencies are the same
    error('Sampling frequencies must be the same'); 
end

x = x(:, 1); % (If necessary) this reduces a stereo input to mono
Ninput = length(x); % The number of samples in the input signal
NIR = length(IR); % The number of samples in the impulse response
y_length = Ninput + NIR -1; % The number of samples created by convolving x and IR

frame_conv_len = NIR + frame_size - 1; %  The number of samples created by convolving a frame of x and IR
IRPad = zeros(frame_conv_len,1); % create empty vector for zero-padded IR
IRPad(1:NIR) = IR; % zero pad the IR
step_size = frame_size/2; % Step size for 50% overlap-add
w = hann(frame_size, 'periodic');  % Generate the Hann function to window a frame
Nframes = floor((Ninput-frame_size) / step_size); % calculate the number of frames
y = zeros(y_length,1); % Initialise the output vector y to zero
% create empty vector for zero padded current frame - we can do this here 
%as we will only ever replace the first frame_size samples
currentFrame = zeros(frame_conv_len,1); 

for n = 1 : Nframes
    currentFrame(1:frame_size) = x(1+(n-1)*step_size:1+(n-1)*step_size+frame_size-1).*w; % window the current frame
    convRes = ifft(fft(currentFrame).*fft(IRPad));     % Convolve the impulse response with this frame
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1) + convRes;
end

% create an absaloute value from the convolved value

gunshot =0.99.* [y/max(abs(y)) y/max(abs(y))];

gunshotMove = move(gunshot, 7, 7, 0.8); %add this to movement function

%place this by zero padding before and after the audio

if position + length(gunshotMove) < NSamples

gunshotFinal = [zeros(position, 2); gunshotMove;...
  zeros(NSamples - length([zeros(position, 2); gunshotMove]), 2)]; 

else disp("error");
    
end


