load('D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\512x1024_400seeds\summaryAverageTransitions.mat')

figure;
for i=length(acumAngles)-1:-1:1
    
    colorTransition = [i*20,153,i*20]/255;

    scatter3(acumAngles{i},acumEdgesTransition{i}, (1-i*0.1)*ones(length(acumEdgesTransition{i}),1),36,colorTransition,'filled');
    xlabel('edge angle (degrees)');
    ylabel('edge length (micrometers)');
    zlabel('apical surface reduction');
    hold on
end


figure
scatter(acumAngles{2},acumEdgesTransition{2},36,colorTransition,'filled')
xlabel('edge angle (degrees)');
ylabel('edge length (micrometers)');