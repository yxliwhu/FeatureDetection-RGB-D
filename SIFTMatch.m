addpath('./function/');
% test SIFT implementation
Octaves = 3;
Scales = 4;
Sigma = 1.3;

% read first image 
fprintf('Computing keypoints for image 1...\n');
I1 = imread('Dataset/ZN603A/frame-000001.color.png');
% I1 = imread('Dataset/test1.jpeg');
I1 = rgb2gray(I1);

I1 = double(I1);
keypoints1 = SIFT(I1, Octaves, Scales, Sigma);

% read second image
fprintf('Done.\nComputing keypoints for image 2...\n');
I2 = imread('Dataset/ZN603A/frame-000005.color.png');
% I2 = imread('Dataset/test2.jpeg');
I2 = rgb2gray(I2);

I2 = double(I2);
keypoints2 = SIFT(I2, Octaves, Scales, Sigma);

%% show matching keypoints
fprintf('Done.\nComputing matches...\n');
matches = computeMatches(keypoints1, keypoints2);
fprintf('%d matches found', size(matches, 1));
%%
location1 = [];
for i = 1:length(keypoints1)
    location1 = [location1;keypoints1{i}.Coordinates];
end
location2 = [];
for i = 1:length(keypoints2)
    location2 = [location2;keypoints2{i}.Coordinates];
end
%%
validCount = 0;
iterNum =0;
while (validCount<20 && iterNum < 50)
            [H, corrPtIdx] = findHomography(int16(location1'),int16(location2'));
            ransacLoc1=tempMatchedPoints1(corrPtIdx,:);
            
            ransacLoc2=tempMatchedPoints2(corrPtIdx,:);
            loc=[ransacLoc1,ransacLoc2];
            loc=unique(loc,'rows');
            validCount = size(loc,1);
            if validCount > preValidCount
                matchedPoints1=loc(:,1:2);
                matchedPoints2=loc(:,3:4);
                preValidCount = validCount;
            end
            iterNum =iterNum +1;
        end
% display keypoints
figure;
imshow(uint8(I1));
hold on;
plot(location1(:, 2), location1(:, 1), 'r+');

% display keypoints
figure;
imshow(uint8(I2));
hold on;
plot(location2(:, 2), location2(:, 1), 'r+');
%%
showMatchedFeatures(I1,I2,[matches(:,2),matches(:,1)],[matches(:,4),matches(:,3)]);
