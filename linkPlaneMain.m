%%
clc;clear;
fprintf('Choose The File Path For The Pairs of Images\n');
folder_name = uigetdir;
addpath('./function/');
[colors,depths,Labels,Infoms] = Read_Input_data(folder_name);
ResultDir = [folder_name,'/FigureResultinit5-24-4-0.06/'];
mkdir(ResultDir);
%%
for k = 1:length(Infoms)
    label = Labels{k};
    infom = Infoms{k};
    depth = depths{k};
    labelNew{k} = linkPlane(label,infom,depth);
    figure(1);
    subplot(2,2,1);
    imagesc(colors{k});
    subplot(2,2,2);
    imagesc(depth);
    subplot(2,2,3);
    imagesc(label);
    subplot(2,2,4);
    imagesc(labelNew{k});
    saveas(gcf,[ResultDir 'frame' int2str(k) '.png']);
    close all;
end
