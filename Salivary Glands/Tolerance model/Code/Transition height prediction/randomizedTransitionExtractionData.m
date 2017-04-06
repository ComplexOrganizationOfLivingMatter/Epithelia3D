function randomizedTransitionExtractionData(Img,nRandom,listNoiseRatios,indexNoise,heightRealTransition,hCell,curvature,name2save)

    %Calculate neighbors
    [neighs,sidesCells]=calculateNeighbours(Img);
    %get vertices of neighbors cells to calculate the edge distance
    [vertices,~] = getVertices( Img, neighs );
    edgeDist=pdist([vertices{1};vertices{2}]);

    %CalculateEdgeTolerance
    [tolerance] = calculateEdgeTolerance( Img,sidesCells);

    neigh2sides=find(sidesCells==2);
    neigh3sides=find(sidesCells==3);
    
    noTransitionProp=0;
    transitionProp=0;
    angleTransitionCurv=0;
    heightTransitionsNorm=[];
    for i=1:nRandom
    i
        %generate noisy projection
        newImg=getNoisyVoronoiDiagram(Img,listNoiseRatios(indexNoise));

        %analyze tansition
        [neighsNew,sidesCellsNew]=calculateNeighbours(newImg);

        neigh2sidesNew=find(sidesCellsNew==2);
        neigh3sidesNew=find(sidesCellsNew==3);
        
        while length(neigh2sidesNew)~=2 || length(neigh3sidesNew)~=2
            newImg=getNoisyVoronoiDiagram(Img,listNoiseRatios(indexNoise));
            %analyze tansition
            [neighsNew,sidesCellsNew]=calculateNeighbours(newImg);
            neigh2sidesNew=find(sidesCellsNew==2);
            neigh3sidesNew=find(sidesCellsNew==3);
        end
            
        %check if there are transition and his height
        if isequal(sort(neigh2sides),sort(neigh2sidesNew)) && isequal(sort(neigh3sides),sort(neigh3sidesNew))
            noTransitionProp=noTransitionProp+1;
        else
            %get transition edge
            try
                [verticesAux,~] = getVertices( newImg,neighsNew );
                edgeAuxDist=pdist([verticesAux{1};verticesAux{2}]);
                heightTransitionsNorm=[heightTransitionsNorm,edgeDist/(edgeAuxDist+edgeDist)];
            catch exception
                figure;imshow(Img)
                figure;imshow(newImg);
                pause
            end         
            
            transitionProp=transitionProp+1;
        end        
        
        
    end
    
    %transition proportions and average height
    noTransitionProp=noTransitionProp/nRandom;
    transitionProp=transitionProp/nRandom;
    meanHeightTransitionNorm=mean(heightTransitionsNorm);
    stdHeightTransitionNorm=std(heightTransitionsNorm);
    meanHeightTransitionPredict=meanHeightTransitionNorm*hCell;
    stdHeightTransitionPredict=stdHeightTransitionNorm*hCell;
    
    
    
    %percentage of breakage
    if listNoiseRatios(indexNoise) > tolerance
        brokenTolerance='true';
        breakagePercTolerance=['x' num2str(listNoiseRatios(indexNoise)/tolerance)  ' higher than tolerance'];
    else
        breakagePercTolerance=num2str(0);
        brokenTolerance='false';
    end
    
    
    %calculate angles
    angleCurv=atand(listNoiseRatios(indexNoise)/hCell);
    angleWithoutCur=angleCurv/curvature;   
    
    
    %Save 
    if isdir(name2save)==0
        mkdir(name2save)
    end
    save([name2save '\Data_noise_ratio_' num2str(listNoiseRatios(indexNoise)) '_nRandom_' num2str(nRandom) '.mat'],'noTransitionProp','transitionProp','meanHeightTransitionNorm','stdHeightTransitionNorm','meanHeightTransitionPredict','stdHeightTransitionPredict','brokenTolerance','breakagePercTolerance','tolerance','angleCurv','angleWithoutCur','heightRealTransition')

    
end 