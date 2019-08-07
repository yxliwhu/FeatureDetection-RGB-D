function [keyPoints,lines,planeresult] = outputFeatures(rawimage,depthImg,cameraParamsRGB,cameraParamsIR,figuredir,index)
% rawimage = imread('images/color_000000.png');
grayimage = rgb2gray(rawimage);
% Sift Points Detection in RGB Image
Siftimage = double(grayimage);
keyPoints = SIFT(Siftimage,3,4,1.3);
Siftimage = SIFTKeypointVisualizer(Siftimage,keyPoints);
figure(1);
subplot(1,3,1);
imshow(uint8(Siftimage));
% HF Lines Detection in RGB Image
subplot(1,3,2);
imshow(grayimage);
hold on;
lines = HFLines(grayimage,5,0.2,5,7);
% max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

% Plane Detection in Point Cloud
% load('cameraParamA2.mat');
% depthImg = Read_Signal_Depth_Data('images/Depth_000000.R00');
ptCloud = creatPointcloud(rawimage,depthImg,cameraParamsRGB,cameraParamsIR);
% calculate the normals of the pointcloud
% sensorCenter = [0,0,0];
% normals = pcnormals(ptCloud,400);
% x = ptCloud.Location(1:10:end,1);
% y = ptCloud.Location(1:10:end,2);
% z = ptCloud.Location(1:10:end,3);
% u = normals(1:10:end,1);
% v = normals(1:10:end,2);
% w = normals(1:10:end,3);
% figure
% pcshow(ptCloud)
% title('Estimated Normals of Point Cloud')
% hold on
% quiver3(x,y,z,u,v,w);
% hold off
% axis equal;
maxDistance = 100;
% maxAngularDistance = 5;
remainPtCloud = ptCloud;
planeresult = {};
while remainPtCloud.Count > ptCloud.Count*0.2
    [model,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud,...
        maxDistance);
    if length(inlierIndices) > ptCloud.Count*0.1
        plane = select(remainPtCloud,inlierIndices);
        tempStruct = struct('Name',index,'model',model,'plane',plane);
        planeresult = [planeresult,tempStruct];
    end
    if ~isempty(model)
        remainPtCloud = select(remainPtCloud,outlierIndices);
    else
        break;
    end
    
end
colorStep = 1/(length(planeresult)+1);
subplot(1,3,3);
for i = 1:length(planeresult)
    pcshow(planeresult{i}.plane.Location,[colorStep*i,abs(colorStep*i-0.5),1-colorStep*i]);
    hold on;
end
saveas(gcf,[figuredir '/' index '.png']);
close all;
end


