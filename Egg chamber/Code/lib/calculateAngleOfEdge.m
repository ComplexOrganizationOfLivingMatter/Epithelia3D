function [ output_args ] = calculateAngleOfEdge( ellipsoidInfo )
%CALCULATEANGLEOFEDGE Summary of this function goes here
%   Detailed explanation goes here

R = makerefmat(x11, y11, dx, dy);

latsAndLons = pix2latlon(ellipsoidReference, xPoints, yPoints);

majorSemiAxis = max([ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius]);
minorSemiAxis = min([ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius]);
az = azimuth(lat1, lon1, lat2, lon2, [majorSemiAxis (1 - (minorSemiAxis / majorSemiAxis)^2)]);

end

