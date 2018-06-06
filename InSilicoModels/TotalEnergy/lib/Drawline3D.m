function [xnAcum,ynAcum,znAcum] = Drawline3D (X0, Y0, Z0, X1, Y1, Z1)
%DRAWLINE3D   Generate a line in 3D according to the points (centroids) that are passed
%   
        xnAcum=[];
        ynAcum=[];
        znAcum=[];
    for n = 0:(1/round(sqrt((X1-X0)^2 + (Y1-Y0)^2 + (Z1-Z0)^2))):1 
        xn = round(X0 +(X1 - X0)*n); 
        yn = round(Y0 +(Y1 - Y0)*n); 
        zn = round(Z0 +(Z1 - Z0)*n); 
        xnAcum=[xnAcum;xn];
        ynAcum=[ynAcum;yn];
        znAcum=[znAcum;zn];
    end