clear;clc;
fprintf('Choose The File Path For The Pairs of Images\n');
folder_name = uigetdir;
%% 
addpath('./function/')
[depthName,depthlist] = Read_Depth_Data(folder_name);
[colorName,colorlist] = Read_Images(folder_name);
resultDir = [folder_name '/Image2jgp'];
mkdir(resultDir);
%%
for i = 1:length(depthlist)
    if i < 10
        frameValue = ['00000' int2str(i)];
    elseif i<100
        frameValue = ['0000' int2str(i)];
    elseif i<1000
        frameValue = ['000' int2str(i)];
    elseif i<10000
        frameValue = ['00' int2str(i)];
    elseif i<100000
        frameValue = ['0' int2str(i)];
    else
        frameValue = int2str(i);
    end
    tempColorName = [resultDir  '/frame-'  frameValue '.color.png'];
    tempdepthName = [resultDir  '/frame-' frameValue '.depth.png'];
    
    imwrite(colorlist{i},tempColorName);
    depthValue = depthlist{i};
    depthValue(find(isnan(depthValue)))=0;
    depthValue =uint16(depthValue);
    imwrite(depthValue,tempdepthName);
end
