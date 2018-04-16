%main curvature analysis for regions studied in energy analysis.

filePaths={'Stage 4','Stage 8','Globe','Rugby','Sphere'};
xRadiusROI = 2/3;

for i = 1 : length(filePaths)
    filePath=['results\' filePaths{i}];
    
    nameFile=dir([filePath '\random_1\ellipsoid*']);
    
    for nHeight = 1 : length(nameFile)
        
        load([filePath '\random_1\' nameFile(nHeight).name],'ellipsoidInfo','initialEllipsoid')
        
        splittedPath=strsplit(nameFile(nHeight).name,'_');
        splittedCellHeight=splittedPath{end};
        
        for k=1:2
            if k==1
                ellipsoidMask=ellipsoidInfo;
                resolutionFactor=ellipsoidInfo.resolutionFactor;
            else
                if nHeight==1
                    ellipsoidMask=initialEllipsoid;
                else
                    continue
                end
            end
            
            %defining cell height depending if ellipsoids are oldest (radius is the apical radius) or
            %newest (cellHeight into the radius)
            if length(nameFile)>1
                cellHeight=0;
            else
                cellHeight=ellipsoidMask.cellHeight;
            end
            
            %defining pixels inside chosen ROI for energy
            limitXRoi=xRadiusROI*(ellipsoidMask.xRadius+cellHeight);
            
            
            a=ellipsoidMask.xRadius+cellHeight;
            b=ellipsoidMask.yRadius+cellHeight;
            c=ellipsoidMask.zRadius+cellHeight;
            
            %Create ellipsoid coordinates
            [xEllip,yEllip,zEllip] = ellipsoid(0,0,0,a,b,c,200);
            xyzEllipsoid=[xEllip(:),yEllip(:),zEllip(:)];
            roiEnergyCoord=logical((xyzEllipsoid(:,1)>(-limitXRoi)).*(xyzEllipsoid(:,1)<limitXRoi));
            xyzEllipsoid=xyzEllipsoid(roiEnergyCoord,:);
            
            %initiallitation of curvature parameters
            R1=zeros(size(xyzEllipsoid,1),1);
            R2=zeros(size(xyzEllipsoid,1),1);
            k1=zeros(size(xyzEllipsoid,1),1);
            k2=zeros(size(xyzEllipsoid,1),1);
            
            %testing curvatures
            parfor j=1:size(xyzEllipsoid,1)
                [R1(j),R2(j),k1(j),k2(j)] = testingCurvatureInEllipsoidCoordinate(xyzEllipsoid(j,1),xyzEllipsoid(j,2), xyzEllipsoid(j,3),a,b,c);
                
            end
            
            R1=R1(~isnan(R1));
            R2=R2(~isnan(R2));
            
            R1_mean=mean(R1);
            R1_std=std(R1);
            R2_mean=mean(R2);
            R2_std=std(R2);
            k1_mean=mean(k1);
            k1_std=std(k1);
            k2_mean=mean(k2);
            k2_std=std(k2);
            
            if k==1
                save([filePath,'\curvatureOuterEllipsoid_' splittedCellHeight(1:end-4) '_'  date '.mat' ],'R1_mean','R2_mean','R1_std','R2_std','k1_mean','k2_mean','k1_std','k2_std','R1','R2','k1','k2')
            else
                if nHeight==1
                    save([filePath,'\curvatureInnerEllipsoid_' date '_.mat'],'R1_mean','R2_mean','R1_std','R2_std','k1_mean','k2_mean','k1_std','k2_std','R1','R2','k1','k2')
                end
            end
            
        end
    end
end