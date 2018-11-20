# LimeSeg tutorial

## Definitions

D_0 : is the equilibrium spacing between the particles used by LimeSeg to delineate the 3D shape, expressed in units of pixels. A low value (~ 1 pixel) will lead to fine details being detected, at the cost of speed. A too high value will lead to important details being missed. 

F_Pressure: This pressure tends to induce the shrinking or the expansion of the surface. A positive value will lead to expansion of the surface by default, while a negative value will lead to shrinking. Its typical range is [-0.03..0.03]

Range in D_0 : is the size over which each particle will look for a local maximum. A value of 2 with a D_0 of 2 means that a local maximum will be looked for within a layer of 2 * 2 = [-4, 4] pixels around the surface.

Extracted from:

1. The article: https://www.biorxiv.org/content/early/2018/02/18/267534
2. FIJI wiki: https://imagej.net/LimeSeg

## Step 0: Pre-processing

0. Open the images in FIJI and keep the channel whose cell outlines are better. If the nuclei appear it could be a problem
1. The images suffer from photobleaching and, also, due to depth, the intensity of the fluorescence, decay with time. To solve this, you can use "Image" -> "Adjust" -> "Bleach correction". Select "Exponential fit". 'OK'.
2. Now you have to improve the brightness and contrast, you can do this by clicking in "Image" -> "Adjust" -> "Brightness/Contrast". You can either click on 'Auto' or change manually the parameters until you obtain a good result in which the cell lines are clear, but not too saturated. Then, press on 'Apply' and apply it to all the stack.
3. Save the final images as an image sequence (file->save as-> image sequence).

## Step 1: Basic lumen's pipeline

1. Open the images of the image sequence which contain the lumen in Photoshop.

2. Paint the lumen region like a black region with white borders:
	
	1. Create a new layer (layer->new layer).   
	
	1. Now,you have to select the paint brush at the left screen with the black color (color: 0,0,0)
	and white color (color:255,255,255).
	
	1. With this function you can select	the	lumen	point	to	point by typing shift key+left click.Segment the lumen 		like a black region,you have to use the black color now(you can type the letter X to change from a color to the other color).
	
	1. After segmenting the lumen, you have to paint the lumen like a black region with the paint bucket tool,ensure that                     the whole lumen is black, you can colour pixels which are not black with the pencil.*
	
	*note: If the lumen is divided in different pieces, you have to segment each lumen's piece one by one in the same image 		as"islands".
	
	1. Select the black region with the magic wand	(this tool allows you to choose specific regions of an image)	by typing left 		click in the region, and change the color to white(type x	if you selected it in the previous steps).
	
	1. Select the option "selection->modify->expand", and type 5 pixels.A new border should have appeared with the thickness 		indicated previosuly, colour it with the white colour.
	
	1. Type right click in the layers and select the option merging layers (combine layers) to decrease the final length of the 		image.
	
	1. Save the changes done.
	

3. Afterwards, you are going to capture the lumen region and not the gland:

	1. Copy the images which contain the lumen to the lumen's folder.
	
	1. Open an image of the lumen's folder.
	
	1. Add a new layer and paint it using the white color.
	
	1. Open the same image from the image sequence, which contains the lumen like black a region.
	
	1. Select the black region (lumen without borders) with the magic wand in the left screen and copy it.Then paste it in the white  	image which corresponds to the same image (z).
	
	1. Merge the layers and save the changes done.
	
	1. Finally you have to paint the images which don't contain the lumen as white images, you can do this automatically 	                    creating an action in photoshop (actions->new action), from this moment photoshop will capture all the things that                      you do,therefore you have to do these steps:
	
	   Add a new layer-> paint it as white.
	   
	   Save the image
	   
	   Close image
	
	  Later, click in file->automate->bundle , select the action that you have created and selected a folder which only contains the 	   images that don't contain the lumen because this action is applied to all the images in the folder.After this copy them to the	lumen's folder
	
	Thus, copy the images which don´t contain the lumen in a separated folder and do that action for that folder.After that, copy 		that images to the lumen's folder.

## Step 2: Basic cell's pipeline

1. Open the image, whose cell outlines can be better segmented.
2. Select "ellipse" and put an ellipsoidal ROI near to the basal region of the cell*. Press 'T'.
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
	
	
	
 *Note:if the cell's shapes were not	correct, you could try to improve the shape by changing the positions of the seeds and positioning them not only in the basal region, for instance in the middle of the cell.
 
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
- Put the ROIs near the basal region of the cells to delimitate correctly the lumen and this way the cells won't be place inside the lumen.


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
