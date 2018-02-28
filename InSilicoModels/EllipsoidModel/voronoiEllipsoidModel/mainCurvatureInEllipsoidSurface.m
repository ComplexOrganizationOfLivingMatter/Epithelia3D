%main curvature analysis for regions studied in energy analysis.

addpath src
addpath(genpath('lib'))

stage={'4','8'};
xRadiusROI = {300,410}; 

for i = 1 : length(stage)
    filePath=['results\Stage ' stage{i}];
        
    nameFile=dir([filePath '\random_1\ellipsoid*']);
    
    load([filePath '\random_1\' nameFile.name],'ellipsoidInfo','initialEllipsoid')
    
    for k=1:2
        if k==1
           ellipsoidMask=ellipsoidInfo;
           resolutionFactor=ellipsoidInfo.resolutionFactor;
        else
            ellipsoidMask=initialEllipsoid;
        end
            
        %getting pixels in surface of ellipsoid
        [x,y,z]=findND(ellipsoidMask.img3DLayer>0);

        xCenterEllipsoid=round(ellipsoidMask.xCenter*resolutionFactor);

        %defining pixels inside chosen ROI for energy
        limitXDown=xCenterEllipsoid-xRadiusROI{i};
        limitXUp=xCenterEllipsoid+xRadiusROI{i};
        roiEnergyCoord=logical((x>limitXDown).*(x<limitXUp));

        xROI=x(roiEnergyCoord);
        yROI=y(roiEnergyCoord);
        zROI=z(roiEnergyCoord);
        
        
%         mask3D=zeros(size(ellipsoidMask.img3DLayer));
%         for m =1:length(xROI)
%             mask3D(xROI(m),yROI(m),zROI(m))=ellipsoidMask.img3DLayer(xROI(m),yROI(m),zROI(m));
%         end
%         
%         figure
%         colours = colorcube(size(initialEllipsoid.cellArea, 1));
%         for numCell = 1:size(ellipsoidMask.cellArea, 1)
%             Xnew=zeros();
%             Ynew=zeros();
%             Znew=zeros();
%             [Xnew, Ynew, Znew] = findND(mask3D == numCell);
%             if sum(sum(sum(Xnew)))>0
%                 cellFigure = alphaShape(Xnew, Ynew, Znew, 500);
%                 plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
%                 hold on;
%             end
%         end
        
        %reallocation of coordinates to the origin (0,0,0)
        x=(xROI/resolutionFactor-ellipsoidMask.xCenter);
        y=(yROI/resolutionFactor-ellipsoidMask.yCenter);
        z=(zROI/resolutionFactor-ellipsoidMask.zCenter);   


        %radii refactoring
        a=ellipsoidMask.xRadius+ellipsoidMask.cellHeight;
        b=ellipsoidMask.yRadius+ellipsoidMask.cellHeight;
        c=ellipsoidMask.zRadius+ellipsoidMask.cellHeight;
        
        %initiallitation of curvature parameters
        R1=zeros(length(x),1);
        R2=zeros(length(x),1);
        k1=zeros(length(x),1);
        k2=zeros(length(x),1);

        parfor j=1:length(x)
            [R1(j),R2(j),k1(j),k2(j)] = testingCurvatureInEllipsoidCoordinate(x(j),y(j),z(j),a,b,c);
        end
        
        R1_mean=mean(R1);        
        R1_std=std(R1);
        R2_mean=mean(R2);
        R2_std=std(R2);
        k1_mean=mean(k1);        
        k1_std=std(k1);
        k2_mean=mean(k2);
        k2_std=std(k2);
    
        if k==1
           save([filePath,'\curvatureOuterEllipsoid.mat'],'R1_mean','R2_mean','R1_std','R2_std','k1_mean','k2_mean','k1_std','k2_std','R1','R2','k1','k2')
        else
           save([filePath,'\curvatureInnerEllipsoid.mat'],'R1_mean','R2_mean','R1_std','R2_std','k1_mean','k2_mean','k1_std','k2_std','R1','R2','k1','k2')
        end
        
    end
end