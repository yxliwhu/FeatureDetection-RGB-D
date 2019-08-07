function [ Depth_Files,Unfilter_data] = Read_Depth_Data( folder_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% load('depth_plane_mask.mat');
filePattern = fullfile(folder_name, '*.R00');
% filePatternC = fullfile(folder_name, '*.jpg');
Depth_Files   = dir(filePattern);
% Color_Files   = dir(filePatternC);
i = 0;
for k = 1:1:length(Depth_Files)
  baseFileName = Depth_Files(k).name;
  fullFileName = fullfile(folder_name, baseFileName);

  [fid, msg] = fopen(fullFileName, 'r');
  [filename, permission, machineformat, encoding] = fopen(fid);
if(fid<0)
  error('kinect_toolbox:readpgm_noscale:fileOpen', ...
        [fullFileName ': ' msg]);
end

% magic=fscanf(fid,'%c',2);

width=640; %fscanf(fid,'%d',1);
height=480 ;%fscanf(fid,'%d',1);
% max_value=fscanf(fid,'%d',1);

channels = 1;
numvals = width*height*channels;

%Skip final whitespace
% fscanf(fid,'%c',1);

%Read data

[data,count]=fread(fid,numvals,'*single',0,'ieee-le');


 if length(fread(fid, 1, 'char'));
    warning('kinect_toolbox:readpgm_noscale:extraData', ...
            '%s: file contains extra data.',fullFileName);
 end

fclose(fid);

if count < numvals
  warning('kinect_toolbox:readpgm_noscale:unexpectedEOF', ...
          '%s: file ended while reading image data.',fullFileName);
  % Filling the missing values by zeros.
  data(numvals) = 0;
end

data = reshape(data, [channels width height]);
data = permute(data, [3 2 1]);
data = double(data);

% % make the mask on depth
% Din = ones(size(data));
% Din(1:100,:) = 0; 
% Din(400:480,:) = 0; 
% Din(:,1:100) = 0; 
% Din(:,500:640) = 0; 
% make outer mask
% Dout =double( Din);
% AAin  = data.*Din; 
% AAin(AAin==0)=nan;
% AAout  = data.*Dout; 
% AAout(AAout==0)=nan;
data(data==0)=nan;
%C_Unfilter_data{k} = AAin;
%Unfilter_data{k} = data; %
Unfilter_data{k} = data;


end
end

