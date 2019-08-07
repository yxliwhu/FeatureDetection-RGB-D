function labelNew = linkPlane(label,infom,depth)
% set up params
Cx = 322.34;
Cy = 246.21;
Fx = 581.19;
Fy = 581.43;
angelThreshold = 4;
disThreshold = 0.06;
% planeDisThreshold = 0.01;
% rayThreshold = cos(deg2rad(80));
labelNew = label;
mynormalAngles = zeros(size(infom,1),size(infom,1));
mydis1 = zeros(size(infom,1),size(infom,1));
mydis2 = zeros(size(infom,1),size(infom,1));
myray1 = zeros(size(infom,1),size(infom,1));
myay2 = zeros(size(infom,1),size(infom,1));
refer = linspace (1,size(infom,1),size(infom,1));
for i = 1:size(infom,1)-1
    for j = i+1:size(infom,1)
        
        
        % calculate distance difference
        [c1,d1] = find(label == i);
        [c2,d2] = find(label == j);
        z1 = double(depth(sub2ind(size(depth),c1,d1)));
        x1 = (d1-Cx).*z1./Fx;
        y1 = (c1-Cy).*z1./Fy;
        x1 = x1./1000;
        y1 = y1./1000;
        z1 = z1./1000;
        depthAverage1 = mean(z1);
         
        z2 = double(depth(sub2ind(size(depth),c2,d2)));
        x2 = (d2-Cx).*z2./Fx;
        y2 = (c2-Cy).*z2./Fy;
        x2 = x2./1000;
        y2 = y2./1000;
        z2 = z2./1000;       
        depthAverage2 = mean(z2);
%         pointcloud2 = pointCloud([x2,y2,z2]);
%         model2 = pcfitplane(pointcloud2,depthAverage2*planeDisThreshold...
%             ,'Confidence',99.99999); 
%         pointcloud1 = pointCloud([x1,y1,z1]);
%         model1 = pcfitplane(pointcloud1,depthAverage1*planeDisThreshold...
%             ,'Confidence',99.99999);
%         normal1 = model1.Normal;
%         normal2 = model2.Normal;
        normal1 = infom(i,6:8);
        normal2 = infom(j,6:8);


        center1 = infom(i,9:11)./1000;
        center2 = infom(j,9:11)./1000;
        % calculate angle difference
        normalAngle = rad2deg(acos(dot(normal1,normal2)...
            /norm(normal1,2)/norm(normal2,2)));
        mynormalAngles(i,j) = normalAngle;
        insectPointset1 = plane_lines_intersect(normal1,center1,normal1,[x2,y2,z2]);
        aveageDis1 = mean(sqrt((insectPointset1(:,1)-x2).^2+ ...
            (insectPointset1(:,2)-y2).^2+ ...
            (insectPointset1(:,3)-z2).^2));
        
        insectPointset2 = plane_lines_intersect(normal2,center2,normal2,[x1,y1,z1]);
        aveageDis2 = mean(sqrt((insectPointset2(:,1)-x1).^2+ ...
            (insectPointset2(:,2)-y1).^2+ ...
            (insectPointset2(:,3)-z1).^2));
        mydis1(i,j)  = aveageDis1;
        mydis2(i,j)  = aveageDis2;
        % calculate ray difference
        rayvector = center1 - center2;
        rayAngel1 = dot(normal1,rayvector)...
            /norm(normal1,2)/norm(rayvector,2);
        rayAngel2 = dot(normal2,rayvector)...
            /norm(normal2,2)/norm(rayvector,2);
        myray1(i,j)  = rayAngel1;
        myay2(i,j)  = rayAngel2;
        %&&(rayAngel1<rayThreshold)&&...
        %        (rayAngel2<rayThreshold)
        if ((normalAngle<angelThreshold*max(depthAverage1,depthAverage2))...
                &&(aveageDis1<disThreshold*depthAverage1)&&...
                (aveageDis2<disThreshold*depthAverage2))
            %disp(['Angle the value possibel is ' num2str(i) ' and ' num2str(j)]);
            
            if ((refer(j) == j)&&(refer(i)==i))
                tureIndex = i;
                refer(j) = i;
            elseif ((refer(j) == j)&&(refer(i)~=i))
                tureIndex = refer(i);
            elseif ((refer(j) ~= j)&&(refer(i)==i))
                if refer(j)>=i
                    tureIndex = i;
                    refer(j) = i;
                else
                    tureIndex = refer(j);
                    refer(i) = refer(j);
                end
            else
                if refer(j)>=refer(i)
                    tureIndex = refer(i);
                    refer(j) = refer(i);
                else
                    tureIndex = refer(j);
                    refer(i) = refer(j);
                end
            end
            labelNew(sub2ind(size(labelNew),c2,d2)) = tureIndex;
        end
        
    end
end
end
