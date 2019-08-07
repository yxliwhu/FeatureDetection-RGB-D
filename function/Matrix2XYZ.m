function [x,y,z] = Matrix2XYZ(Z)
[row,col]=size(Z);
[X,Y]=meshgrid(1:col,1:row);
x=X(:)';%column
y=Y(:)';
z=Z(:)';
end
