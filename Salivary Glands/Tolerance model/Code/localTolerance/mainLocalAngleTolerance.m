function [angle,angleCurv,tolerance]=mainLocalAngleTolerance(pathStructure,frame,cell1,cell2,cell3,cell4,hTransition,transition,curvature)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    addpath lib
    angle=0;angleCurv=0;angleNoTran=0;angleNoTranCurv=0;
    
    %Load label image
    load(pathStructure)
    
    if frame=='end'
        Img=Seq_Img_L{end};
    else
        Img=Seq_Img_L{frame};
    end
    
    [tolerance] = calculateEdgeTolerance(Img,cell1,cell2,cell3,cell4);
    
    if transition==0
        
    else
        angle=atand(tolerance/hTransition);
        angleCurv=angle*curvature;
    end


end

