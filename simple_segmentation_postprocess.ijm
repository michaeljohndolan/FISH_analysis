//Code to extract the simple segmentations from Ilastik batch processing on a single channel and save them in the Output directory. 
//This code will also extract a display image with inflated cells that can be used with DAPI images for visualization

//Set the path you are saving all the output files to: 
path="/Users/michaeljohndolan/Desktop/Ilastik_prototype/Output"; 

//Get main directory 
maindir=getDirectory("Choose the parent directory"); 
list=getFileList(maindir);

//Run postprocessing pipeline 
for (i=0; i<list.length; i++) {
	open(list[i]); //Open each individual simple segmentation 

	//Create a binarized image 
	run("16-bit");
	setAutoThreshold("Default dark");
	run("Threshold...");
	run("Convert to Mask");
	run("Invert");
	
	//Postprocess the image to get complete cells and remove noise 
	run("Fill Holes");
	run("Erode");
	run("Dilate");
	run("16-bit");
	saveAs("Tiff", path+"/postprocessed_"+list[i]);

	//Create a display image for easy visualization. Can tweak the radius of kernel for larger/smaller representations 
	run("Maximum...", "radius=5.5");
	saveAs("Tiff", path+"/DISPLAY_postprocessed_"+list[i]);
	close(); 

}

//Save the 

//Shut down imageJ
run("Quit");
