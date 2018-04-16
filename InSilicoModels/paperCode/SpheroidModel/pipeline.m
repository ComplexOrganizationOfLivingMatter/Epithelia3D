addpath(genpath('src'));
addpath(genpath('lib'));

%% First, we create the spheroid objects
mainCreateSpheroidCombinations

%% Second, create projections and measure the energy on these projections
mainMeasureEnergy

%% Third, calculate the number of scutoids and its properties
mainAngleLengthScutoidsInEdges

%% Finally, compute the curvature of each ellipsoid
mainCurvatureInEllipsoidSurface