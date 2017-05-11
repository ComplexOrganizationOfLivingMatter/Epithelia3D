function [ neighbourhoodAreas ] = meanAreaOfCellsInRoi(imgPlaneWithLabels, bounding_box )
%MEANAREAOFCELLSINROI Summary of this function goes here
%   Detailed explanation goes here
    croppedImg2 = imcrop(imgPlaneWithLabels, bounding_box);
    neighbourhoodCells = unique(croppedImg2);
    imgPlaneWithLabelsCropped = imgPlaneWithLabels .* ismember(imgPlaneWithLabels, neighbourhoodCells(neighbourhoodCells ~= 0));
    imgPlaneWithLabelsNoHoles = imfill(imgPlaneWithLabelsCropped, 8, 'holes');
    neighbourhoodAreas = arrayfun(@(x) sum(sum(imgPlaneWithLabelsNoHoles == x)), unique(imgPlaneWithLabelsNoHoles));
    %Deleting zero
    neighbourhoodAreas(1) = [];
end

