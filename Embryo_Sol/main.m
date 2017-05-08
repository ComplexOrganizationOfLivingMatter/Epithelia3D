roiMotifsInit = [9	324	152	158	58
21	412	137	109	57
2	580	144	123	56
858	258	132	109	65
842	218	155	101	65
812	122	122	117	83
254	17	115	111	73
6	332	147	152	59
842	796	120	90	64
0	0	0	0	0
848	148	121	130	70
800	210	109	105	68
836	92	116	135	86
817	402	143	110	62
873	72	137	106	87
65	428	111	120	54
198	796	146	162	65
216	846	130	159	68
49	473	108	123	51];

roiMotifsEnd = [58	322	78	122	35
75	393	79	117	24
24	584	96	111	34
880	250	58	116	30
873	190	76	108	35
842	100	72	112	42
242	0	139	112	50
40	311	98	147	41
842	744	84	122	18
0	0	0	0	0
870	120	55	110	36
853	195	60	127	30
870	54	70	112	43
841	412	71	98	37
898	16	80	105	41
98	425	75	104	22
233	830	89	134	37
245	856	77	134	37
85	449	72	147	28];

embryoDir = 'results\ProcessedImg\OR\Embryo4';

for i = 1:size(roiMotifsInit, 1)
    actualDir = strcat(embryoDir, '\Motifs\', num2str(i), '\');
    mkdir(actualDir);
    %Printing the roi selected with its beggining and end
    if roiMotifsInit(i, 5) > 0
        img = imread(strcat(embryoDir, '\ImageSequence\Embr4_Channel0', num2str(roiMotifsInit(i, 5)), '.tif'));
        selectedRoi = roiMotifsInit(i, 1:4);
        imwrite(imcrop(img, selectedRoi), strcat(actualDir, 'end_' ,num2str(roiMotifsInit(i, 5)), '.tif'));

        img = imread(strcat(embryoDir, '\ImageSequence\Embr4_Channel0', num2str(roiMotifsEnd(i, 5)), '.tif'));
        selectedRoi = roiMotifsEnd(i, 1:4);
        imwrite(imcrop(img, selectedRoi), strcat(actualDir, 'init_' ,num2str(roiMotifsEnd(i, 5)), '.tif'));
        
        %Bounding box of the two bounding boxes
        roiPointsInit = bbox2points(roiMotifsInit(i, 1:4));
        roiPointsEnd = bbox2points(roiMotifsEnd(i, 1:4));
        
        minX = min([roiPointsInit(:, 1); roiPointsEnd(:, 1)]);
        minY = min([roiPointsInit(:, 2); roiPointsEnd(:, 2)]);
        maxX = max([roiPointsInit(:, 1); roiPointsEnd(:, 1)]);
        maxY = max([roiPointsInit(:, 2); roiPointsEnd(:, 2)]);
        %Formula
        bigBoundingBox = [minX minY xMax-xMin+1 maxY-minY+1];
        
        RGB = insertShape(img,'FilledRectangle',roiMotifsEnd(i, 1:4),'Color','green');
        RGB = insertShape(RGB,'FilledRectangle',roiMotifsInit(i, 1:4),'Color','yellow');
        RGB = insertShape(RGB,'FilledRectangle',bigBoundingBox,'Color','red');
        imshow(RGB)
        
        initFrame = min(roiMotifsEnd(i, 5), roiMotifsInit(i, 5));
        endFrame = max(roiMotifsInit(i, 5), roiMotifsEnd(i, 5));
        %Printing
        for numFrame = initFrame : endFrame
            img = imread(strcat(embryoDir, '\ImageSequence\Embr4_Channel0', num2str(numFrame), '.tif'));
            imwrite(imcrop(img, bigBoundingBox), strcat(actualDir, num2str(numFrame), '.tif'));
        end
    end
end

