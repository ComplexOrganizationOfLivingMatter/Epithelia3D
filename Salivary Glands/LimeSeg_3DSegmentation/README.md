# LimeSeg tutorial

## Step 1: Basic cell's pipeline

1. Obtain the channel green of the stack and improve the contrast and brightness of all its images (Image -> Adjust -> Brightness/Contrast).
2. Select "ellipse" and put an ellipsoidal ROI near the nucleus, but with a slightly bigger radius. Press 'T'.
3. Plugins -> Limeseg -> Sphere Seg (advanced).
4. Change parameters (D_0 is optional and Z_Scale is mandatory). To calculate Z_Scale you should divide 'Voxel depth'/'Pixel width': in our case 4.06. Also you should select a color. Tick 'ClearOptimizer'.
5. Press 'Accept' and wait for the 3D objects to be full and smooth.
6. **Remember** to clear the 3D viewer each time you run LimeSeg. 'Plugins -> Limeseg -> Clear all'.
7. Repeat 2-6 until all the cells have an assigned ROI.
8. Save the ROIs as a zip. 'Roi Manager -> More -> Save...'
9. Save the cells.
	1. Plugins -> Limeseg -> Show GUI
	2. Click on 'WriteTo:' and select where you want to export the results. Tipically on: 'YOURPATH/Cells/OutputLimeSeg/'
	3. Press 'SaveStateToXmlPly'. A directory will be created for each cell. Don't care about the ids of the cell.
	
### Refining the cells

If a cell is not properly formed, try put the seed closer to the region not covered. You should also consider put a bigger ellipsoidal ROI.
For this purpose, you can change the ROI characteristics and click 'Update' on the ROI Manager.
Another option is to create a new ROI and remove the older one.

If the error persists and it is unimprovable, you can always refine the cell boundary in the Matlab's program created by us. 

### Load results

If you have to leave and you have not finish the salivary gland, you can always save your work and start over the next day. You only need to load the ROI you previously saved:
1. Open a ROI Manager.
2. 'Roi Manager -> More -> Open...'

### Advices

- Save the ROIs often, not just at the end of the pipeline.
- Prepare yourself using 'shortcuts'.
- You can show all the ROIs you have created, by pressing 'Show all' in the ROI Manager.

## Step 2: Basic lumen's pipeline

1. Segment the lumen of the images, taking a bit more that is strictly at your sight. I.e. You should paint as a lumen a bit of apical cells.If you don’t know how to segment the lumen of each image, you can do it with Photoshop following the next steps:

	1. 1.1	Load the image which contains the lumen (file->open->select your image).
	1. 1.2  Create a new layer (layer->new layer)
	1. 1.3	Now,you have to select the paint brush at the left screen.
	1. 1.4  With this function you can segment the lumen point point to point by doing  typing shift key+left click.(
	you should always locate the segment point of the ROI slightly far from the lumen).
	1  1.5  After segmenting the lumen, you have to paint the lumen like a black region 
	
