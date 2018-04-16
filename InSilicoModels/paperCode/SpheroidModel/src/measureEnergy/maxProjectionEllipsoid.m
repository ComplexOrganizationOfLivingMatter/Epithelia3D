function [ projectionsInner, projectionsOuter,projectionsInnerWater,projectionsOuterWater ] = maxProjectionEllipsoid( ellipsoidInfo,initialEllipsoid)

    
    img3dLayerInner=initialEllipsoid.img3DLayer;
    img3dLayerOuter=ellipsoidInfo.img3DLayer;
    
    centerEllipsoidY=round(initialEllipsoid.yCenter*ellipsoidInfo.resolutionFactor);
    centerEllipsoidZ=round(initialEllipsoid.zCenter*ellipsoidInfo.resolutionFactor);
    
   
    %% Dividing the 3d image in half along the X axis
    
    %first half along Y axis
    halfEllipsoidOuterYfirst=img3dLayerOuter(:,(end-centerEllipsoidY):end,:);
    halfEllipsoidInnerYfirst=img3dLayerInner(:,(end-centerEllipsoidY):end,:);
    halfEllipsoidOuterYfirstPerm=permute(halfEllipsoidOuterYfirst,[1,3,2]);
    halfEllipsoidInnerYfirstPerm=permute(halfEllipsoidInnerYfirst,[1,3,2]);
    orderProjYfirst=size(halfEllipsoidOuterYfirstPerm,3):-1:1;
        
    %second half along Y axis
    halfEllipsoidOuterYsecond=img3dLayerOuter(:,1:(end-centerEllipsoidY),:);
    halfEllipsoidInnerYsecond=img3dLayerInner(:,1:(end-centerEllipsoidY),:);
    halfEllipsoidOuterYsecondPerm=permute(halfEllipsoidOuterYsecond,[1,3,2]);
    halfEllipsoidInnerYsecondPerm=permute(halfEllipsoidInnerYsecond,[1,3,2]);
    %orderProjYsecond=1:centerEllipsoidY;
    orderProjYsecond=1:size(halfEllipsoidInnerYsecondPerm,3);
    
    %first half along Z axis
    halfEllipsoidOuterZfirst=img3dLayerOuter(:,:,(end-centerEllipsoidZ):end);
    halfEllipsoidInnerZfirst=img3dLayerInner(:,:,(end-centerEllipsoidZ):end);
    orderProjZfirst=centerEllipsoidZ:-1:1;

    %second half along Z axis
    halfEllipsoidOuterZsecond=img3dLayerOuter(:,:,1:(end-centerEllipsoidZ));
    halfEllipsoidInnerZsecond=img3dLayerInner(:,:,1:(end-centerEllipsoidZ));
    orderProjZsecond=1:size(halfEllipsoidInnerZsecond,3);
              
   
    %storing half
    orderIt={orderProjYfirst,orderProjYsecond,orderProjZfirst,orderProjZsecond};
    halfEllipsoidsOuter={halfEllipsoidOuterYfirstPerm,halfEllipsoidOuterYsecondPerm,halfEllipsoidOuterZfirst,halfEllipsoidOuterZsecond};
    halfEllipsoidsInner={halfEllipsoidInnerYfirstPerm,halfEllipsoidInnerYsecondPerm,halfEllipsoidInnerZfirst,halfEllipsoidInnerZsecond};
    projectionsOuter=cell(1,4);
    projectionsInner=cell(1,4);
    projectionsOuterWater=cell(1,4);
    projectionsInnerWater=cell(1,4);
    
    
    %create projections
    parfor z=1:4
        maskProjectionOuter=zeros(size(halfEllipsoidsOuter{z}(:,:,1)));
        maskProjectionInner=maskProjectionOuter;
        for i=orderIt{z}
            
            imgMaskOuter=halfEllipsoidsOuter{z}(:,:,i);
            imgMaskInner=halfEllipsoidsInner{z}(:,:,i);
            maskProjectionOuter(maskProjectionOuter==0)=imgMaskOuter(maskProjectionOuter==0);
            maskProjectionInner(maskProjectionInner==0)=imgMaskInner(maskProjectionInner==0);
            
        end
        
        nCellsOuter=unique(maskProjectionOuter);
        nCellsOuter=nCellsOuter(2:end);
        nCellsInner=unique(maskProjectionInner);
        nCellsInner=nCellsInner(2:end);
        se=strel('disk',1);
        acumCellProjectionsOuter=zeros(size(maskProjectionOuter));
        acumCellProjectionsInner=zeros(size(maskProjectionInner));

        for n=1:length(nCellsOuter)
            maskCell=zeros(size(maskProjectionOuter));
            maskCell(maskProjectionOuter==nCellsOuter(n))=nCellsOuter(n);
            maskCell=imerode(maskCell,se);
            acumCellProjectionsOuter(maskCell~=0)=nCellsOuter(n);
        end
        
        for n=1:length(nCellsInner)
            maskCell=zeros(size(maskProjectionInner));
            maskCell(maskProjectionInner==nCellsInner(n))=nCellsInner(n);
            maskCell=imerode(maskCell,se);
            acumCellProjectionsInner(maskCell~=0)=nCellsInner(n);
        end
        
        projectionsOuter{z}=acumCellProjectionsOuter;
        projectionsInner{z}=acumCellProjectionsInner;
        
        projOuterWat=double(watershed(~(acumCellProjectionsOuter>0)));
        projInnerWat=double(watershed(~(acumCellProjectionsInner>0)));
        

        
        %relabeling watershed projections with initial projections labels
        [projOuterWat,projInnerWat]=relabelWatershedImages(acumCellProjectionsOuter,acumCellProjectionsInner,projOuterWat,projInnerWat);
        
        projectionsOuterWater{z}=projOuterWat;
        projectionsInnerWater{z}=projInnerWat;
        
%         figure;imshow(acumCellProjectionsOuter)
%         figure;imshow(acumCellProjectionsInner)
%         figure;imshow(projInnerWat)
%         figure;imshow(projOuterWat)
        
        ['zProjection' num2str(z)]
    end
   
    
end





