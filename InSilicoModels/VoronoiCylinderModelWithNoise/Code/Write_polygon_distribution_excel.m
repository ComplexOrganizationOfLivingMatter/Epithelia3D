%%% Write polygon distribution in excel

clear all

n_frames=20; 

noise_ratio={'Inside ratio','Outside ratio','Whole cell'};

m_inside=[];
m_outside=[];
m_whole=[];

for n=1:n_frames
    
   for j=1:size(noise_ratio,2) 
       
       load(['..\Images\Data\Polygon_distribution\' noise_ratio{1,j} '\Pol_distribution_Image_1_Diagram_' num2str(n)],'polygon_distribution')
       p1=polygon_distribution;
       load(['..\Images\Data\Polygon_distribution\' noise_ratio{1,j} '\Pol_distribution_Image_2_Diagram_' num2str(n)],'polygon_distribution')
       p2=polygon_distribution;
       load(['..\Images\Data\Polygon_distribution\' noise_ratio{1,j} '\Pol_distribution_Image_3_Diagram_' num2str(n)],'polygon_distribution')
       p3=polygon_distribution;
       load(['..\Images\Data\Polygon_distribution\' noise_ratio{1,j} '\Pol_distribution_Image_4_Diagram_' num2str(n)],'polygon_distribution')
       p4=polygon_distribution;
       load(['..\Images\Data\Polygon_distribution\' noise_ratio{1,j} '\Pol_distribution_Image_5_Diagram_' num2str(n)],'polygon_distribution')
       p5=polygon_distribution;
       
       average=[mean([p1{2,1},p2{2,1},p3{2,1},p4{2,1},p5{2,1}]),mean([p1{2,2},p2{2,2},p3{2,2},p4{2,2},p5{2,2}]),mean([p1{2,3},p2{2,3},p3{2,3},p4{2,3},p5{2,3}]),mean([p1{2,4},p2{2,4},p3{2,4},p4{2,4},p5{2,4}]),mean([p1{2,5},p2{2,5},p3{2,5},p4{2,5},p5{2,5}]),mean([p1{2,6},p2{2,6},p3{2,6},p4{2,6},p5{2,6}]),mean([p1{2,7},p2{2,7},p3{2,7},p4{2,7},p5{2,7}]),mean([p1{2,8},p2{2,8},p3{2,8},p4{2,8},p5{2,8}])];
       
       %Standard error of the mean
       sem=[std([p1{2,1},p2{2,1},p3{2,1},p4{2,1},p5{2,1}])/sqrt(5),std([p1{2,2},p2{2,2},p3{2,2},p4{2,2},p5{2,2}])/sqrt(5),std([p1{2,3},p2{2,3},p3{2,3},p4{2,3},p5{2,3}])/sqrt(5),std([p1{2,4},p2{2,4},p3{2,4},p4{2,4},p5{2,4}])/sqrt(5),std([p1{2,5},p2{2,5},p3{2,5},p4{2,5},p5{2,5}])/sqrt(5),std([p1{2,6},p2{2,6},p3{2,6},p4{2,6},p5{2,6}])/sqrt(5),std([p1{2,7},p2{2,7},p3{2,7},p4{2,7},p5{2,7}])/sqrt(5),std([p1{2,8},p2{2,8},p3{2,8},p4{2,8},p5{2,8}])/sqrt(5)];

       
       switch noise_ratio{1,j}
           
           case 'Inside ratio'
               m_inside=[m_inside;average,NaN,sem];
           case 'Outside ratio'
               m_outside=[m_outside;average,NaN,sem];
           case 'Whole cell'
               m_whole=[m_whole;average,NaN,sem];
       end
   end
   
end
       names={p1{1,1},p1{1,2},p1{1,3},p1{1,4},p1{1,5},p1{1,6},p1{1,7},p1{1,8}};



%% EXPORT DATA TO EXCEL

xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Inside ratio'}, 1, 'B3');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Frame'}, 1, 'B5');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], [1:20]', 1, 'B6');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], names, 1, 'C5');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], names, 1, 'L5');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], m_inside, 1, 'C6');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Polygon distribution average'}, 1, 'G4');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Standard error of the mean (SEM)'}, 1, 'O4');

xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Outside ratio'}, 1, 'B27');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Frame'}, 1, 'B29');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], [1:20]', 1, 'B30');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], names, 1, 'C29');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], names, 1, 'L29');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], m_outside, 1, 'C30');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Polygon distribution average'}, 1, 'G28');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Standard error of the mean (SEM)'}, 1, 'O28');

xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Whole cell'}, 1, 'B51');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Frame'}, 1, 'B53');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], [1:20]', 1, 'B54');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], names, 1, 'C53');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], names, 1, 'L53');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], m_whole, 1, 'C54');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Polygon distribution average'}, 1, 'G52');
xlswrite(['..\Images\Data\Polygon_distribution\Excel_pd_' date], {'Standard error of the mean (SEM)'}, 1, 'O52');







