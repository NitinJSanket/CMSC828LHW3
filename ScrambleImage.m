function [I, ScrambledI] = ScrambleImage(I, WindowSize, NumScramblings, ForceFlag, CropFlag)
% Function to scramble an image blockwise
% Inputs:
% I: Image
% WindowSize: The size of the window which will be scrambled, [r,c]
% NumScramblings: Number of times you want to shuffle the image, min. 2 times recommended
% ForceFlag: Deactive by default,
% forces to use windows which don't divide image exactly, if deactive the algorithm crops/resizes (depends on CropFlag)
% image such that window size divides image perfectly (Resizes by default)
% Output:
% I: Image might have been cropped
% ScrambledI: Scrambled Image
% Sample Usage:
% I = imread('ferrari.jpg');
% WindowSize = [40, 40];
% NumScramblings = 10;
% [I, ScrambledI] = ScrambleImage(I, WindowSize, NumScramblings);
% Code by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD Student in Computer Science at University of Maryland, College Park
% Dec 2016

if(nargin<5)
    ForceFlag = 0;
    CropFlag = 0;
end

if(nargin<4)
    CropFlag = 0;
end

if(nargin<3)
    NumScramblings = 2;
    if(nargin<2)
        WindowSize = [40, 40]; % r,c
    end
end



if(~ForceFlag) % Change window sizes to divide image exactly
    ImageSize = [floor(size(I,1)/WindowSize(1))*WindowSize(1), floor(size(I,2)/WindowSize(2))*WindowSize(2)];
    if(CropFlag)
        % Crop Image
        I = I(1:ImageSize(1), 1:ImageSize(2),:);
    else
        % Resize Image
        I = imresize(I, ImageSize, 'bicubic');
    end
end

NumWindows = [ceil(size(I,1)/WindowSize(1)), ceil(size(I,2)/WindowSize(2))];

WindowEdgesRow = [1:WindowSize(1):size(I,1)]';
WindowEdgesCol = [1:WindowSize(2):size(I,2)]';

WindowEdgesRow = repmat(WindowEdgesRow, 1, size(WindowEdgesCol,1));
WindowEdgesCol = repmat(WindowEdgesCol', size(WindowEdgesRow,1), 1);

% Extract All the Patches
Patch = @(I, WindowSize, WindowNow) I(WindowNow(1):min(WindowSize(1)+WindowNow(1)-1, size(I,1)),...
    WindowNow(2):min(WindowSize(2)+WindowNow(2)-1, size(I,2)), :);

PatchExtracted = cell(size(WindowEdgesRow));
for count = 1:numel(WindowEdgesRow)
    PatchExtracted{count} = Patch(I, WindowSize, [WindowEdgesRow(count),WindowEdgesCol(count)]);
end


%% Case when window divides image exactly
if ((mod(size(I,1),WindowSize(1))==0) && (mod(size(I,2),WindowSize(2))==0))
    % Window size divides image exactly
    PatchScrambled = cell(size(WindowEdgesRow));
    Idxs = randperm(numel(PatchExtracted));
    
    for count = 1:length(Idxs)
        PatchScrambled{Idxs(count)} = PatchExtracted{count};
    end
    
    ScrambledI = [];
    for count = 1:size(PatchScrambled,2)
        MiniPatch = [];
        for count2 = 1:size(PatchScrambled,1)
            MiniPatch = [MiniPatch; PatchScrambled{count2, count}];
        end
        ScrambledI = [ScrambledI, MiniPatch];
    end
    
    return;
end

%% Scramble Indexes Randomly
for times = 1:NumScramblings
    if(times==1)
        PatchScrambled = cell(size(WindowEdgesRow));
    else
        PatchScrambledTemp = cell(size(WindowEdgesRow));
    end
    IdxsRow = randperm(size(PatchExtracted,1));
    IdxsCol = randperm(size(PatchExtracted,2));
    
    
    for count = 1:size(PatchExtracted,2) % Scramble columnwise
        for count2 = 1:size(PatchExtracted,1) % Scramble rowwise
            if(times==1)
                PatchScrambled{IdxsRow(count2),IdxsCol(count)} = PatchExtracted{sub2ind(size(PatchExtracted),count2,count)};
            else
                PatchScrambledTemp{IdxsRow(count2),IdxsCol(count)} = PatchScrambled{sub2ind(size(PatchExtracted),count2,count)};
            end
        end
    end
    
    if(times~=1)
        PatchScrambled = PatchScrambledTemp;
    end
    
    
    ScrambledI = [];
    for count = 1:size(PatchScrambled,2)
        MiniPatch = [];
        for count2 = 1:size(PatchScrambled,1)
            MiniPatch = [MiniPatch; PatchScrambled{count2, count}];
        end
        ScrambledI = [ScrambledI, MiniPatch];
    end
    
end
end