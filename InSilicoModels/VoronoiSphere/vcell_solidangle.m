function s = vcell_solidangle(P, K)
% s = vcell_solidangle(P, K)
%
% Compute the solid angles of All voronoi cell
%
% P is (3 x m) array of vertices, coordinates of the vertices of voronoi diagram
% K is (n x 1) cell, each K{j} contains the indices of the voronoi cell
%
% Restrictions:
% - P must be unit vectors
% - For each cell vertices must be counter-clockwise oriented when looking from outside
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date creation: 16/July/2014
%
% See also: voronoisphere

% Turn it to false to maximize speed
check_unit = true;

if check_unit
    u = sum(P.^2, 1);
    if any(abs(u-1) > 1e-6)
        error('vcell_solidangle:Pnotnormalized', ...
            'vcell_solidangle: P must be unit vectors');
    end
end

s = cellfun(@(k) one_vcell_solidangle(P(:,k)), K);

end % vcell_solidangle

%%
function omega = one_vcell_solidangle(v)
% omega = one_vcell_solidangle(v)
% Compute the solid angle of spherical polygonal defined by v
% v is (3 x n) matrix, each column is the coordinates of the vertex (unit vector, not checked)
% "correctly" oriented
%
% Ref: A. van Oosterom, J. Strackee:? A solid angle of a plane triangle.? – IEEE Trans. Biomed. Eng. 30:2 (1983); 125–126. 
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date creation: 16/July/2014
%
% See also: vcell_solidangle

n = size(v,2);
s = zeros(1,n);
for i = 2:n-1
    T = v(:,[1 i i+1]);
    num = det(T);
    denom = 1 + sum(sum(T .* T(:,[2 3 1]), 1), 2);
    s(i) = num / denom;
end

omega = atan(s);
omega = 2 * sum(omega);

end % one_vcell_solidangle
