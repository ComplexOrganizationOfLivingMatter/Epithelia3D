function checkRealScutoidsPresence(pathFolder)

    load([pathFolder '\resultMeasurements\layer1ResultsMeasurementCells.mat'],'tableScutoids')
    tableScu1 = tableScutoids;
    load([pathFolder '\resultMeasurements\layer2ResultsMeasurementCells.mat'],'tableScutoids')
    tableScu2 = tableScutoids;
    nameImg = dir([pathFolder '\image3d*.mat']);
    load([pathFolder '\' nameImg(1).name],'img3d');
    img3dResized = imresize3(img3d,0.2,'nearest');
    if  iscell(tableScu1.scutoidCells) && ~iscell(tableScu2.scutoidCells)
        scutoidsTag = tableScu1.scutoidCells{1};
    end
    if  ~iscell(tableScu1.scutoidCells) && iscell(tableScu2.scutoidCells)
        scutoidsTag = tableScu2.scutoidCells{1};
    end
    
    if  iscell(tableScu1.scutoidCells) && iscell(tableScu2.scutoidCells)
        if size(tableScu1.scutoidCells{1},1) > size(tableScu1.scutoidCells{1},2)
            scutoidsTag = [tableScu1.scutoidCells{1};tableScu2.scutoidCells{1}];
        else
            scutoidsTag = [tableScu1.scutoidCells{1},tableScu2.scutoidCells{1}];
        end
    end
    if  iscell(tableScu1.scutoidCells) || iscell(tableScu2.scutoidCells)
        colorCells = jet(length(scutoidsTag));
        figure;
        hold on
        for i = 1 : length(scutoidsTag)
            [x, y, z] = ind2sub(size(img3dResized),find(img3dResized==scutoidsTag(i)));
            shp = alphaShape([x, y, z]);
            plot(shp,'FaceColor',colorCells(i,:),'EdgeColor','none')
        end
        hold off
    else
       disp('No scutoids')
    end
    
end

