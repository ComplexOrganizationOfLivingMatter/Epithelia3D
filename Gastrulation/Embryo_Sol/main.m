
addpath('src')

%extractMeasumentWithRoi

%organizeMotifsIntoImgSequence

%pipeline

allFiles = {'D:\Pablo\Epithelia3D\Gastrulation\Embryo_Sol\results\NoFolds\OR_Emb4 BC AP\trackingCells\bottom\trackingInfo_02_11_2017.mat', ...
'D:\Pablo\Epithelia3D\Gastrulation\Embryo_Sol\results\NoFolds\OR_Emb4 BC AP\trackingCells\top\trackingInfo_02_11_2017.mat', ...
'D:\Pablo\Epithelia3D\Gastrulation\Embryo_Sol\results\NoFolds\Scribgfp_Emb2_BC_AP\trackingCells\trackingInfo_01_11_2017.mat', ...
'D:\Pablo\Epithelia3D\Gastrulation\Embryo_Sol\results\NoFolds\Scribgfp_Emb3_gast_AP\trackingCells\trackingInfo_01_11_2017.mat', ...
'D:\Pablo\Epithelia3D\Gastrulation\Embryo_Sol\results\NoFolds\Scribgfp_Emb4_gast_AP\trackingCells\trackingInfo_01_11_2017.mat'};

res = zeros(size(allFiles, 2), 4);
for numFile = 1:size(allFiles, 2)
    load(allFiles{numFile});
    [ res(numFile, :) ] = calculateSurfaceRatioWidthHeight( trackingInfo );
end

