function IA = WhiteBalance(I, Wts)
% Function to Change White Balance of an image
% Inputs:
% I: Image
% Wts: weights of red, green and blue channels (Wts should sum upto 1 or
% else they'll be normalized)
% Output:
% IA: White Balance changed image
% Sample Usage:
% I = imread('ferrari.jpg');
% Wts = [0.7, 0.2, 0.1];
% IA = WhiteBalance(I, Wts);
% IA = WhiteBalance(I); returns a neural white balance image
% Code modified by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD Student in Computer Science at University of Maryland, College Park
% Dec 2016
% Part of the code taken from: 
% https://www.mathworks.com/matlabcentral/answers/247379-how-to-white-balance-the-each-rgb-components-of-an-image

if(size(I,3)~=3)
    error('Number of channels in the image are not 3');
end

if(nargin<2)
   Wts = [1/3, 1/3, 1/3]; 
end

if(sum(Wts)~=1)
   Wts = Wts./sum(Wts);
   warning(['Weights did not sum to 1, hence they have been normalized and the new weights are: ',num2str(Wts)]);
end

I = im2double(I);
grayImage = rgb2gray(I); % Convert to gray so we can get the mean luminance.
% Extract the individual red, green, and blue color channels.
redChannel = I(:, :, 1);
greenChannel = I(:, :, 2);
blueChannel = I(:, :, 3);
meanR = mean2(redChannel)/(3*Wts(1));
meanG = mean2(greenChannel)/(3*Wts(2));
meanB = mean2(blueChannel)/(3*Wts(3));
meanGray = mean2(grayImage);
% Make all channels have the same mean
redChannel = redChannel*meanGray / meanR;
greenChannel = greenChannel*meanGray / meanG;
blueChannel = blueChannel*meanGray / meanB;
% Recombine separate color channels into a single, true color RGB image.
IA = cat(3, redChannel, greenChannel, blueChannel);

end