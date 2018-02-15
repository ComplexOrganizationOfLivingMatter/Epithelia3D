%The variables are loaded
% load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\LayersCentroids2.mat');
% load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingCentroids2.mat');

function [finalCentroid] = correctTracking(finalCentroid, folderNumber, maxFrame)

% fileNameCentroid=['LayersCentroidPrueba' sprintf('%d',folderNumber) '.mat'];
% load(fileNameCentroid);

acum=1;
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));

%The number of times that each cell appears 
for numCell=1:size(C,1)
    for numCent=1:size(ic,1)
        if ic(numCent)==numCell
            numRepCell{numCell,1}=numCell;
            numRepCell{numCell,2}=acum;
            acum=acum+1;
        end
    end
    acum=1;
end

%The cells that appear only once are stored in a variable (errorsCell)
for numCell=1:size(vertcat(numRepCell{:,1}),1)
    if numRepCell{numCell,2}==1
        errorsCell{acum,1}=numRepCell{numCell,1};
        acum=acum+1;
    end
    
end

%It completes the errorsCell variable with the cell label that appears
%only once, the coordinates and the layer where it is located.  
for errorCent=1:size(vertcat(errorsCell{:,1}),1)
    for numCent=1:size(vertcat(finalCentroid{:,1}))
        if errorsCell{errorCent,1}==finalCentroid{numCent,1}
            errorsCell{errorCent,2}=finalCentroid{numCent,2};
            errorsCell{errorCent,3}=finalCentroid{numCent,3};
        end
    end
end


%We already have the matrix with the centroids that only appear in a frame.
%Now what we have to do is take the pictures where they are given, two in 
%front and two back.

coord=vertcat(errorsCell{:,2});
% maxFrame=size(centroids,1);



for errorCent=1:size(vertcat(errorsCell{:,1}),1)
    errorCent

    frameAnalysis=coord(errorCent,3);
    x=coord(errorCent,1);
    y=coord(errorCent,2);
    
    varTracking{errorCent,1}=zeros(11,1);
    
    for photo=1:11 %It analyzes 5 photos less of the frame where the centroid
                    %is with a single frame and 5 more photos of that frame.
        
        
        %New treatment to see the follow up.
        actualFrame=(frameAnalysis+(photo-6));
        FileName{photo,1}=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d', actualFrame) '_c002.tif'];
        
        
        varTracking{errorCent,1}(6,1)=frameAnalysis;
        
        if actualFrame~=frameAnalysis
            if frameAnalysis>5 && frameAnalysis<(maxFrame-5)
                [finalCentroid, varTracking] = newTreatment(FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errorsCell, errorCent, 70);
            elseif frameAnalysis<6 && photo>6  %Si el frame a tratar es menor a 6 se cogen las 5 imágenes posteriores a ese frame.
                [finalCentroid, varTracking] = newTreatment(FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errorsCell, errorCent, 70);
            elseif frameAnalysis>(maxFrame-6) && photo<=(6+(maxFrame-frameAnalysis)) %Si el frame a tratar es mayor a 42 se cogen las 5 imágenes aneriores a ese frame.
                [finalCentroid, varTracking] = newTreatment(FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errorsCell, errorCent, 20);
            end
        end        
        
    end
    

end

acum=1;
for trackingErrors=1:size(varTracking,1)
    for trackingFrames=1:size(varTracking{trackingErrors,1},1)
        if varTracking{trackingErrors,1}(trackingFrames,1)~=0
            errorsFrames{trackingErrors,1}(acum,1)=varTracking{trackingErrors,1}(trackingFrames,1);
            acum=acum+1;
        end
    end
    acum=1;
end


finalCentroid=sortrows(finalCentroid,1); % Se ordena la matriz

%We return to see the array of errors that I have now after doing 
%the new treatment / follow-up.
acum=1;
clear numRepCell C ia ic errorsCell
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));
for numCell=1:size(C,1)
    for numCent=1:size(ic,1)
        if ic(numCent)==numCell
            numRepCell{numCell,1}=numCell;
            numRepCell{numCell,2}=acum;
            acum=acum+1;
        end
    end
    acum=1;
end


for numCell=1:size(vertcat(numRepCell{:,1}),1)
    if numRepCell{numCell,2}==1
        errorsCell{acum,1}=numRepCell{numCell,1};
        acum=acum+1;
    end
    
end

[ finalCentroid ] = organizationTracking( finalCentroid, errorsCell, varTracking, errorsFrames, maxFrame, folderNumber );




%It saves the final variable, which contains the tracking of 
%all cells and deletion of those that are not cells.
%save('trackingLayerPrueba2.mat', 'finalCentroid')


end



