function h = paint3DVoronoiTubes(path2save,nCells,colors)

  nameMat= dir([path2save '*.mat']);
  
  y=load([path2save nameMat.name],'cell_1');
  cellX = y.('cell_1');
  mask3D = zeros(size(cellX.region));
  
  for nCel = 1 : nCells
        y=load([path2save nameMat.name],['cell_' num2str(nCel)]);
        cellX = y.(['cell_' num2str(nCel)]);
        mask3D(cellX.region > 0 ) = nCel;
  end
  h=figure;
  paint3D(mask3D,1:nCells,colors,1)
  
end
