clear;clc;
fprintf('Choose The File Path For The Pairs of Images\n');
folder_name = uigetdir;
load('cameraParamA2.mat');
resultDir = [folder_name '/RansacResult'];
mkdir(resultDir);
figuredir = [resultDir '/figures'];
mkdir(figuredir);
addpath('./function/')
[depthName,depthlist] = Read_Depth_Data(folder_name);
[colorName,colorlist] = Read_Images(folder_name);
%% 
Features = {};
for i = 1:length(depthlist)
    sprintf("Processing Frame %i ...",i)
    index = depthName(i).name(7:end-4);
    [keyPoints,lines,planeresult] = outputFeatures(colorlist{i},depthlist{i},cameraParamsRGB,cameraParamsIR,figuredir,index);
    tempStruct = struct('Name',index,'KeyPoints',{keyPoints},'Lines',{lines},'Planes',{planeresult});
    Features = [Features,tempStruct];
end
save([resultDir '/outputFeatures.mat'],'Features');