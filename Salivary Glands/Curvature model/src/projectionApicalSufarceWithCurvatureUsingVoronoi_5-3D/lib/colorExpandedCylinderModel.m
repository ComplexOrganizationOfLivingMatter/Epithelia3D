
interval1=1;
interval2=512;
steps=[1,3,6,9];
% order1=randperm(50,50);
% order2=randperm(50,50);
% order3=randperm(50,50);
M=jet(50);
% cOrder1=M(order1,:);
% cOrder2=M(order2,:);
cOrder3=M(order3,:);
for i=1:length(steps)

    Img=cell2mat(listLOriginalProjection.L_originalProjection(steps(i)));
    
    surfaceRatio=listLOriginalProjection.surfaceRatio(steps(i));
    %figure('Visible','off')
    i
    mask=zeros(1024,2560);
    mask(Img>0)=Img(Img>0);
    
    imshow(mask,cOrder3)
    
%     imshow(Img(:,round(interval1*surfaceRatio):round(interval2*surfaceRatio)),colorcube (50))
%     hold on
    print('-f1', '-r300','-dpdf',['D:\Pedro\Epithelia3D\docs\cylinderModel\expansion\50cellsExpanded\' num2str(surfaceRatio) '.pdf'])
    print('-f1', '-r300','-dtiff',['D:\Pedro\Epithelia3D\docs\cylinderModel\expansion\50cellsExpanded\' num2str(surfaceRatio) '.tiff'])
    
    %close all
    
end

         