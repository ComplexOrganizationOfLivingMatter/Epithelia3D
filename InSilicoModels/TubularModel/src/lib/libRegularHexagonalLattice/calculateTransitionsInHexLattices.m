function [neighsTarget,neighsAccum,hexLatticesExpanded] = calculateTransitionsInHexLattices(label2Follow,maskHexRotLat,centSeedsRotated,SR,path2save)
    
    

    if ~exist(path2save,'file')
        maxLabel = max([maskHexRotLat(:)]);
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
            
            hexLatticesExpanded{nSR} = hexLatticeExpaMask;
            
%             if mod(SR(nSR),5)==0[x,y] = find(imgReduced>0);
            binaryImg = ismember(hexLatticeExpaMask,unique(vertcat(neighsTarget{:})));
            [x,y] = find(binaryImg>0);

            bBox = [min(y)-1 min(x)-1 (max(y)-min(y)+2) (max(x)-min(x)+2)];
            hexLatticeExpaMaskCrop = imcrop(hexLatticeExpaMask,bBox);

            h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');   
            imshow(hexLatticeExpaMaskCrop,colorcube(maxLabel));
            print(h,[strrep(path2save,'.mat','') 'SR' strrep(num2str(SR(nSR)),'.','_')],'-dtiff','-r300')
            close
%             end

        end
        save(path2save,'-v7.3','neighsTarget','neighsAccum','hexLatticesExpanded')
    else
        load(path2save,'neighsTarget','neighsAccum','hexLatticesExpanded')
    end
    
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');   
    plot(SR,[neighsAccum{:}],'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    xlabel('surface ratio')
    ylabel('neighbours total')
    titleFig = strsplit(strrep(path2save,'.mat',''),'\');
    titleFig = titleFig{end};
    title(['euler neighbours 3D ' titleFig])
    ylim([6 24])
    
    print(h,[strrep(path2save,'.mat','') 'Euler3D'],'-dtiff','-r300')

end
