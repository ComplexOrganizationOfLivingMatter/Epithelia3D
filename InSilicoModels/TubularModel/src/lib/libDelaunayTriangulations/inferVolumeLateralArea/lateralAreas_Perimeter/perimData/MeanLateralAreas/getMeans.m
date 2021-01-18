function [totalMeansMean,totalStdsMean,totalMeansStd,totalStdsStd] = getMeans

    vor1 = table2array(readtable('LateralAreas_Voronoi_1.xls'));
    vor2 = table2array(readtable('LateralAreas_Voronoi_2.xls'));
    vor3 = table2array(readtable('LateralAreas_Voronoi_3.xls'));
    vor4 = table2array(readtable('LateralAreas_Voronoi_4.xls'));
    vor5 = table2array(readtable('LateralAreas_Voronoi_5.xls'));
    vor6 = table2array(readtable('LateralAreas_Voronoi_6.xls'));
    vor7 = table2array(readtable('LateralAreas_Voronoi_7.xls'));
    vor8 = table2array(readtable('LateralAreas_Voronoi_8.xls'));
    vor9 = table2array(readtable('LateralAreas_Voronoi_9.xls'));
    vor10 = table2array(readtable('LateralAreas_Voronoi_10.xls'));

    meanVor1 = vor1(1:2:end,:);
    meanVor2 = vor2(1:2:end,:);
    meanVor3 = vor3(1:2:end,:);
    meanVor4 = vor4(1:2:end,:);
    meanVor5 = vor5(1:2:end,:);
    meanVor6 = vor6(1:2:end,:);
    meanVor7 = vor7(1:2:end,:);
    meanVor8 = vor8(1:2:end,:);
    meanVor9 = vor9(1:2:end,:);
    meanVor10 = vor10(1:2:end,:);

    meanmeanVor1 = mean(meanVor1);
    meanmeanVor2 = mean(meanVor2);
    meanmeanVor3 = mean(meanVor3);
    meanmeanVor4 = mean(meanVor4);
    meanmeanVor5 = mean(meanVor5);
    meanmeanVor6 = mean(meanVor6);
    meanmeanVor7 = mean(meanVor7);
    meanmeanVor8 = mean(meanVor8);
    meanmeanVor9 = mean(meanVor9);
    meanmeanVor10 = mean(meanVor10);

    stdmeanVor1 = std(meanVor1);
    stdmeanVor2 = std(meanVor2);
    stdmeanVor3 = std(meanVor3);
    stdmeanVor4 = std(meanVor4);
    stdmeanVor5 = std(meanVor5);
    stdmeanVor6 = std(meanVor6);
    stdmeanVor7 = std(meanVor7);
    stdmeanVor8 = std(meanVor8);
    stdmeanVor9 = std(meanVor9);
    stdmeanVor10 = std(meanVor10);

    totalMeansMean = [meanmeanVor1;meanmeanVor2;meanmeanVor3;meanmeanVor4;meanmeanVor5;meanmeanVor6;meanmeanVor7;meanmeanVor8;meanmeanVor9;meanmeanVor10];
    totalStdsMean = [stdmeanVor1;stdmeanVor2;stdmeanVor3;stdmeanVor4;stdmeanVor5;stdmeanVor6;stdmeanVor7;stdmeanVor8;stdmeanVor9;stdmeanVor10];

    stdVor1 = vor1(2:2:end,:);
    stdVor2 = vor2(2:2:end,:);
    stdVor3 = vor3(2:2:end,:);
    stdVor4 = vor4(2:2:end,:);
    stdVor5 = vor5(2:2:end,:);
    stdVor6 = vor6(2:2:end,:);
    stdVor7 = vor7(2:2:end,:);
    stdVor8 = vor8(2:2:end,:);
    stdVor9 = vor9(2:2:end,:);
    stdVor10 = vor10(2:2:end,:);

    meanstdVor1 = mean(stdVor1);
    meanstdVor2 = mean(stdVor2);
    meanstdVor3 = mean(stdVor3);
    meanstdVor4 = mean(stdVor4);
    meanstdVor5 = mean(stdVor5);
    meanstdVor6 = mean(stdVor6);
    meanstdVor7 = mean(stdVor7);
    meanstdVor8 = mean(stdVor8);
    meanstdVor9 = mean(stdVor9);
    meanstdVor10 = mean(stdVor10);

    stdstdVor1 = std(stdVor1);
    stdstdVor2 = std(stdVor2);
    stdstdVor3 = std(stdVor3);
    stdstdVor4 = std(stdVor4);
    stdstdVor5 = std(stdVor5);
    stdstdVor6 = std(stdVor6);
    stdstdVor7 = std(stdVor7);
    stdstdVor8 = std(stdVor8);
    stdstdVor9 = std(stdVor9);
    stdstdVor10 = std(stdVor10);

    totalMeansStd = [meanstdVor1;meanstdVor2;meanstdVor3;meanstdVor4;meanstdVor5;meanstdVor6;meanstdVor7;meanstdVor8;meanstdVor9;meanstdVor10];
    totalStdsStd = [stdstdVor1;stdstdVor2;stdstdVor3;stdstdVor4;stdstdVor5;stdstdVor6;stdstdVor7;stdstdVor8;stdstdVor9;stdstdVor10];
