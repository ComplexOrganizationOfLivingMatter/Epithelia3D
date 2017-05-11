function [ ] = pipelineMid04( labels3d )
%PIPELINEMID04 Summary of this function goes here
%   Detailed explanation goes here
    mkdir('results/mid04/segments');

    labels3d = double(labels3d);

    colors = [colorcube(256); jet(256); parula(256); colorcube(256)];

    for i = 1:size(labels3d, 3)
        img = labels3d(:, :, i);
        %img(img ~= 0) = img(img ~= 0) - min(img(img ~= 0));
        imwrite(img, colors, strcat('results/mid04/segments/segment_', num2str(i), '.jpg')); 
    end
    
     selectedCells = [44	139	68	41
        276	142	159	105
        142	49	105	175
        137	246	288	173
        37	47	41	44
        230	260	382	444
        2	17	9	27
        154	12	62	90
        77	220	141	75
        333	229	81	115
        76	185	79	11
        36	11	126	95
        24	67	335	52
        417	227	110	161];
    
    sectionsOfSelectedCells = [191	97
        208	154
        231	164
        176	76
        183	104
        191	91
        190	102
        172	106
        44	162
        200	140
        200	153
        224	173
        138	89
        99	189
        91	165];
    
    

end

