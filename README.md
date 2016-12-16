# Meanshift
--------------------
General Information
--------------------
This project contains two parts: Image segmentation and motion tracker.
Both can be run seperately. They can run together with first image segmentation and then motion tracker. 

--------------------
To run segmentation
--------------------
1. put the image file to be processed in to the same folder
2. in eval_segmentation.m line 5, change the file name to the one to be processed
3. set up parameters in line 7-11 if desired.
4. run
5. image and each cluster on feature space will show and be saved after each step

 
--------------------
To run motion tracker
--------------------
1. put the stream of images into a folder with 'foldername'
2. in eval_Mstracking.m line 9, change to the foldername and file extension
3. run
4. The first frame of the image stream will show
5. Select the region to track, double click after you are done
6. the red box will show the tracking result in each image 


--------------------
To run segmentation + motion tracker
--------------------
1. put the stream of images into a folder with 'foldername'
2. in eval_Seg_Track.m line 9, change to the foldername and file extension
3. run
4. progress of image segmentation will show up. Result images will be saved to a folder called 'CCseg'
5. perform 'To run motion tracker' and change folder to be 'CCSeg'
