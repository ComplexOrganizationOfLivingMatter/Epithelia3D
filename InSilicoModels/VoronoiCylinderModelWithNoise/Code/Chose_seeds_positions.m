function [m] = Chose_seeds_positions(imin,imax1,imax2,K,length)

% Resolve K random values between imin and imax
if ((imax1-(imin-1))*(imax2-(imin-1)) < K)
    fprintf(' Error: Excede el rango\n');
    m = NaN;
    return
end

m(1,1) = randi([imin,imax1],1);
m(1,2) = randi([imin,imax2],1);

n=1;

while (n<=K-1)

    a = randi([imin,imax1],1);
    b = randi([imin,imax2],1);
    dato=[a,b];

    for i=1:size(m,1)
        distance=sqrt(((m(i,1)-a)^2)+((m(i,2)-b)^2));
    
        if distance<=length
            ind(i)=1;
        else
            ind(i)=0;
        end
    end

    if sum(ind)==0
        dato=[a,b];
        m = [m; dato];
        n=n+1;
    end

end

m = m(1:end,:);