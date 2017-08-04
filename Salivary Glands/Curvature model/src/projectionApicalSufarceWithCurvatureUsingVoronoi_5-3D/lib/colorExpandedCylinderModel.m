
interval1=200;
interval2=302;
for i=1:size(listLOriginalProjection,1)

    Img=cell2mat(listLOriginalProjection.L_originalProjection(i));
    surfaceRatio=listLOriginalProjection.surfaceRatio(i);
    figure
    i
    imshow(Img(:,round(interval1*surfaceRatio):round(interval2*surfaceRatio)),colorcube (400))
    
    print('-f1', '-r300','-dpdf',[ num2str(surfaceRatio) '.pdf'])
   
    
end

         