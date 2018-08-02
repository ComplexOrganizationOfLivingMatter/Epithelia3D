function [linePoints] = line3D(initialPoint, endPoint)
%LINE3D Summary of this function goes here
%   Detailed explanation goes here
    X0 = initialPoint(:, 1);
    Y0 = initialPoint(:, 2);
    Z0 = initialPoint(:, 3);
    X1 = endPoint(:, 1);
    Y1 = endPoint(:, 2);
    Z1 = endPoint(:, 3);
    
    xn = [];
    yn = [];
    zn = [];
    for n = 0:(1/round(sqrt((X1-X0)^2 + (Y1-Y0)^2 + (Z1-Z0)^2))):1 
        xn = [xn, round(X0 +(X1 - X0)*n)]; 
        yn = [yn, round(Y0 +(Y1 - Y0)*n)]; 
        zn = [zn, round(Z0 +(Z1 - Z0)*n)];
    end
    linePoints = [xn', yn', zn'];
end

