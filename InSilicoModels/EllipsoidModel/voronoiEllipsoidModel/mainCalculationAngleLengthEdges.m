
addpath(genpath('lib'))

ellipsoidsName={'Globe','Rugby','Sphere','Stage 4','Stage 8'};

for nEllipsoid=1:length(ellipsoidsName)
    
    pathFiles=getAllFiles(['results\' ellipsoidsName{nEllipsoid} '\randomizations\' ]);
    index1=cellfun(@(x) contains(x,'ellip') ,pathFiles);
    index2=cellfun(@(x) contains(x,'randomizations\random_') ,pathFiles);
    indexEllip=logical(index1.*index2);
    pathFilesEllipsoid=pathFiles(indexEllip);
    
    for i = 1 : size(pathFilesEllipsoid,1)

        load(pathFilesEllipsoid{i},'initialEllipsoid','ellipsoidInfo')

        ellipsoidInfo = calculateAngleLength(ellipsoidInfo);

        if ~isfield(initialEllipsoid,'edgesOrientation')
            
            initialEllipsoid = calculateAngleLength(initialEllipsoid);
            save(pathEllipsoid,'initialEllipsoid','-append')

        end
        
        save(pathEllipsoid,'ellipsoidInfo','-append')

    end
    
end

