%The variables are loaded
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\LayersCentroids2.mat');
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingCentroids2.mat');

folderNumber=2;

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
maxFrame=size(centroids,1);

for errorCent=1:size(vertcat(errorsCell{:,1}),1)
    errorCent
    varTracking=cell(11,1);
    frameAnalysis=coord(errorCent,3);
    x=coord(errorCent,1);
    y=coord(errorCent,2);
    
    
    for photo=1:11 %It analyzes 5 photos less of the frame where the centroid
                    %is with a single frame and 5 more photos of that frame.
        
        
        %New treatment to see the follow up.
        actualFrame=(frameAnalysis+(photo-6));
        FileName{photo,1}=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d', actualFrame) '_c002.tif'];
        
        if actualFrame~=frameAnalysis
            if frameAnalysis>5 && frameAnalysis<(maxFrame-5)
                [finalCentroid, varTracking] = newTreatment(FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errorsCell, errorCent);
            elseif frameAnalysis<6 && photo>6  %Si el frame a tratar es menor a 6 se cogen las 5 imágenes posteriores a ese frame.
                [finalCentroid, varTracking] = newTreatment(FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errorsCell, errorCent);
            elseif frameAnalysis>(maxFrame-6) && photo<6 %Si el frame a tratar es mayor a 42 se cogen las 5 imágenes posteriores a ese frame.
                [finalCentroid, varTracking] = newTreatment(FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errorsCell, errorCent);
            end
        end
        
        
        %Representation of the centroid that is only in one frame. It is 
        %represented in both the new treated image and the original image 
        %in question.
        
        %         figure
        %         imshow(maskBW)
        %         hold on;
        %         plot(coord(errorCent,1), coord(errorCent,2), 'b*')
        %
        %         figure
        %         imshow(FileName{photo,1})
        %         hold on;
        %         plot(coord(errorCent,1), coord(errorCent,2), 'b*')
        
        
    end
    
    %Create a variable that contains all the frames that have been added 
    %for that cell. This will then be used to check if they are frames in
    %a row or not.
    acum=1;
    varTracking{6,1}=frameAnalysis; %The frame being analyzed at position 6 
                                    %is added to the tracking variable, since 
                                    %that is the position of the image where 
                                    %the centroid is initially located.
    for trackingFrame=1:size(varTracking,1)
        if isempty(varTracking{trackingFrame,1})==0
            variables(acum,1)=varTracking{trackingFrame,1}(1,1);
            acum=acum+1;
        end
    end
    
    %To eliminate the centroids that have just been inserted if they are
    %not followed, since they will not be a nucleus of a cell.
    acum=1;
    for framesTrack=1:size(variables(:,1),1)-1  %It is deleted because the frames that have been detected are not followed.
        if (variables(framesTrack,1)+1 ~= variables(framesTrack+1,1))
            for numCen=1:size(finalCentroid,1)
                if finalCentroid{numCen,1}(1,1)~=errorsCell{errorCent,1}
                    finalC{acum,1}=finalCentroid{numCen,1};
                    finalC{acum,2}= finalCentroid{numCen,2};
                    finalC{acum,3}=finalCentroid{numCen,3};
                    acum=acum+1;
                end
            end
        end
    end
    if size(variables(:,1),1)==1 %It is eliminated because it only has one centroid after the treatment.
        for numCen=1:size(finalCentroid,1)
            if finalCentroid{numCen,1}(1,1)~=errorsCell{errorCent,1}
                finalC{acum,1}=finalCentroid{numCen,1};
                finalC{acum,2}= finalCentroid{numCen,2};
                finalC{acum,3}=finalCentroid{numCen,3};
                acum=acum+1;
            end
        end
    end
    
    
   finalCexist = exist ('finalC', 'var');
    if finalCexist==1
        clear finalCentroid 
        finalCentroid=finalC;
        clear finalC
    end
   
    clear variables varTracking
end

finalCentroid=sortrows(finalCentroid,1); % Se ordena la matriz
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));

%Re-label cells to correctly recalculate cells that only appear once.
for numRep=1:size(vertcat(finalCentroid{:,1}),1)
    finalCentroid{numRep,1} = ic(numRep);
end


%HACE FALTA????

%We return to see the array of errors that I have now after doing 
%the new treatment / follow-up.
% acum=1;
% clear numRepCell
% for numCell=1:size(C,1)
%     for numCent=1:size(ic,1)
%         if ic(numCent)==numCell
%             numRepCell{numCell,1}=numCell;
%             numRepCell{numCell,2}=acum;
%             acum=acum+1;
%         end
%     end
%     acum=1;
% end
% 
% for numCell=1:size(vertcat(numRepCell{:,1}),1)
%     if numRepCell{numCell,2}==1
%         errorsCell{acum,1}=numRepCell{numCell,1};
%         acum=acum+1;
%     end
%     
% end
% 
% 
% %To remove cells that have only a single frame. 
% acum=1;
% for errorCent=1:size(vertcat(errorsCell{:,1}),1)
%     for numCent=1:size(vertcat(finalCentroid{:,1}),1)
%         if finalCentroid{numCent,1}(1,1)~=errorsCell{errorCent,1}(1,1)
%             cleanCentroid{acum,1}=finalCentroid{numCent,1};
%             cleanCentroid{acum,2}= finalCentroid{numCent,2};
%             cleanCentroid{acum,3}=finalCentroid{numCent,3};
%             acum=acum+1;
%         end
%     end
% end
% 
% finalCentroid=sortrows(cleanCentroid,1);
% [C,ia,ic] = unique(vertcat(cleanCentroid{:,1}));
% 
% %Re-label the cells, since now some of them no longer exist.
% for numRep=1:size(vertcat(finalCentroid{:,1}),1)
%     finalCentroid{numRep,1} = ic(numRep);
% end

%It saves the final variable, which contains the tracking of 
%all cells and deletion of those that are not cells.
save('trackingPrueba', 'finalCentroid')






