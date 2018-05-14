function [ finalCentroid ] = organizationTracking( finalCentroid, errorsCell, maxFrame, folderNumber )
%ORGANIZATIONTRACKING This function deals with the centroids that only appear in a single frame, seeing 
%them one by one in the frames that are around. If the centroid coincides with some frame around it, the
%centroid is added by hand and this would be the follow-up of the centroid that is alone.

acum=1;

for numCell=1:size(finalCentroid, 1)
    for numError=1:size(errorsCell,1)
        if finalCentroid{numCell,1}==errorsCell{numError,1}
            errorsCell{numError,2}=finalCentroid{numCell,2};
            errorsCell{numError,3}=finalCentroid{numCell,3};
            coord=finalCentroid{numCell,2};
            frameAnalysis=coord(1,3);
            for photo=1:11
                actualFrame=(frameAnalysis+(photo-6));
                if frameAnalysis>5 && frameAnalysis<(maxFrame-5)
                    FileName{photo,1}=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d', actualFrame) '_c002.tif'];
                    figure
                    imshow(FileName{photo,1})
                    hold on;
                    plot(coord(1,1), coord(1,2), 'b*')
                elseif frameAnalysis<6 && photo>7
                    FileName{photo,1}=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d', actualFrame) '_c002.tif'];
                    figure
                    imshow(FileName{photo,1})
                    hold on;
                    plot(coord(1,1), coord(1,2), 'b*')
                elseif frameAnalysis>(maxFrame-6) && photo<7
                    FileName{photo,1}=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d', actualFrame) '_c002.tif'];
                    figure
                    imshow(FileName{photo,1})
                    hold on;
                    plot(coord(1,1), coord(1,2), 'b*')
                end
            end
            want_eliminate_centroid=input('Do you want to eliminate centroid? 1 (yes) \n 0 (no) \n:');
            switch want_eliminate_centroid
                case 0
                    want_add_frames=input('Do you want to add frames? 1 (yes) \n 0 (no) \n:');
                    switch want_add_frames
                        case 0
                            break
                        case 1
                            errorsCell{numError,4}=0;
                            want_add_more=1;
                            while want_add_more ==1
                                newFrame=input('What frame do you want to add?');
                                errorsCell{numError,5}(acum,1)=newFrame;
                                acum=acum+1;
                                want_add_more=input('Do you want to add more frames?1 (yes) \n 0 (no) \n:');
                            end
                    end
                case 1
                    errorsCell{numError,4}=1;
            end
            acum=1;
            clear FileName
            close all
        end
        
    end
    
end

%The cells of our final variable are deleted.
acum=1;
for newErrors=1:size(errorsCell)
    if errorsCell{newErrors,4}==1
        for numCell=1:size(finalCentroid,1)
            if finalCentroid{numCell,1}~=errorsCell{newErrors,1}
                finalC{acum,1}=finalCentroid{numCell,1};
                finalC{acum,2}= finalCentroid{numCell,2};
                finalC{acum,3}=finalCentroid{numCell,3};
                acum=acum+1;
            end
        end
    end
end


clear finalCentroid
finalCentroid=finalC;
finalCentroid=sortrows(finalCentroid,1);
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));

%Re-label the cells.
for numRep=1:size(vertcat(finalCentroid{:,1}),1)
    finalCentroid{numRep,1} = ic(numRep);
end

end

