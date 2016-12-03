function IF = ExtractFreqBands(I, EllipseAxes, InvertFlag)
% Function to particular frequency bands from an image
% Inputs:
% I: Image
% EllipseAxes: Frequencies are extracted as blurred ellipses on the
% FFT spectrum, if you want difference between 2 frequencies, EllipseAxes
% will be of size 2x2, first row corresponds to inner ellipse and second
% row corresponds to outer ellipse
% InvertFlag: If 1 extracts frequencies not included by the mask defined by
% EllipseAxes, 0 by default 
% Output:
% IF: Image with required frequency bands
% Sample Usage:
% I = imread('ferrari.jpg');
% EllipseAxes [10, 10];
% IF = ExtractFreqBands(INow, EllipseAxes);
% Code modified by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD Student in Computer Science at University of Maryland, College Park
% Dec 2016

if(nargin<3)
    InvertFlag = 0;
end

if(nargin<2)
    EllipseAxes = [10,10]; % a is along columns ,b is along rows
end

if(EllipseAxes(1,1)>ceil(size(I(:,:,1),2)/2))
    warning('EllipseAxes(1,1) is out of bounds setting value to image dimensions');
    EllipseAxes(1,1) = ceil(size(I(:,:,1),2)/2);
end
if(EllipseAxes(1,2)>ceil(size(I(:,:,1),1)/2))
    warning('EllipseAxes(1,2) is out of bounds setting value to image dimensions');
    EllipseAxes(1,2) = ceil(size(I(:,:,1),1)/2);
end
if(EllipseAxes(2,1)>ceil(size(I(:,:,1),2)/2))
    warning('EllipseAxes(2,1) is out of bounds setting value to image dimensions');
    EllipseAxes(2,1) = ceil(size(I(:,:,1),2)/2);
end
if(EllipseAxes(2,2)>ceil(size(I(:,:,1),1)/2))
    warning('EllipseAxes(2,2) is out of bounds setting value to image dimensions');
    EllipseAxes(2,2) = ceil(size(I(:,:,1),1)/2);
end


for count = 1:size(I,3)
    % Frequency domain manipulations
    INow = I(:,:,count);
    F = fftshift(fft2(im2double(INow)));
    [c,r] = meshgrid(1:size(INow,2),1:size(INow,1));
    % Center the co-ordinates
    c = ceil(c-size(INow,2)/2);
    r = ceil(r-size(INow,1)/2);
    
    
    Mask = double(c.^2/EllipseAxes(1,1).^2 + r.^2/EllipseAxes(1,2).^2 <= 1);
    Mask = imfilter(Mask, fspecial('gaussian',2.*fliplr(EllipseAxes(1,:)),ceil(min(EllipseAxes(1,:))/2)));
    if(size(EllipseAxes,1)==2)
        Mask2 = double(c.^2/EllipseAxes(2,1).^2 + r.^2/EllipseAxes(2,2).^2 <= 1);
        Mask2 = imfilter(Mask2, fspecial('gaussian',2.*fliplr(EllipseAxes(2,:)),ceil(min(EllipseAxes(2,:))/2)));
        if(~InvertFlag)
        F = F.*(-Mask) + F.*(Mask2);
        else
            F = F.*(Mask) + F.*(1-Mask2);
        end
    else
        if(~InvertFlag)
        F = F.*(Mask);
        else
            F = F.*(1-Mask);
        end
    end

    % Reconstruct Image
    IF = mat2gray(abs(ifft2(ifftshift(F))));
end

end