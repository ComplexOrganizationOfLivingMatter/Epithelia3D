# LimeSeg tutorial

## Basic cell's pipeline

1. Obtain the channel green of the stack and improve the contrast and brightness of all its images.
2. Select "ellipse" and put an ellipsoidal ROI near the nucleus, but with a slightly bigger radius. Press 'T'.
3. Plugins -> Limeseg -> Sphere Seg (advanced).
4. Change parameters (D_0 is optional and Z_Scale is mandatory). Also you should select a color. Tick 'ClearOptimizer'.
5. Press 'Accept' and wait for the 3D objects to be full and smooth.
6. **Remember** to clear the 3D viewer each time you run LimeSeg.
7. Repeat 2-6 until all the cells have an assigned ROI.
8. Save the ROIs as a zip. 'Roi Manager -> More -> Save...'
9. Save the cells:
	9.1. Plugins -> Limeseg -> Show GUI
	9.2. Click on 'WriteTo:' and select where you want to export the results. Tipically on: 'YOURPATH/Cells/OutputLimeSeg/'
	9.3. Press 'SaveStateToXmlPly'
	
### Refining the cells

If a cell is not properly formed, try put the seed closer to the region not covered. You should also consider put a bigger ellipsoidal ROI.

### Load results

To load the results

## Basic lumen's pipeline

1. Segment the lumen of the images, taking a bit more than is strictly at your sight. I.e. You should paint as a lumen a bit of apical cells.
2. Once the lumen is properly segmented, import it to FIJI.
3. Follow the steps of [LimeSeg](http://imagej.net/LimeSeg) section 'Starting with a ROI skeleton', where the seeds are selected to build the egg chamber skeleton. Select a ROI polygon for each lumen frame.
4. There has to be a full lumen, with no holes.
5. Save your results:
	5.1. First the ROI. 'Roi Manager -> More -> Save...'
	5.2. Plugins -> Limeseg -> Show GUI
	5.3. Click on 'WriteTo:' and select where you want to export the results. Tipically on: 'YOURPATH/Lumen/OutputLimeSeg/'
	5.4. Press 'SaveStateToXmlPly'

## TROUBLESHOOTING

Error: Saving the results using the 'SaveStateToXmlPly' button in the GUI.
**Solution**: The directory should always be empty.

Error: 
**Solution**: 

Error: 
**Solution**: 


### Advices

- Save the ROIs often, not just at the end of the pipeline.

### Shortcuts

We advice to put shortcuts instead of perform all the clicking. To do this, you must 'Plugins -> Shortcuts -> Add shortcut'. We have put:

F1 -> 'Clear all'
F2 -> 'Sphere Seg (advanced)'
F3 -> 'Show Overlay'
F4 -> 'Hide Overlay'

where the first thing is the key we want to assign and the second is the command.


### Directories hierarchy

