#!/bin/bash

#  N4BiasFieldCorrection.sh
#  
#
#  Created by Sarah Allarakhia on 18/06/2019.

old_folder=old_folder
n4_folder=n4_folder

cd ~/documents/SRTP/SBB/SBB_raw

#Test case only - must add outer for loop to run through all SBB0x directories
#See testingfiles.txt before starting

# Move CTframe into proc_folder -> should be within outer for loop, so replace SBB02 (x3) with looping through folder variable) ($folder"_processed")
proc_folder=~/documents/SRTP/SBB/SBB_processed/SBB02_processed
mkdir -p $proc_folder
find SBB02 -type f -name "*preopCTframe*"  -exec mv {} $proc_folder \;

for f in $(find SBB02 -type f -maxdepth 1 -name "*.nii");
do
   #N4BiasFieldCorrection
   old_folder=${f%/*.nii}
   old_name=${f#$old_folder/}
   n4_folder=$old_folder/N4_Correction
   n4_name=${old_name%.nii}_N4.nii

   mkdir -p $n4_folder

   N4BiasFieldCorrection -i ${f%} -o  $n4_folder/$n4_name -v
   Echo $old_name complete N4 correction.

   #ImageMath
   img_folder=$old_folder/Histo_Match
   img_name=${n4_name%.nii}_histo.nii

   mkdir -p $img_folder

   ImageMath 3 $img_folder/$img_name HistogramMatch $n4_folder/$n4_name ~/documents/SRTP/Scripts/HistoSourceImg/mni_icbm152_nlin_asym_09c/mni_icbm152_t2_tal_nlin_asym_09c.nii
   Echo $old_name complete Img correction.
 done


#After skull stripping, send all files to their respective processed folder
#proc_folder=~/documents/SRTP/SBB/SBB_processed/$old_folder"_processed"
#mkdir -p $proc_folder
