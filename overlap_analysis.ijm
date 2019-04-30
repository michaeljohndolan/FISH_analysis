//This code will run within R and read in pairs of images for overlap analysis 

//Interperting multiple pasted arguments
arg = getArgument;
delimiter = "*";
paths=split(arg, delimiter);

//Print the paths for test 
for (i=0; i<paths.length; i++) {
print(paths[i]);
}

//Open the files, convert to 8-bit 
for (i=0; i<paths.length; i++) {
open(paths[i]);
run("8-bit");
}

names= getList("image.titles");

//Extract and save particle information for each image. Summarize will save the results until the end. 
for (i=0;i<names.length;i++) {
	selectWindow(names[i]);
	run("Analyze Particles...", "display summarize");	
}

//Code to change names to numbers 
names= getList("image.titles");
for (i=0;i<names.length;i++) {
			selectWindow(names[i]);
			rename(i);
}


//Perform an AND operation, rename the resulting image and calculate the correct overlap
imageCalculator("AND create", "0","1");
rename("AND_image"+arg); 
save("AND_image"+arg+".tif");
run("Analyze Particles...", "display summarize");	

//Create a DISPLAY version of the AND image
selectWindow("AND_image"+arg);
run("Maximum...", "radius=5.5");
save("DISPLAY_AND_image"+arg+".tif");
close();

//Save the summary file for the whole experiment in Output directory 
selectWindow("Summary"); 
saveAs("Results", "/Users/mdolan/Desktop/Ilastik_prototype/Output/summary.csv");
 
//Close
close("*");
run("Quit");
