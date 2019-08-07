function [Color_Files,color_Image] = Read_Images(folder_name)

filePatternC = fullfile(folder_name, '*.jpg');

Color_Files   = dir(filePatternC);
if size(Color_Files,1) ==0
    filePatternC = fullfile(folder_name, '*.png');
end

Color_Files   = dir(filePatternC);

for k = 1:1:length(Color_Files)
    
    baseFileNameC = Color_Files(k).name;
    fullFileNameC = fullfile(folder_name, baseFileNameC);
    color_Image{k} = imread(fullFileNameC);
end
end

