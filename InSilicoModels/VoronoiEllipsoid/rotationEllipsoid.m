addpath 'lib/AxelRot'

filePathStage4='results\Stage 4\';

load([filePathStage4 'random_1\ellipsoid_x12642_y1_z1_cellHeight02216.mat'],'ellipsoidInfo','initialEllipsoid')

round([initialEllipsoid.xCenter,initialEllipsoid.yCenter,initialEllipsoid.zCenter]*initialEllipsoid.resolutionEllipse);

[H,W,c]=size(initialEllipsoid.img3DLayer);
x0=[0 round([initialEllipsoid.yCenter,initialEllipsoid.zCenter]*initialEllipsoid.resolutionEllipse)];
u=[H,0,0];
deg=45;

[R, t] = AxelRot(deg, u, x0); 
% M=AxelRot(deg,u,x0);
T=affine3d([[R;0 0 0],[0;0;0;1]]);
ellipsoidRotated=imwarp(initialEllipsoid.img3DLayer,T);


