function plotpc(depthImg)
depth_cx = 316.138;
depth_cy = 249.779;
depth_Tx = 0;
depth_Ty = 0;
depth_fx = 557.98;
depth_fy = 557.98;
[Db1,Da1,Dc1] = Matrix2XYZ(depthImg);
Db1 = ((Db1-depth_cx).*Dc1-depth_Tx)./depth_fx;
Da1 = ((Da1-depth_cy).*Dc1-depth_Ty)./depth_fy;
pcDepthRaw = pointCloud([Db1',Da1',Dc1']);
pcshow(pcDepthRaw);
end