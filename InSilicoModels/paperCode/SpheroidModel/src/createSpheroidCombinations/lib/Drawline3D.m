function [img] = Drawline3D(img, X0, Y0, Z0, X1, Y1, Z1,labelSeeds)
    for n = 0:(1/round(sqrt((X1-X0)^2 + (Y1-Y0)^2 + (Z1-Z0)^2))):1 
        xn = round(X0 +(X1 - X0)*n); 
        yn = round(Y0 +(Y1 - Y0)*n); 
        zn = round(Z0 +(Z1 - Z0)*n); 
        img(xn,yn,zn) = labelSeeds;
    end
end