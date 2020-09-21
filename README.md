# GK_shiny_app

### Package description / introduction 
Application can be run online at:  https://hab-gk-app.shinyapps.io/gk_shiny_app/
>> Due to server limitiations this is not recommended for large images (and/or large dataset of images)

### Instructions for local installation 
Download SVMshiny_0.0.0.9000.tgz file. 
In command line run: R CMD INSTALL SVMshiny_0.0.0.9000.tgz
Open R (or Rstudio) and type this into console: 
>>> library (SVMshiny)\ run_app()

### Data management tips 
* Separate your data into two sets (with equal proportion of each class): Training, Test
  * **Training images**: used for classification / creation of model
  * **Test images**: only used to test model after creation 
* It is recommended to keep each class in its own subdirectory for ease 

### Application Overview/ Workflow
### Notes 
  * You only need to go through the image setup/segmentation once (if you saved parameters file); but it is necessary to go through image setup before the segmentation step
  * It is highly recommeneded that you save the parameter settings immediately after segmentation
    * If you do not save a parameters file you MUST go through the image setup and segmentation steps before proceed with the classification / create model steps (in the same session)
  * **You** MUST have a saved parameters file to upload in the test model step* 
  * the Classification / Create Model / Test Model steps are independent from each other and do not need to be performed sequentially (if you have the prerequisite files)

####  Image setup 
1. Load a single file from your dataset to be used for image segmentation (Browse: )
  * The segmentation parameters optimized by you for this file will be then be applied to the classification of all images for this experiment
  * Image file must be in TIFF format, and a single Z plane (or maximum projection) 
2. Following successful upload of your image file, each channel will be displayed in the main panel.
  * Select the "Ch1", "Ch2".. tabs to display each channel of the image
  * Use the intensity slider to adjust the brightness for visibility 

>>>this will **not** be the intensity value ultimately saved in the parameters file 

3. Using the drop down menus on the side panel select which channel represents the nuclei, and which channel represents the phenotype you are classifying. These choices will be saved with the segmentation parameters

#### Segmentation 
1. Segment Nuclei (this should be done before the phenotype segmentation)
  * The nuclei channel of image chosen in [Image Setup] is displayed in the top right plot
  * Sidebar: sliders for each parameter determines nuclei segmentation and adjusted by user 
  * The values of the parameter sliders are automatically saved within application instance (user-determined, or default values)
  
>>>> The other plots displayed are responsive to the slider values:
  * (top left) Binary mask (pre-segmentation)
    * (bottom right) Colorized masks (post-segmentation)
    * (bottom left) Outlines of segmented nuclei overlaid on original nuclei image
  
2. Segment whole cell
  * The segmented nuclei are "seeds" for cell segmtentation 
  * (Whole) cell segmentation utilizes the phenotype channel image
  * Similar to nuclei segmentation page; user-adjustable sliders represent parameters for segmentation
  
>>>>Plotted images: 
      -- (top right) Binary mask (pre-segmentation) of "local" cell edges 
      -- (top left) Binary mask (pre-segmentation) of "global"" cell edges
      -- (bottom right) Colorized masks (post-segmentation)
      -- (bottom left) Outlines of segmented cells overlaid on original image. 
      
  3. Save image parameters
    * Save parameter settings for both nuclei and cell segmentation
    * This file can be loaded and used for the remaining application steps *if you are satisfied with your cell segmentation you do not need to perform this step again 
    * This file is required for the Test Model step
    * Download as csv file
    * User can change name of this file; but must keep '.csv' extension 
      * The default name of this file is "table.csv"
    * User can save file into any local directory
      * Default directory is browser/computer determined 

#### Classification
  1. Click on red button to choose to upload segmentation parameters 
  2. *Optional* Check "Upload Segmentation Parameters" if you want to upload the parameters (csv) file
  - If file is not loaded, the parameters set during the Image Setup/Segmentation steps (in same session) will be used.
  
>>>> You do not need to sequentially go through the Positive classification tab before the Negative, or vice versa. These can be performed in different sessions (assuming uploaded/previously set segmentation parameters)  

>>>> BUT to create the model you will ultimately need two separate training files- one for positive, one for negative!

##### Positive phenotype classification (tab panel)
>>> Determines model's ability to identify cells exhibiting "positive phenotype"

  1. Select image files from training dataset that exhibit the phenotype of interest. Images with a single field that has both cells with both positive or negative phenotype can be used. 
    - Manually select multiple files using method for operating system (Windows, Mac)
  2. After uploading files, click the "Load Image" button once 
    - This button loads the first OR next image file (after first image has been loaded and used for selecting cells)
    - After loading the first image this button also temporarily* "saves" the selected cells for the first and subsequent loaded images
    * You MUST use "Save Classification File" to save these results to your local computer for subsequent model creation
  3. After pressing "Load Image" button the first uploaded image will be displayed in main panel. The individual segmented cells are outlined in yellow
    - Using cursor click on all the cells that exemplify the positive phenotype 
    -- Click the middle of the outlined cell (for each cell choice)
  4. After all desired cells in that image are selected, press "Load Image" again (once)
    - This will load the next image file that was uploaded in step A
    - Repeat steps 1-3 until there are no more images (Or when user desires)
  5. Press "Save (+) Classification File" Save the training file with classification information 
    - User can change name and file destination but MUST have '.rds' extension
    
##### Negative phenotype classification (tab panel)
  - Determines model's ability to identify cells not exhibiting phenotype (control/untreated)
  1. Select image files containing all or a mix of negative phenotype cells
  2. Repeat steps 2-4 described in "Positive" classification instructions
  3. Press "Save (-) Classification File" 
    - User can change name, must be '.rds'
    - Save file in the same directory as the positive_training file. 
    - You must have TWO training RDS files, one for positive, one for training

### Create Model 
  1. Select both positive and negative training RDS files 
  
>>>>They must be selected/uploaded together

  2. After uploading the rds files: 
    * Side panel shows the total number of classified cells found in positive and negative training files. 
    * Main panel displays the PCA (principal component analysis) plot
  3. Press the "Save Model File" button
    * This will make a single RDS file containing model 

### Test model
  1. Input three files: 
    * Image (containing positive phenotype cells) to test the model on 
    * Model file (rds) generated in create model step
    * Parameters file (csv) for cell segmentation
  2. Once all 3 required files are uploaded, the main panel will display the test image (phenotype channel) outlined in blue. 
    * Blue outlined cells are the ones the model classifies as "positive"
  3. Adjust the SVM decision value using slider to determine desired threshold for positive classification by model 
  4. Press "Download Settings" to save a new parameters file that includes decision value



*Demo* files:

    
  
    
    
  
  
  