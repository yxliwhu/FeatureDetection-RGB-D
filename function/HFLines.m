function lines = HFLines(image,NHoodSize,Threshold,fillgap,minlength)
BW = edge(image,'canny');
% imshow(BW);
[H,theta,rho] = hough(BW);
% figure
% imshow(imadjust(rescale(H)),[],...
%     'XData',theta,...
%     'YData',rho,...
%     'InitialMagnification','fit');
% xlabel('\theta (degrees)')
% ylabel('\rho')
% axis on
% axis normal
% hold on
% colormap(gca,hot)
P = houghpeaks(H,NHoodSize,'threshold',ceil(Threshold*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
% plot(x,y,'s','color','black');
lines = houghlines(BW,theta,rho,P,'FillGap',fillgap,'MinLength',minlength);

% highlight the longest line segment
end