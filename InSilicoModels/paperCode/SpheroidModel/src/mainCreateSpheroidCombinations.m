function [] = mainCreateSpheroidCombinations()
    % Create any ellipsoid voronoi. Though, in our article we have created only
    % spheroids. 
    % NOTE: Be aware of the RAM. It is very space consuming.

    % Combinations of spheroids that we have used in the article.
    % X should be the greater number. Z should be the axis with the greater
    % curvature, and the minor radius.
    allCombinations = {
        %Columns are disposed on this order:
        %X radius; Y radius; Z radius; Cell heights; Name of the spheroid;
        %number of Cells
        1.5 1 1 [0.5, 1, 2] 'Balloon' 200
        2 1 1 [0.5, 1, 2] 'Zepellin' 200
        1 1 1 [0.5, 1, 2] 'Sphere' 200
        36-5.369186755	29.59784615-5.369186755 29.59784615-5.369186755	5.369186755 'Stage 4' 200
        97.46-6.145760671 48.32738462-6.145760671 48.32738462-6.145760671 6.145760671 'Stage 8' 450
        };

    maxRandoms = 1:10;

    for numCombination = 1:size(allCombinations, 1)

        fileName = allCombinations{numCombination, 5};
        outputDirGlobal= ['results\' fileName];

        parfor numRandomization = maxRandoms

            radiusX = allCombinations{numCombination, 1};
            radiusY = allCombinations{numCombination, 2};
            radiusZ = allCombinations{numCombination, 3};
            hCell = allCombinations{numCombination, 4};
            numCells = allCombinations{numCombination, 6};

            outputDirActual = [outputDirGlobal '\randomizations\random_', num2str(numRandomization)];
            mkdir(outputDirActual);

            %Make every measure to the unit
            if min([radiusX, radiusY, radiusZ]) ~= 1
                radiusInModelY = 1;
                radiusZ = (radiusZ * radiusInModelY)/radiusY;
                radiusX = (radiusX * radiusInModelY)/radiusY;
                hCell = (hCell * radiusInModelY)/radiusY;
                radiusY = radiusInModelY;
            end

            %Create the voronoi 3D ellipsoid.
            voronoi3DEllipsoid([radiusX+max(hCell)+0.01 radiusY+max(hCell)+0.01 radiusZ+max(hCell)+0.01], [radiusX radiusY radiusZ], numCells, outputDirActual, hCell);

            ['randomization ' num2str(numRandomization) ' - finished']
        end
    end
end

