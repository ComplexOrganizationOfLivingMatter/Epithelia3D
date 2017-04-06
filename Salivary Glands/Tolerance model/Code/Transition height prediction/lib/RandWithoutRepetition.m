function [m] = RandWithoutRepetition(imin,imax,K)
% Retunr K values between imin & imax

if (imax-imin < K)
    fprintf(' Error:excede el rango\n');
    m = NaN;
    return
end

n = 0; %counter of randoms
m = imin-1;
while (n < K)
    a = randi([imin,imax],1);
    if ((a == m) == 0)
        m = [m, a];
        n = n+1;
    end
end
m = m(:,2:end);