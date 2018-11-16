function [meanPool,stdPool] = pooledMeanStdIterative(nGroups,meanGroups,stdGroups)

    
    varGroups = (stdGroups)^2;
    meanPool = meanGroups(1);
    varPool = (stdGroups(1))^2;
    nPool = nGroups(1);
    for i = 2 : length(nGroups)
        
        stdPool = sqrt ( ( nPool^2*varPool + nGroups(i)^2*varGroups(i) - nPool*varPool - nPool*varGroups(i) - nGroups(i)*varPool - ...
        nGroups(i)*varGroups(i) + nPool*nGroups(i)*varPool + nPool*nGroups(i)*varGroups(i) + nPool*nGroups(i)*(meanPool - meanGroups(i))^2 ) / ( (nPool+nGroups(i)-1)*(nPool+nGroups(i)) ) );
        
        meanPool = (nPool*meanPool + nGroups(i)*meanGroups(i)) / (nPool+nGroups(i));
        nPool = nPool + nGroups(i);
        varPool = stdPool^2;
    end
end

