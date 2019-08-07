function [Colors,Depth_Images,Labels,Informations] = Read_Input_data(folder_name)

filePattern_depth = fullfile(folder_name, '*.depth.png');

Depth_Files = dir(filePattern_depth);

for k = 1:length(Depth_Files)
    baseFileNameD = Depth_Files(k).name;
    fullFileNameD = fullfile(folder_name, baseFileNameD);
    Depth_Images{k} = imread(fullFileNameD);
end

filePattern_color = fullfile(folder_name, '*.color.png');

color_Files = dir(filePattern_color);

for k = 1:length(color_Files)
    baseFileNameC = color_Files(k).name;
    fullFileNameC = fullfile(folder_name, baseFileNameC);
    Colors{k} = imread(fullFileNameC);
end

labels_info_folder_name = [folder_name '/planes-all-frames'];
filePattern_label = fullfile(labels_info_folder_name,'*label-opt.txt');
label_Files = dir(filePattern_label);
for k = 1:length(label_Files)
    baseFileNameL = label_Files(k).name;
    fullFileNameL = fullfile(labels_info_folder_name, baseFileNameL);
    delimiterIn = ' ';
    headerlinesIn = 1;
    A = importdata(fullFileNameL,delimiterIn,headerlinesIn);
    Labels{k} = A.data +1;
end

filePattern_info = fullfile(labels_info_folder_name,'*data-opt.txt');
info_Files = dir(filePattern_info);
for k = 1:length(info_Files)
    baseFileNameI = info_Files(k).name;
    fullFileNameI = fullfile(labels_info_folder_name, baseFileNameI);
    delimiterIn = ' ';
    headerlinesIn = 1;
    A = importdata(fullFileNameI,delimiterIn,headerlinesIn);
    Informations{k} = A.data;
end
end
