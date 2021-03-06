function [finalCentroidTracking] = finalTracking( finalCentroid, initialFrame, maxFrame, folderNumber)
%FINALTRACKING Check if there are two centroids in the same nuclei and in 
%the same frame, and if so, remove the one in the outermost layer.

%It creates variables with part of the name of the image with the nuclei and the way to find it in this computer.
name=['50epib_' sprintf('%d',folderNumber) '_z'];
photo_Path=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber)];

coord=vertcat(finalCentroid{:,2});
acum=1;

%This loop goes frame by frame checking if there are two centroids in the same set of pixels (nuclei)
for numFrame=initialFrame:maxFrame
    
    %The corresponding frame image is read
    channel2Name{numFrame}= [name sprintf('%03d',numFrame) '_c002.tif'];
    channel2PhotoPath{numFrame}=[photo_Path '\' channel2Name{numFrame}];
    
    %The 'Centroid' function is called to return the centoids in the image, the pixels and 
    %an image with the pixels represented. Then, it gets the list of pixels divided by nuclei
    %that is in that frame
    [centroidsC, pixel, maskBW] = Centroid(channel2PhotoPath{numFrame},name );
    pixelesFrame=regionprops(maskBW, 'PixelList');
    
    n=1;
    %The number of centroids that match each nucleus is counted
    for numPixel=1:size(pixelesFrame,1)
        for numCentroid=1:size(coord,1)
            if vertcat(coord(numCentroid,3))== numFrame
                [cen, ind]=ismember(round(coord(numCentroid,1:2)), vertcat(pixelesFrame(numPixel).PixelList),'rows');
                if cen==1 && isempty (finalCentroid{numCentroid,1})==0
                    var{numPixel,1}=n;
                    var{numPixel,2}(n,1)=finalCentroid{numCentroid,1};
                    var{numPixel,2}(n,2)=numCentroid;
                    var{numPixel,3}(n,1)=finalCentroid{numCentroid,3};
                    n=n+1;
                end
            end
        end
        
        %If in that nucleus more than one centroid appears, then it is eliminated from the cell
        %tracking variable ('finalCentroid'). It gets bigger than 2 because the variable 'n' is  
        %added +1 after finding a centroid in a nucleus in the previous loop, so if it finds 2, 
        %the variable 'n' would be worth 3.
        if n>2 
            [M,I]=min(var{numPixel,3});
            index=var{numPixel,2}(I,2);
            for tracking=index:size(finalCentroid,1)
                if finalCentroid{tracking,1} == var{numPixel,2}(I,1)
                    finalCentroid{tracking,1}=[];
                    finalCentroid{tracking,2}=[];
                    finalCentroid{tracking,3}=[];
                end
            end
        end
        
        n=1;
        
    end
    clear var
end

%Sort the variable 'finalCentroid'
for numTrack=1:size(finalCentroid,1)
    if isempty (finalCentroid{numTrack,1})==0
        finalCentroidTracking{acum,1}=finalCentroid{numTrack,1};
        finalCentroidTracking{acum,2}=finalCentroid{numTrack,2};
        finalCentroidTracking{acum,3}=finalCentroid{numTrack,3};
        acum=acum+1;
    end
end

end
