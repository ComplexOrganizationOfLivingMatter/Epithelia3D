
import eu.kiaru.limeseg.LimeSeg;
// Objects used by LimeSeg
import eu.kiaru.limeseg.struct.Cell;
import eu.kiaru.limeseg.struct.CellT;
import eu.kiaru.limeseg.struct.DotN;
import eu.kiaru.limeseg.struct.Vector3D;
import eu.kiaru.limeseg.opt.Optimizer;

import ij.IJ;

import ij.gui.Roi;
import ij.plugin.frame.RoiManager;
import java.awt.Point;
import java.awt.Image;
import ij.ImagePlus;


// Inflate all cells along the normal vector


float expansion =5;
float ZScale = 4.09;

int label = 53;
float selectedZ = 36; //-1???

	Cell c = LimeSeg.allCells.get(label - 1)
	LimeSeg.currentCell=c;
	// Fetch CellT object = single 3D object, rather obvious here because there is only one timepoint
	CellT ct = c.getCellTAt(1);
	ArrayList<DotN> dots = new ArrayList<>();
	for (DotN dn: ct.dots) { // DotN object = surfel = a position and a normal vector
		if (dn.pos.z != selectedZ*ZScale){
			//Remove pixels
			dots.add(dn);
		}
	}
	
	
	ImagePlus image = IJ.getImage();
	Roi r = image.getRoi();
		if (r != null) {
			for (Point point : r) {
				
				for (float num = 1; num < selectedZ; num++){
					/*print(point.x);
					print(" - ");
					print(point.y);
					print("\n")*/
	                //Vector3D pos = new Vector3D((float) point.x, (float) point.y, num*ZScale);
	                Vector3D normal = new Vector3D(0,0,1);
	                dots.add(new DotN(new Vector3D((float) point.x, (float) point.y, num*ZScale),normal));
				}
			}
		}
	/*print(dots)
	print(" - ");*/
	print(ct.dots)
	ct.dots = dots;

LimeSeg.update3DDisplay(); // notifies 3D viewer that the dots have changed

// To update 2D display:
LimeSeg.clearOverlay();
LimeSeg.updateOverlay();
LimeSeg.addAllCellsToOverlay();
