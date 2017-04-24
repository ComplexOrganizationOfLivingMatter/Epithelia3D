function [ ] = gettingInfoFromMotifs( )
%GETTINGINFOFROMMOTIFS Summary of this function goes here
%   Detailed explanation goes here

    selectedPairOfCells = [533, 780;
        557, 463;
        600, 692;
        618, 461;
        666, 714;
        410, 663;
        679, 308;
        636, 497;
        634, 447;
        631, 443;
        439, 338;
        425, 390;
        382, 587;
        584, 409;
        381, 616;
        617, 566;
        652, 358;
        564, 345;
        619, 198;
        299, 293;
        401, 682;
        83, 2;
        361, 209;
        532, 297;
        282, 485];

    selectedInitSections = [28
    28
    35
    39
    35
    33
    34
    30
    30
    24
    40
    38
    28
    27
    28
    31
    48
    48
    48
    46
    88
    58
    110
    71
    30];

    selectedFinalSections = [71
    154
    160
    158
    156
    64
    138
    158
    159
    142
    162
    154
    149
    158
    160
    155
    166
    161
    158
    167
    167
    173
    182
    191
    160];


    % imgToShow = img;
    % imgToShow(ismember(img, unique(selectedPairOfCells)) == 0) = 0;
    % imshow(imgToShow);

    img = labels3d(:, :, 50);
    se = strel('disk', 3);
    selectedCells = zeros(size(selectedPairOfCells, 1), 4);
    infoCells = cell(size(selectedPairOfCells, 1), 5);
    motifSequence = cell(size(selectedPairOfCells, 1), 1);
    for numMotif = 1:size(selectedPairOfCells, 1)
        cell1 = selectedPairOfCells(numMotif, 1);
        cell2 = selectedPairOfCells(numMotif, 2);
        numMotif
        cell1_dilate = imdilate(bwperim(img == cell1), se);
        cell2_dilate = imdilate(bwperim(img == cell2), se);

        neighboursCell1 = unique(img(cell1_dilate));
        neighboursCell2 = unique(img(cell2_dilate));

        neighboursCell1(neighboursCell1 == 0) = [];
        neighboursCell2(neighboursCell2 == 0) = [];
        selectedCells(numMotif, :) = intersect(neighboursCell1, neighboursCell2);

        parfor numCell = 1:4
            regionPropsOfCells = [];
            for zPlane = 1:size(labels3d, 3)
                regionOfCell = struct2table(regionprops(labels3d(:, :, zPlane) == selectedCells(numMotif, numCell), 'all'), 'AsArray', true);
                if size(regionOfCell, 1) == 1 && regionOfCell.Area > 10
                    regionOfCell.zPlane = zPlane;
                    if isempty(regionPropsOfCells)
                        regionPropsOfCells = regionOfCell;
                    else
                        regionPropsOfCells(end+1, :) = regionOfCell;
                    end
                end
            end
            infoCells{numMotif, numCell} = regionPropsOfCells;
        end

        maxPlane = min([max(infoCells{numMotif, 1}.zPlane), max(infoCells{numMotif, 2}.zPlane), max(infoCells{numMotif, 3}.zPlane), max(infoCells{numMotif, 4}.zPlane)]);
        minPlane = max([min(infoCells{numMotif, 1}.zPlane), min(infoCells{numMotif, 2}.zPlane), min(infoCells{numMotif, 3}.zPlane), min(infoCells{numMotif, 4}.zPlane)]);

        outputDir = strcat('results\MotifSegments\motif_', num2str(numMotif));
        mkdir(outputDir);
        outputDirSelectedInitMotifs = strcat('results\selectedInitMotifs');
        mkdir(outputDirSelectedInitMotifs);

        meanAreasBySegment = zeros(maxPlane - minPlane, 1);
        for numPlane = minPlane:maxPlane
            imgPlane = ismember(labels3d(:, :, numPlane), selectedCells(numMotif, :));
            %Cropping image
            [row, col] = find(imgPlane);
            bounding_box = [min(row), min(col), max(row) - min(row) + 1, max(col) - min(col) + 1];

            % display with rectangle
            rect = bounding_box([2,1,4,3]);
            croppedImg = imcrop(imgPlane, rect);
            imwrite(croppedImg, strcat(outputDir, '\segment_', num2str(numPlane), '.png'));

            imgPlaneWithLabels = labels3d(:, :, numPlane);
            if numPlane == selectedInitSections(numMotif)
                croppedImgWithLabels = imcrop(imgPlaneWithLabels .* imgPlane, rect);
                imgReshaped = imfill(croppedImgWithLabels, 8, 'holes');
                switch (numMotif)
                    case 3
                        imgReshaped(28, 18) = 0;
                        imgReshaped(27, 17) = 573;
                    case 8
                        imgReshaped(23, 24) = 331;
                    case 12
                        imgReshaped(32, 20) = 390;
                        imgReshaped(32, 19) = 390;
                        imgReshaped(33, 19) = 390;
                        imgReshaped(34, 19) = 390;
                        imgReshaped(35, 19) = 390;

                        imgReshaped(39, 21) = 390;
                        imgReshaped(38, 20) = 390;
                        imgReshaped(37, 19) = 390;
                        imgReshaped(36, 18) = 390;
                        imgReshaped(36, 19) = 390;
                        imgReshaped(37, 20) = 390;
                        imgReshaped(38, 21) = 390;

                        imgReshaped = imfill(imgReshaped, 8, 'holes');
                    case 17
                        imgReshaped(23, 33) = 260;
                        imgReshaped(22, 33) = 0;
                        imgReshaped(23, 32) = 0;
                        imgReshaped(24, 33) = 260;
                        imgReshaped(23, 35) = 260;
                    case 18
                        imgReshaped(20, 19) = 564;
                        imgReshaped(19, 20) = 564;
                        imgReshaped(19, 21) = 564;
                        imgReshaped(20, 20) = 564;


                        imgReshaped(20, 28) = 564;
                        imgReshaped(20, 29) = 564;
                        imgReshaped(20, 30) = 564;
                        imgReshaped(21, 31) = 564;
                        imgReshaped(22, 32) = 564;
                        imgReshaped(21, 30) = 564;
                        imgReshaped = imfill(imgReshaped, 8, 'holes');

                    case 19
                        imgReshaped(25, 22) = 619;
                        imgReshaped(25, 23) = 619;
                        imgReshaped(26, 23) = 619;
                        imgReshaped(27, 24) = 619;
                        imgReshaped(28, 25) = 619;
                        imgReshaped(27, 23) = 619;
                        imgReshaped(28, 24) = 619;

                        imgReshaped(32, 11) = 619;
                        imgReshaped(31, 12) = 619;
                        imgReshaped(30, 13) = 619;
                        imgReshaped(30, 14) = 619;
                        imgReshaped(31, 13) = 619;
                        imgReshaped(32, 12) = 619;
                        imgReshaped = imfill(imgReshaped, 8, 'holes');
                end
                imwrite(imgReshaped, strcat(outputDirSelectedInitMotifs, '\motif_', num2str(numMotif), '.png'));
                motifSequence{numMotif} = imgReshaped;
            end

            %Getting mean within neighbourhood
            bounding_box = [bounding_box(1) - 4, bounding_box(2) - 4, bounding_box(3) + 4, bounding_box(4) + 4];
            meanAreasBySegment(numPlane) = mean(meanAreaOfCellsInRoi(imgPlaneWithLabels, bounding_box([2,1,4,3])));
            if numPlane == selectedInitSections(numMotif)
                infoCells{numMotif, 6} = meanAreasBySegment(numPlane);
            end

            if numPlane == selectedFinalSections(numMotif)
                infoCells{numMotif, 7} = meanAreasBySegment(numPlane);
            end
        end

        infoCells{numMotif, 5} = meanAreasBySegment;


        if numMotif == 20
            img = labels3d(:, :, 100);
        end
    end

    save('results\motifSequence.mat', 'motifSequence');
    save('results\infoOfSelectedMotifs.mat', 'infoCells', 'selectedCells');

end

