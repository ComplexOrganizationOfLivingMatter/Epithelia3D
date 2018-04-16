function [R1,R2,k1,k2] = calculateCurvatureInEllipsoidCoordinate(x,y,z,a,b,c)
%CALCULATECURVATUREINELLLIPSOIDCOORDIANTE calculation of max and min curvature in an ellipsoid point
%   a, b and c are the radii of the ellipsoid along the axes X, Y and Z respectively
%   x, y and z are the coordinates in the ellipsoid surfaces

    %parametric coordinates
    v= acosd(z / c);
    u= atand((a * y) / (b * x));

    %coefficients of the first fundamental form
    E= (((b^2) * (cosd(u)^2)) + ((a^2) * sind(u)^2)) * sind(v)^2;
    F= ((b^2) - (a^2)) * cosd(u) * sind(u) * cosd(v) * sind(v);
    G= ((a^2) * (cosd(u)^2) + (b^2) * (sind(u)^2)) * (cosd(v)^2) + (c^2) * (sind(v)^2);

    %coefficients of the second fundamental form
    e= (a * b * c * (sind(v)^2)) / sqrt((a * b * cosd(v))^2 + (c^2) * ((b^2) * (cosd(u)^2) + (a^2) * (sind(u)^2)) * (sind(v)^2));
    f= 0;
    g= (a * b * c) / sqrt((a * b * cosd(v))^2 + (c^2) * ((b^2) * (cosd(u)^2) + (a^2) * (sind(u)^2)) * (sind(v)^2));

    % K=1/(a*b*c((x^2/a^4)+(y^2/b^4)+(z^2/c^4)))^2;
    K= (e * g - f^2) / (E * G - F^2);

    % H=abs(x^2 +y^2 + z^2 - a^2 - b^2 - c^2)/(2*((a*b*c)^2)*((x^2/a^4)+(y^2/b^4)+(z^2/c^4)))^(3/2);
    H= (G * e - 2 * F * f + E * g) / (2 * (E * G - F^2));

    % Maximum radii of curvature
    R1= 1 / (H - sqrt(H^2 - K));
    k1= 1 / R1;
    % Minimum radii of curvature
    R2= 1 / (H + sqrt(H^2 - K));
    k2= 1 / R2;

end



