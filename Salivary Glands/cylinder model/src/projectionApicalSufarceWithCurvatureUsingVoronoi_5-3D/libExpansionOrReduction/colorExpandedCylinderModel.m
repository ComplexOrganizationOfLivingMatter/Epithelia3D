
interval1=1;
interval2=512;
steps=[1,3,6,9];
numSeeds=100;
% order1=randperm(50,50);
% order2=randperm(50,50);
order3=randperm(numSeeds,numSeeds);
M=jet(numSeeds);

% cOrder1=M(order1,:);
% cOrder2=M(order2,:);
cOrder3=M(order3,:);
cOrder3=[0 0 0;cOrder3];

load(['D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\expansion\512x1024_' num2str(numSeeds) 'seeds\Image_10_Diagram_5\Image_10_Diagram_5.mat'],'listLOriginalProjection')
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
    path2save=(['D:\Pedro\Epithelia3D\docs\cylinderModel\expansion\' num2str(numSeeds) ' seeds\' num2str(numSeeds) 'cellsExpanded\']);
    if ~exist(path2save,'dir')
        mkdir(path2save)
    end
    print('-f1', '-r300','-dpdf',[path2save num2str(surfaceRatio) '_' num2str(numSeeds) ' cells.pdf'])
    print('-f1', '-r300','-dtiff',[path2save num2str(surfaceRatio) '_' num2str(numSeeds) ' cells.tiff'])
    
    %close all
    
end

         