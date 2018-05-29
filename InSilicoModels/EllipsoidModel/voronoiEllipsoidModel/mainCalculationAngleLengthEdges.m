
addpath(genpath('lib'))

ellipsoidsName={'Stage 4','Stage 8','Globe','Rugby','Sphere'};

for nEllipsoid=1:length(ellipsoidsName)
    
    pathFiles=getAllFiles(['results\' ellipsoidsName{nEllipsoid} '\randomizations\' ]);
    index1=cellfun(@(x) contains(x,'ellip') ,pathFiles);
    index2=cellfun(@(x) contains(x,'randomizations\random_') ,pathFiles);
    indexEllip=logical(index1.*index2);
    pathFilesEllipsoid=pathFiles(indexEllip);
    
    for i = 1 : size(pathFilesEllipsoid,1)

        load(pathFilesEllipsoid{i},'initialEllipsoid','ellipsoidInfo')
        
        if ~isfield(ellipsoidInfo,'edgesOrientation')
        
            ellipsoidInfo = calculateAngleLength(ellipsoidInfo);

            if ~isfield(initialEllipsoid,'edgesOrientation')

                initialEllipsoid = calculateAngleLength(initialEllipsoid);
                save(pathFilesEllipsoid{i},'initialEllipsoid','-append')
                
                disp(['Initial ellipsoid - ' pathFilesEllipsoid{i}])

            end

            save(pathFilesEllipsoid{i},'ellipsoidInfo','-append')
            disp(['Outter ellipsoid - ' pathFilesEllipsoid{i}])
        end
    end
    
end

