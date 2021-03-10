
function [outputArg1] = move(x, startFrame, finishFrame, A)

load('HRIRs_0el_IRC_subject59.mat')
frame_size = 65536; % The number of samples in a frame use a large number so it doesnt 
%sound like it is moving frame by frame for the longer audio clips

x = (x(:, 1) + x(:,2))/2; % reduce a stereo input to mono
Ninput = length(x); % The number of samples in the input signal
[~,NIR] = size(HRIR_set_L); % The number of samples in the impulse response
y_length = Ninput + NIR -1; % The number of samples created by convolving x and IR

frame_conv_len = NIR + frame_size - 1; %  The number of samples created by convolving a frame of x and IR
step_size = frame_size/2; % Step size for 50% overlap-add
w = hann(frame_size, 'periodic');  % Generate the Hann function to window a frame
Nframes = floor((Ninput-frame_size) / step_size); % calculate the number of frames
FrameAngle = round(linspace(startFrame,finishFrame,Nframes)); % we want to make the input slowly pan around starting and ending at the angles
%stated in the function at the beginning

y = zeros(y_length,2); % Initialise the output vector y to zero

IRPad = zeros(frame_conv_len,2); % create empty vector for zero-padded IR

currentFrame = zeros(frame_conv_len,1); % create empty vector for zero padded current frame - we can do this here as we will only ever replace the first frame_size samples

for n = 1 : Nframes
    currentFrame(1:frame_size) = x(1+(n-1)*step_size:1+(n-1)*step_size+frame_size-1).*w; % window the current frame
    
    IRPad(1:NIR,1) = HRIR_set_L(FrameAngle(n),:); 
    IRPad(1:NIR,2) = HRIR_set_R(FrameAngle(n),:); 
    
    convResL = ifft(fft(currentFrame).*fft(IRPad(:,1)));     % Convolve the impulse response with this frame by converting to frequency domain and multiplying, then convert back to time domain using ifft
    convResR = ifft(fft(currentFrame).*fft(IRPad(:,2)));     % Convolve the impulse response with this frame
    
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,1) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,1) + convResL;
    
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,2) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,2) + convResR;
end
 
y = 0.99.*y./(max(max(abs(y)))).*A; %normalise the result and multiply by amplitude 

outputArg1 = y;
