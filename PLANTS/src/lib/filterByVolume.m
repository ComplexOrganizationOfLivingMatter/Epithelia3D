function img3d = filterByVolume(img3d,volumeFilter)

    img3d=uint16(img3d);
    cellLabel=unique(img3d);
    cellLabel=cellLabel(cellLabel>0);
    
    for nCell=1:length(cellLabel)
        mask=img3d==cellLabel(nCell);
        if sum(mask(:)) < volumeFilter
            img3d(img3d==cellLabel(nCell))=0;
        end
    end

end

