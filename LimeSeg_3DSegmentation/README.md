# LimeSeg tutorial

## Definitions

D_0 : is the equilibrium spacing between the particles used by LimeSeg to delineate the 3D shape, expressed in units of pixels. A low value (~ 1 pixel) will lead to fine details being detected, at the cost of speed. A too high value will lead to important details being missed. 

F_Pressure: This pressure tends to induce the shrinking or the expansion of the surface. A positive value will lead to expansion of the surface by default, while a negative value will lead to shrinking. Its typical range is [-0.03..0.03]

Range in D_0 : is the size over which each particle will look for a local maximum. A value of 2 with a D_0 of 2 means that a local maximum will be looked for within a layer of 2 * 2 = [-4, 4] pixels around the surface.

Extracted from:

1. The article: https://www.biorxiv.org/content/early/2018/02/18/267534
2. FIJI wiki: https://imagej.net/LimeSeg

## Step 0: Pre-processing

0. Open the images in FIJI and keep the channel whose cell outlines are better and whose quality is the best (usually it is the red channel because it doesn't contain the nuclei of the cells). If the nuclei appear, it could be a problem.

1. The images suffer from photobleaching and, also, due to depth, the intensity of the fluorescence, decay with time. To solve this, you can use "Image" -> "Adjust" -> "Bleach correction". Select "Exponential fit". 'OK'.

2. Now you have to improve the brightness and contrast, you can do this by clicking in "Image" -> "Adjust" -> "Brightness/Contrast". You can either click on 'Auto' or change manually the parameters until you obtain a good result in which the cell lines are clear, but not too saturated. Then, press on 'Apply' and apply it to all the stack.

3. Once you have adjusted the image brightness, you have to save the image with a different channel colour: white or green with the background as black.You can do this by: "Image"->"Color"-> "Channel tool"-> "More"->"Green" or "White" (Whether it is white or green, it is up to you, select the best to you).

4. Save the final images as an image sequence (file->save as-> image sequence). And as a tiff.


## Step 1: Basic cell's pipeline

0. At the same time that you do the first step you can do the second step, therefore read first the first step and start it, and later      start doing the second step at the same time.

1. Open the image, whose cell outlines are the best to segment the cells.

2. Select "ellipse" and put an ellipsoidal ROI near to the basal region of the cell*. Press 'T'.

3. Plugins -> Limeseg -> Sphere Seg (advanced).

4. Change parameters (D_0 is optional and Z_Scale is mandatory). To calculate Z_Scale you should divide 'Voxel depth'/'Pixel width': in    our case 4.06. Also you should select a color. Tick 'ClearOptimizer'.

5. Press 'Accept' and wait for the 3D objects to be full and smooth.

6. **Remember** to clear the 3D viewer each time you run LimeSeg. 'Plugins -> Limeseg -> Clear all'.

7. Repeat 2-6  by groups (until all the cells have an assigned ROI), adding each time more cells and save the ROIs as a zip:               'Roi Manager -> More -> Save...'

8. When all the cells have a ROI,you have to save their data:
	1. Plugins -> Limeseg -> Show GUI
	2. Click on 'WriteTo:' and select where you want to export the results. Tipically on: 'YOURPATH/Cells/OutputLimeSeg/'
	3. Press 'SaveStateToXmlPly'. A directory will be created for each cell. Don't care about the ids of the cell.
	
	
 *Note:if the cell's shapes were not correct, you could try to improve the shape by changing the positions of the seeds and positioning them not only in the basal region, for instance in the middle of the cell.
 
### Refining the cells

If a cell is not properly formed, try put the seed closer to the region not covered. You should also consider put a bigger ellipsoidal ROI or put the ellipsoidal in a layer later than the previous.Another options are to move the position of the cell to a position more basal or change the parameters of D_0 or/and F_pressure (but don't use this option to correct only one cell, if you use this option, it is to correct a lot of cells).

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



## Step 2: Basic lumen's pipeline

0. Identify the images which contain the lumen (where does the lumen begin? and where does the lumen end?).Copy these images to 'Lumen-> SegmentedLumen folder'.

1. Open the images of the image sequence which contain the lumen in Photoshop.

2. Paint the lumen region as a black region with white borders:
	
	1. Create a new layer (layer->new layer).   
	
	1. Select the pencil at the left screen with the black color (color: 0,0,0) and white color (color: 255,255,255).
	
	1. With this function you can select the lumen point to point by typing shift key+left click.Segment the lumen like a black                region, you have to use the black color now.
	
	1. After segmenting the lumen, you have to paint the lumen like a black region.To make it easy select the area contained by the            black borders with the magic wand in the left screen.Now increase the scale of the pencil and paint the area selected with              the  magic wand, ensure that the whole lumen is black, you can colour pixels which are not black with the pencil.*
	
	1. Copy the lumen's layer (right click in the lumen's layer and copy) and select the copy select with the magic wand (this tool            allows you to choose specific regions of an image) by typing left click in the region, and change the color to white(type x              if you selected it in the previous steps).
	
	1. Select the option "selection->modify->expand", and type 5 pixels.A new border should have appeared with the thickness                    indicated previosuly, colour the whole layer with the white colour.
	
	1. Move the black layer above the background layer and the white layer.

	*note: If the lumen is divided in different pieces, you ´will have to segment each lumen's piece one by one in the same image 		as"islands".
	

3. Afterwards, you are going to segment the correspondig image in the images of SegmentedLumen's folder:

	1. Open the image that contains the lumen in SegmentedLumen, which is the correspondig to the one that you have processed                  previously.
	
	1. Copy the black lumen region of the ImageSequence image in the lumen image of SegmentedLumen.You can do this by clicking in              the layer:"duplicate" and select the other image.
	
	1. Add a new layer in the image of SegmentedLumen, and painted as white.
	
	1. Move the layer of the lumen above the white layer of the image of SegmentedLumen.
	
	1. Type right click in the layers of both images and select the option merging layers (combine layers) to decrease the final                length of the images.
	
	1. Save the changes done in both images.
	
	1. Keep doing this process with the remaining  lumen images.
	
	
	
4. Finally you have to paint the images which don't contain the lumen as white images, you can do this automatically 	                    creating an action in photoshop (actions->new action), from this moment photoshop will capture all the things that                      you do,therefore you have to do these steps:
	
	   Add a new layer-> paint it as white.
	   
	   Save the image
	   
	   Close image
	
	  Later, click in file->automate->bundle , select the action that you have created and selected a folder which only contains the 	   images that don't contain the lumen because this action is applied to all the images in the folder.After this copy them to the	   lumen's folder
	
	  Thus, copy the images which don´t contain the lumen in a separated folder and do that action for that folder.After that, copy 	  that images to the lumen's folder.



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
11. After saving the changes an excel should have appeared with characteristics of the cells and a message could have appeared which states the IDs of the cells whose TotalNeighbours and Apicobasal neighbhours differ, in this case you have to revise the neighbours of the cells whose IDs were displayed in the message and you have to see which parameter (TotalNeighbours or Apicobasal) is true or not in the labelled images.

The gland will be correctly segmented,if it doesn't appear any message or missing cell in Matlab and the characteristics of cells are normal in the excel

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
