import eu.kiaru.limeseg.LimeSeg;
// Objects used by LimeSeg
import eu.kiaru.limeseg.struct.Cell;
import eu.kiaru.limeseg.struct.CellT;
import eu.kiaru.limeseg.struct.DotN;
import eu.kiaru.limeseg.struct.Vector3D;


// Inflate all cells along the normal vector
float expansion = 0.5;


LimeSeg.currentCell = LimeSeg.allCells.get(index);

	// Fetch CellT object = single 3D object, rather obvious here because there is only one timepoint
	CellT ct = LimeSeg.currentCell.getCellTAt(1);
	for (DotN dn: ct.dots) { // DotN object = surfel = a position and a normal vector
		dn.pos.x+=dn.Norm.x*expansion;
		dn.pos.y+=dn.Norm.y*expansion;
		dn.pos.z+=dn.Norm.z*expansion;
	}

LimeSeg.update3DDisplay(); // notifies 3D viewer that the dots have changed

// To update 2D display:
LimeSeg.clearOverlay();
LimeSeg.updateOverlay();
LimeSeg.addAllCellsToOverlay();