function h = paint3DVoronoiTubes(path2save,nCells,colors)

  nameMat= dir([path2save '*.mat']);
  
  load([path2save nameMat(1).name],'info3DCell');
  mask3D = zeros(size(info3DCell.region));
  
  for nCel = 1 : nCells
        load([path2save nameMat(nCel).name],'info3DCell');
        nameFil = strrep(nameMat(nCel).name,'.mat','');
        nameSplt = strsplit(nameFil,'_');       
        mask3D(info3DCell.region > 0 ) =  str2double(nameSplt{end});
  end
  h=figure;
  paint3D(mask3D,1:nCells,colors,1)
  
end
