#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Author: Yuting Ma       edited: Zac
### Project 3
### ADS Spring 2016

setwd("F:/CU Textbooks And Related Stuff/STAT W4249/Project3")
library(png)
library(BBmisc)
library(readbitmap)

feature <- function(img_dir, file_names,feature_method ,data_name=NULL){
             ### Construct process features for training/testing images
             ### Sample simple feature: Extract raw pixel values os features
             
             ### Input: a directory that contains images ready for processing
             ###img_dir the path
             ###img_name name of picture 
             ###feature_method c(names, parameters)
             ### Output: an .RData file contains processed features for the images
             
             ### load libraries
             library("EBImage")
         
             #img_dir <- "../data/zipcode_train/"
             #img_name <- "img_zip_train"
             ######################
         
             n_files <- length(file_names)
             image_name<-0
                 ### determine img dimensions
                 #img0 <-  readImage(file_names[1])
                 
                ### store vectorized pixel values of images
                dat <- array(dim=c(n_files,feature_method[1]*feature_method[2]*feature_method[3]+1))
                 for(i in 1:n_files){
                             if (sum(grep(".jpg",file_names[i]))==0){
                                     dat[i,] <- NA
                             }
                            else{
                                 
                                     if(!is.na(image_type(paste0(img_dir,file_names[i])))){
                                         ImageTp<-image_type(paste0(img_dir,file_names[i]))
                                         if(ImageTp=="png"){
                                             img <- readPNG(paste0(img_dir,file_names[i]))
                                             }
                                         else{
                                                 img <- readImage(paste0(img_dir,file_names[i]))
                                             }
                                         img <-resize(img,256,256)
                                         img_name<-file_names[i]
                                             v<-color_hist(img,img_name,feature_method[1],feature_method[2],feature_method[3])
                                             if (i%%100 == 0){
                                                     print(i)
                                                }
                                             
                                                dat[i,] <- v
                                               
                                              }
                             }
                     }
                 
                     ### output constructed features
                     if(!is.null(data_name)){
                             save(dat, file=paste0("./output/feature_", data_name, ".RData"))
                         }
                 return(dat)
             }

###color feature 
color_hist <- function(img,img_name,nR,nG,nB){
    mat <- imageData(img)
    # Caution: the bins should be consistent across all images!
    rBin <- seq(0, 1, length.out=nR)
    gBin <- seq(0, 1, length.out=nG)
    bBin <- seq(0, 1, length.out=nB)
    
    if (length(dim(mat))==3){
        
        freq_rgb <- as.data.frame(table(factor(findInterval(mat[,,1], rBin), levels=1:nR), 
                                        factor(findInterval(mat[,,2], gBin), levels=1:nG), 
                                        factor(findInterval(mat[,,3], bBin), levels=1:nB)))
    }else {
        freq_rgb <- as.data.frame(table(factor(findInterval(mat, rBin), levels=1:nR), 
                                        factor(findInterval(mat, gBin), levels=1:nG), 
                                        factor(findInterval(mat, bBin), levels=1:nB)))
    }
    rgb_feature <- as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
    rgb_feature<-c(img_name,rgb_feature)
    return (rgb_feature) 
} 