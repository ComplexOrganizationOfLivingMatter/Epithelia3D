function [totalCellsInRois,totalProportionScutoids,totalProportionWinNeigh,...
                totalProportionLossNeigh,totalProportionOfCellsInNoTransitions,...
                distributionWinningNeigh,distributionLossingNeigh,...
                distributionTransitionsPerCell,proportionAnglesTransition,...
                proportionAnglesNoTransition,totalAnglesTransition,...
                totalAnglesNoTransition,totalLengthTransition,totalLengthNoTransition] ...
                ...
                = calculationAngleLengthScutoidsInEdges(filePath,nRand,cellHeight,nCellHeight)

            ellipsoidPath=dir([filePath 'randomizations\random_' num2str(nRand) '\*llipsoid*' ]);
            splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
            splittedCellHeight=splittedPath{end};
            if nCellHeight>1
                load([filePath 'randomizations\random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
            else
                load([filePath 'randomizations\random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
            end
            %loading mask central cells in projection
            maskRoiInner=imread([filePath 'maskInner.tif']);
            maskRoiInner=1-im2bw(maskRoiInner(:,:,1));
            neighsInner=cell(length(projectionsInnerWater),1);
            noValidCells=cell(length(projectionsInnerWater),1);
            neighsOuter=cell(length(projectionsInnerWater),1);
            validCells=cell(length(projectionsInnerWater),1);
            projectionsOuter=cell(length(projectionsInnerWater),1);
            nCells=zeros(length(projectionsInnerWater),1);
            for i=1:length(projectionsInnerWater)                
                [~,projectionsOuter{i},neighsOuter{i},neighsInner{i},noValidCells{i},validCells{i},~,~]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});
                nCells(i)=size(neighsOuter{i},2);               
            end
            cellNeighsOuter=cell(4,max(nCells));
            cellNeighsInner=cell(4,max(nCells));
            for i=1:length(projectionsInnerWater)  
                cellNeighsOuter(i,1:size(neighsOuter{i},2))=neighsOuter{i};
                cellNeighsInner(i,1:size(neighsInner{i},2))=neighsInner{i};
            end
            globalValidCells=unique(horzcat(validCells{:}));
            totalCellsInRois=length(globalValidCells);
            globalNeighsOuter=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsOuter(1,:),cellNeighsOuter(2,:),cellNeighsOuter(3,:),cellNeighsOuter(4,:),'UniformOutput',false);
            globalNeighsInner=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsInner(1,:),cellNeighsInner(2,:),cellNeighsInner(3,:),cellNeighsInner(4,:),'UniformOutput',false);
            
            %calculate proportions of scutoids
            [totalProportionScutoids,totalProportionWinNeigh,totalProportionLossNeigh,totalProportionOfCellsInNoTransitions,...
                distributionWinningNeigh,distributionLossingNeigh,distributionTransitionsPerCell]...
                =calculateNumberOfCellsInvolvedInTransitions(globalNeighsInner,globalNeighsOuter,globalValidCells);
              
            %get all the projections together
            outerOverlaped=horzcat([projectionsOuter{:}]);
            
            %measured angles and length discriminating between transition
            %and no transition
            [dataTransition,dataNoTransition]=measureAnglesAndLengthOfEdges(outerOverlaped,globalNeighsInner,globalNeighsOuter,globalValidCells);
            
            proportionAnglesTransition=[dataTransition.proportionAnglesLess15deg,dataTransition.proportionAnglesBetween15_30deg,dataTransition.proportionAnglesBetween30_45deg,dataTransition.proportionAnglesBetween45_60deg,dataTransition.proportionAnglesBetween60_75deg,dataTransition.proportionAnglesBetween75_90deg];
            proportionAnglesNoTransition=[dataNoTransition.proportionAnglesLess15deg,dataNoTransition.proportionAnglesBetween15_30deg,dataNoTransition.proportionAnglesBetween30_45deg,dataNoTransition.proportionAnglesBetween45_60deg,dataNoTransition.proportionAnglesBetween60_75deg,dataNoTransition.proportionAnglesBetween75_90deg];
            totalAnglesTransition=dataTransition.edgeAngle;
            totalAnglesNoTransition=dataNoTransition.edgeAngle;
            totalLengthTransition=dataTransition.edgeLength;
            totalLengthNoTransition=dataNoTransition.edgeLength;
            
            disp([filePath ' cell height ' num2str(cellHeight) '/' num2str(nCellHeight) ' random ' num2str(nRand)])

end