function mptLayersVoronoi3D( pathArchMat )

load(pathArchMat);
seeds=vertcat(LayerCentroid{:});

B=Polyhedron('V',seeds);
B.plot()

%648 to represent only the first layer

numCentroidLayer1=size(LayerCentroid{1,1},1);

V = mpt_voronoi(seeds(1:numCentroidLayer1,:)', 'bound', B);

V.plot()
hold on
plot3(seeds(1:numCentroidLayer1,1)-10,seeds(1:numCentroidLayer1,2),seeds(1:numCentroidLayer1,3),'*')

end

