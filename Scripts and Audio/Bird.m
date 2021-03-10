
[x, Fs] = audioread('Scripts and Audio/Bird.wav');

% this is how many samples through the audio clip will start

position = 99999; 

%load in the HRIR used for vertical movement

load('IRC_1002_C_HRIR.mat')

% load in the row at intervals of 24 to get a vertical movement at 30 degrees
% as this is how the azimuth values are stored in the HRIR

vert_L = l_eq_hrir_S.content_m; 
vert_R = r_eq_hrir_S.content_m;

%Bring in the individual values that will proceed to move the audio from 0
%degrees vertically to 90 degrees vertically (probably a better way to do
%this than manually) 

vert_L_0 = [vert_L(1, :); vert_L(25, :); vert_L(50, :); vert_L(74, :);...
vert_L(99, :); vert_L(124, :); vert_L(148, :); vert_L(172, :); vert_L(182, :)];
vert_R_0 = [vert_R(1, :); vert_R(25, :); vert_R(50, :); vert_R(74, :);...
vert_R(99, :); vert_R(124, :); vert_R(148, :); vert_R(172, :); vert_R(182, :)];

frame_size = 65536; % The number of samples in a frame

x = (x(:, 1) + x(:,2))/2; % reduce a stereo input to mono
Ninput = length(x); % The number of samples in the input signal
[~,NIR] = size(vert_L_0); % The number of samples in the impulse response
y_length = Ninput + NIR -1; % The number of samples created by convolving x and IR

frame_conv_len = NIR + frame_size - 1; %  The number of samples created by convolving a frame of x and IR
step_size = frame_size/2; % Step size for 50% overlap-add
w = hann(frame_size, 'periodic');  % Generate the Hann function to window a frame
Nframes = floor((Ninput-frame_size) / step_size); % calculate the number of frames
FrameAngle = round(linspace(1,9,Nframes)); % we want to make the input slowly pan around starting at angle 1 and ending at angle 9

y = zeros(y_length,2); % Initialise the output vector y to zero

IRPad = zeros(frame_conv_len,2); % create empty vector for zero-padded IR
currentFrame = zeros(frame_conv_len,1); % create empty vector for zero padded current frame - we can do this here as we will only ever replace the first frame_size samples
for n = 1 : Nframes
    currentFrame(1:frame_size) = x(1+(n-1)*step_size:1+(n-1)*step_size+frame_size-1).*w; % window the current frame
    
    IRPad(1:NIR,1) = vert_L_0(FrameAngle(n),:); 
    IRPad(1:NIR,2) = vert_R_0(FrameAngle(n),:); 
    
    convResL = ifft(fft(currentFrame).*fft(IRPad(:,1)));     % Convolve the impulse response with this frame
    convResR = ifft(fft(currentFrame).*fft(IRPad(:,2)));     % Convolve the impulse response with this frame
    
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,1) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,1) + convResL;
    
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,2) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,2) + convResR;
end

%create an absaloute value 

birdMove = 0.99.*y./(max(max(abs(y)))); 

%zero pad before and after the audio in the placement it needs to be 
if position + length(birdMove) < NSamples

birdMovePlace = [zeros(position, 2); birdMove;...
    zeros(NSamples - length([zeros(position, 2); birdMove]), 2)];

else
    disp("error");
end

birdMoveFinal = birdMovePlace;

%sound(birdMove, Fs)


