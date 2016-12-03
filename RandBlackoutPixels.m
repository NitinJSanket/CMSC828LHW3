function IBO = RandBlackoutPixels(I, BlackOutFrac)
% Function to Blackout a fraction of an image
% Inputs:
% I: Image
% BlackOutFrac: Fracton of pixels that have to be blacked out (out of 1,
% 0.5 means 50% pixels will be blacked out)
% Output:
% IBO: Image with blackedout pixels
% Sample Usage:
% I = imread('ferrari.jpg');
% BlackOutFrac = 0.3;
% IBO = RandBlackoutPixels(I, BlackOutFrac);
% Code modified by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD Student in Computer Science at University of Maryland, College Park
% Dec 2016

if(nargin<2)
   BlackOutFrac = 0.5; 
end

I = im2double(I);
IBO = I;

RandIdxs = randperm(numel(I(:,:,1)),ceil(numel(I(:,:,1))*BlackOutFrac));

for count = 1:size(I,3)
    INow = IBO(:,:,count);
    INow(RandIdxs) = 0;
    IBO(:,:,count) = INow;
end

end