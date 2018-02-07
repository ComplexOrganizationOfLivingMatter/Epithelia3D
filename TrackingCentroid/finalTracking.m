function [finalCentroid] = finalTracking( finalCentroid, initialFrame, maxFrame, folderNumber)

%%Variables
%It creates variables with part of the name of the image with the nuclei and the way to find it in this computer.
name=['50epib_' sprintf('%d',folderNumber) '_z'];
photo_Path=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber)];

coord=vertcat(finalCentroid{:,2});
acum=1;

for numFrame=initialFrame:maxFrame

    channel2Name{numFrame}= [name sprintf('%03d',numFrame) '_c002.tif'];
    channel2PhotoPath{numFrame}=[photo_Path '\' channel2Name{numFrame}];
    
    [centroidsC, pixel, maskBW] = Centroid(channel2PhotoPath{numFrame},name );
    pixelesFrame=regionprops(maskBW, 'PixelList');
    
    n=1;
    
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
        if n>2 %Estaba a n==3 pero puede que haya más de dos píxeles en un mismo núcleo (?), así prevengo.
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

%Sort finalCentroid
for numTrack=1:size(finalCentroid,1)
    if isempty (finalCentroid{numTrack,:})==0
        finalCentroids{acum,1}=finalCentroid{numTrack,1};
        finalCentroids{acum,2}=finalCentroid{numTrack,2};
        finalCentroids{acum,3}=finalCentroid{numTrack,3};
        acum=acum+1;
    end
end

end
