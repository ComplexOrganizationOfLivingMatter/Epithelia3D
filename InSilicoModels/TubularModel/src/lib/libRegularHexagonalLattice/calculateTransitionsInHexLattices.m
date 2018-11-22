function [neighsTarget,neighsAccum,hexLatticesExpanded] = calculateTransitionsInHexLattices(label2Follow,maskHexRotLat,centSeedsRotated,SR,path2save)
    
    indSeedsInit = sub2ind(size(maskHexRotLat),centSeedsRotated(:,1),centSeedsRotated(:,2));
    hexLatticesExpanded = cell(length(SR),1);
    neighsTarget = cell(length(SR),1);
    neighsAccum = cell(length(SR),1);

    for nSR = 1:length(SR)
        centExpansion=[centSeedsRotated(:,1),round(centSeedsRotated(:,2).*SR(nSR))];
        maskExpansion = zeros(size(maskHexRotLat,1),round(size(maskHexRotLat,2)*SR(nSR)));
        
        indSeedsExp = sub2ind(size(maskExpansion),centExpansion(:,1),centExpansion(:,2));

        maskExpansion(indSeedsExp) = 1;
        bwMaskExpansion =  bwdist(maskExpansion>0);
        hexLatticeExpa = watershed(bwMaskExpansion);
        
        waterLabel = hexLatticeExpa(indSeedsExp);
        initLabel = maskHexRotLat(indSeedsInit);
        %relabelHexagonalLattice
        hexLatticeExpaMask = zeros(size(hexLatticeExpa));
        for nLab = 1:length(waterLabel)
            hexLatticeExpaMask(hexLatticeExpa==waterLabel(nLab)) = initLabel(nLab);
        end
        
        
        neighs = calculateNeighbours(hexLatticeExpaMask,label2Follow);
        neighsTarget{nSR} = neighs{label2Follow};
        
        if SR(nSR)==1
            neighsAccum{nSR} = length(neighsTarget{nSR});
        else
            neighsAccum{nSR} = length(unique(vertcat(neighsTarget{:})));
        end
       
    end
%         maxLabel = max([maskHexRotLat(:)]);
%     figure;imshow(hexLatticeExpaMask,colorcube(maxLabel));
    save(path2save,'-v7.3','neighsTarget','neighsAccum','hexLatticesExpanded')

end