2. Once the lumen is properly segmented, import it to FIJI.
3. Now you have 2 options:
	1. As if the lumen was a cell, put an spheric ROI, change the parameters (low F_pressure, high D_0) and get a proper lumen.
	2. (OPTION WE ARE USING) Follow the steps of [LimeSeg](http://imagej.net/LimeSeg) section 'Starting with a ROI skeleton', where the seeds are selected to build the egg chamber skeleton. Select a ROI polygon for each lumen frame. It is really important wrap the segmented black lumen locating the polygon ROI over the white zone (never mixing white and black zones). If you have 2 or more separated lumens you should only catch one of them (not more than 1 ROI per Z) . Proper experimental parameters are: D_0 = 10 and F_pressure = -0.01
	
4. There has to be a full lumen, with no holes.
5. Save your results:
	1. First the ROI. 'Roi Manager -> More -> Save...'
	2. Plugins -> Limeseg -> Show GUI
	3. Click on 'WriteTo:' and select where you want to export the results. Tipically on: 'YOURPATH/Lumen/OutputLimeSeg/'
	4. Press 'SaveStateToXmlPly'

## Step 3: Matlab's refining process

1. Execute 'Epithelia3D/Salivary Glands/LimeSeg_3DSegmentation/main.m' in Matlab. It is prepared for R2018a.
2. Select the folder where you have your images. Remember to have all the directories as explained in the 'Directories hierarchy'.
3. Go to 'Cells/labelledSequence', where you will find the labelled image for each Z plane.
4. Find the invalid cells (i.e. cells that does not have the correct neighbours), which will be at the tips of the salivary gland.
5. When the pop-up dialog shown 'Insert the non-valid cells', insert the IDs of the no valid cells (**comma-separated**, e.g. '1, 30, 3, 95') and click 'ok!'.
6. A plot showing from the basal layer (left) and apical (right):
	1. At top: The layer with all the cells that forms the tube.
	2. At bottom: The tube in black and the layer with the missing cells. Also, in the title there are the ids of the cells.
7. If there is any missing cell, that means that it does not touch that layer. Therefore, you should change any of the cell's area in its Z planes. For this purpose, you should click on 'Yes' when the dialog 'Do you want to change anything' appears.
8. Seek for a missing cell and see where it should be touching the lumen or basal layer. This would be the Z plane where the cell is ought to be changed. Select either the whole cell or the new region it should be covering. All the pixels that are in this region, now belong to the selected cell. In addition, Z planes near the actual Z ([-3, +3]), may be changed due to this operation, on the behalf of the smoothness of the 3D cell shape.
9. Close the window.
10. If you don't want the new changes, you can discard by clicking in 'No, don't save the changes'. Otherwise, press 'Yes'.
11. Save the polygon distribution of apical and basal in a excel file where all the info is collected.

From step to step, it could take some time.

### Tricks

- If you don't want the actual ROI, press again the ROI button.
- Once you click on 'Save', the only thing you can do if something's wrong, is close the window and press 'No, don't save the changes'.
- If you change the actual cell id or Z plane, the ROI disappears.

### Directories hierarchy

'Cells' -> Save all the information related the cells (ROIs, images...).
'Cells/OutputLimeSeg' -> Save the cell info from LimeSeg.

'ImageSequence' -> Original image sequence

'Lumen' -> Save here all the information related to the lumen (segmented images of the lumen, ROIs, etc).
'Lumen/OutputLimeSeg' -> Save the lumen segmented by LimeSeg.

## TROUBLESHOOTING

- Error: Saving the results using the 'SaveStateToXmlPly' button in the GUI.

**Solution**: The directory should always be empty.

- Error: You have put a non-oval ROI, i.e. intersect ROIs, polygon ROIs, etc.

**Solution**: LimeSeg only admits oval ROIs.

- Error: You created a ROI and it is not displayed in the 3D viewer. You can see if it has not created correctly by inspecting the 'Number of Surefels' is equal to 0 and/or 'Centers' is not a number (NaN).

**Solution 1**: Is the ROI too small? Create a bigger ROI. Smaller ROIs are not captured.

**Solution 2**: Have you put 2 seeds in the same cell? This could be causing problems.

- Error: You see different colours for the same cells.

**Solution**: Clear the 3D viewer. 'Plugins -> Limeseg -> Clear all'

- Error: The 3D viewer does not finish (you are seeing pixels moving and holes in the cells)

**Solution**: 'Plugins -> Limeseg -> Stop optimisation'

- Error: 'There is an empty cell. Please, check if that cell is correct or remove the directory: cell_NumberOfCell'

**Solution**: First, you have to check why that cell appears to have no points. This is probably because you have created the ROI of the cell, but it has disappear throughout the execution of LimeSeg. If that's the case, put that cell correctly and export all the cells again. Otherwise, remove the directory and run the matlab function.

### Shortcuts

We advise to put shortcuts instead of performing all the clicking. To do this, you must 'Plugins -> Shortcuts -> Add shortcut'. We have put:

- F1 -> 'Clear all'
- F2 -> 'Sphere Seg (advanced)'
- F3 -> 'Show Overlay'
- F4 -> 'Hide Overlay'

where the first thing is the key we want to assign and the second is the command.
