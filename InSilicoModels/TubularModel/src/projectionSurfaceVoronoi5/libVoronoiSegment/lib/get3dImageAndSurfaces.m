function [img3DApicalSurface,img3DBasalSurface,img3DIntermediateSurface] = get3dImageAndSurfaces(R,H,equalBasalRadius,equalApicalRadius,equalIntermediateRadius,intermediateSurfaceRatios,img3Dfinal)

%get 3d image with correct labels and the asked surfaces: apical, basal and intermediates 

    %%Group pixels of 3d cells and get basal and apical surface
    img3DApicalSurface= zeros(2*R+1,2*R+1,H);
    img3DBasalSurface= zeros(2*R+1,2*R+1,H);
        
    img3DApicalSurface(equalApicalRadius)=img3Dfinal(equalApicalRadius);
    img3DBasalSurface(equalBasalRadius)=img3Dfinal(equalBasalRadius);
    
    %%Capturing intermediate layers sections
    img3DIntermediateSurface=cell(size(equalIntermediateRadius,1),2);
    for numIntermLayer=1:size(equalIntermediateRadius,1)
        %initialize variable
        img2DIntermediateSurface= zeros(2*R+1,2*R+1,H);
        img3DIntermediateSurface{numIntermLayer,1}=intermediateSurfaceRatios(numIntermLayer);
        img2DIntermediateSurface(equalIntermediateRadius{numIntermLayer})=img3Dfinal(equalIntermediateRadius{numIntermLayer});
        img3DIntermediateSurface{numIntermLayer,2}=img2DIntermediateSurface;
    end
    img3DIntermediateSurface=cell2table(img3DIntermediateSurface,'VariableNames',{'surfaceRatio','imageSurfaceLayer'});


end

