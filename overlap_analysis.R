#Code for analysing Fcrls and Ccl3 distributions
#Run in main Output directory after postprocessing macro 

#Load the libraries, ImageJ path and set the directory:  
library(ggplot2)
library(dplyr)
command<-"java -Xmx5024m -jar /Applications/ImageJ.app/Contents/Java/ij.jar -ijpath /Applications/ImageJ -macro /Users/mdolan/Desktop/Ilastik_prototype/overlap_analysis.ijm "

extract.nochannel.name<-function(x){
  namelist<-strsplit(x =x, split = "-")
  sapply(namelist, "[", 2)
}
extract.n<-function(x) {
  list<-strsplit(x =x, split = "_" )
  sapply(list, "[", 4)
}
extract.timepoint<-function(x) {
  list<-strsplit(x =x, split = "_" )
  sapply(list, "[", 5)
}
extract.slice<-function(x) {
  list<-strsplit(x =x, split = "_" )
  sapply(list, "[", 8)
}
extract.tile<-function(x) {
  list<-strsplit(x =x, split = "_" )
  sapply(list, "[", 8)
}

setwd("~/Desktop/Ilastik_prototype/Output")

#Remove the spaces between Simple and Segmentations
files<-list.files(pattern = "*.tif", recursive = F)
files.nospace<-gsub(files, pattern = " ", replacement = "", fixed = T)
file.rename(from = files, to = files.nospace)

#Sort the different samples by channel, exclude DISPLAY images:  
files<-list.files(pattern = "^postprocessed", recursive = F)
Ch1<-grep(files, pattern = "C2", value = T) 
Ch2<-grep(files, pattern="C3", value=T)
nochannel.file.codes<-extract.nochannel.name(Ch1) #Remove channel info to match images

#Build df of different animals. Will need to code in a slice and tile code here FIX THIS 
#with finalized image code.  
animal=extract.n(Ch1)
timepoint=extract.timepoint(Ch1)
slice=extract.slice(Ch1)
image.db<-data.frame(code=extract.nochannel.name(Ch1), animal, slice, timepoint)
image.db$NumMicroglia<-"0"
image.db$NumCcl3<-"0"
image.db$NumCo<-"0"

#Run a loop to call Fiji for pairs of images, using Channel1 as a reference.ERROR? 
for(i in 1:length(Ch1)) {
  image1<-grep(Ch1, pattern=image.db$code[i], value=T)
  image2<-grep(Ch2, pattern=extract.nochannel.name(image1), value=T)
  images<-paste(image1, image2, sep = "*")
  system(paste0(command,images))
  
  #Extract the desired information from the data file for each image pair (assuming Ch1 is your reference stain)
  data<-read.csv(file = "summary.csv", header = T)
  image.db$NumMicroglia[i]<-data[1,2]
  image.db$NumCcl3[i]<-data[2,2]
  image.db$NumCo[i]<-data[3,2]
}

#Save image.db and remove the AND and summary files.
saveRDS(object = image.db, file = "image.db.rds")
file.remove("summary.csv")

#Test the above with a manual comparision 


#Save image.db and use it to plot 

