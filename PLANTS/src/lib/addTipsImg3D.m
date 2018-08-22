function img3dWithTips = addTipsImg3D(tipValue,img3d)
    tipXaxis=uint16(zeros(tipValue,size(img3d,2),size(img3d,3)));
    img3dWithTips = cat(1,tipXaxis,img3d);
    img3dWithTips = cat(1,img3dWithTips,tipXaxis);
    tipYaxis=zeros(size(img3dWithTips,1),tipValue,size(img3dWithTips,3));
    img3dWithTips = cat(2,tipYaxis,img3dWithTips);
    img3dWithTips = cat(2,img3dWithTips,tipYaxis);
    tipZaxis=zeros(size(img3dWithTips,1),size(img3dWithTips,2),tipValue);
    img3dWithTips = cat(3,tipZaxis,img3dWithTips);
    img3dWithTips = cat(3,img3dWithTips,tipZaxis);
end

