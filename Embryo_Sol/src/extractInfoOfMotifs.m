function [ ] = extractInfoOfMotifs(roiMotifsInit, roiMotifsEnd, embryoDir, suffixFileName )
%EXTRACTINFOOFMOTIFS Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:size(roiMotifsInit, 1)
        actualDir = strcat(embryoDir, '\Motifs\', num2str(i), '\');
        %Printing the roi selected with its beggining and end
        if roiMotifsInit(i, 5) > 0
            mkdir(actualDir);
            labelOfFrameInit = num2str(roiMotifsInit(i, 5));
            if roiMotifsInit(i, 5) < 100
                labelOfFrameInit = strcat('0', labelOfFrameInit);
            end
            img = imread(strcat(embryoDir, '\ImageSequence\', suffixFileName, labelOfFrameInit, '.tif'));
            
            RGB = insertShape(img,'FilledRectangle',roiMotifsInit(i, 1:4),'Color','green');
            imwrite(RGB, strcat(actualDir, 'selectedArea', labelOfFrameInit ,'.tif'));
            
            selectedRoi = roiMotifsInit(i, 1:4);
            imwrite(imcrop(img, selectedRoi), strcat(actualDir, 'end_' ,labelOfFrameInit, '.tif'));
            
            img = imread(strcat(embryoDir, '\ImageSequence\', suffixFileName, '0' ,num2str(roiMotifsEnd(i, 5)), '.tif'));
            selectedRoi = roiMotifsEnd(i, 1:4);
            imwrite(imcrop(img, selectedRoi), strcat(actualDir, 'init_' , '0', num2str(roiMotifsEnd(i, 5)), '.tif'));
            
            %Bounding box of the two bounding boxes
            roiPointsInit = bbox2points(roiMotifsInit(i, 1:4));
            roiPointsEnd = bbox2points(roiMotifsEnd(i, 1:4));
            
            minX = min([roiPointsInit(:, 1); roiPointsEnd(:, 1)]);
            minY = min([roiPointsInit(:, 2); roiPointsEnd(:, 2)]);
            maxX = max([roiPointsInit(:, 1); roiPointsEnd(:, 1)]);
            maxY = max([roiPointsInit(:, 2); roiPointsEnd(:, 2)]);
            %Formula
            bigBoundingBox = [minX minY maxX-minX+1 maxY-minY+1];
            
            %Showing shape correct
            %         RGB = insertShape(img,'FilledRectangle',roiMotifsInit(i, 1:4),'Color','green');
            %         RGB = insertShape(RGB,'FilledRectangle',roiMotifsInit(i, 1:4),'Color','yellow');
            %         RGB = insertShape(RGB,'FilledRectangle',bigBoundingBox,'Color','red');
            %         imshow(RGB)
            
            initFrame = min(roiMotifsEnd(i, 5), roiMotifsInit(i, 5));
            endFrame = max(roiMotifsInit(i, 5), roiMotifsEnd(i, 5));
            %Printing
            for numFrame = initFrame : endFrame
                if numFrame < 100
                   img = imread(strcat(embryoDir, '\ImageSequence\', suffixFileName, '0', num2str(numFrame), '.tif'));
                else
                    img = imread(strcat(embryoDir, '\ImageSequence\', suffixFileName, num2str(numFrame), '.tif'));
                end
                
                imwrite(imcrop(img, bigBoundingBox), strcat(actualDir, num2str(numFrame), '.tif'));
            end
        end
    end

end

