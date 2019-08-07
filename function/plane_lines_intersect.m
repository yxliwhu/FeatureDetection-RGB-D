function intersectPoints = plane_lines_intersect(planeVector,planePoint,linesVector,linePoints)
vpt = sum(linesVector .* planeVector,2);
t = sum((planePoint - linePoints).*planeVector,2)./vpt;
intersectPoints =linePoints + linesVector.*t;
