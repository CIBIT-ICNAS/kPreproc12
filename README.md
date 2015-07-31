# kPreproc12

-These scripts support preprocessing of fMRI data. —They transform dicoms into normalized & smoothed nifti files, and include several quality assurance steps.

#Dependencies:

-SPM8

-SPM12

-from the wagerlab: SCN_Core_Support and diagnostics toolboxes (http://wagerlab.colorado.edu/tools)

-spm-u+ from Cyril Pernet: www.sbirc.ed.ac.uk/cyril/downloads

-kTools: github.com/kbraunlich/kTools


##Steps
Create File Structure
-edit and run a__makeDirs.m. This will create the necessary file structure in an existing folder.

Import Dicoms
- open and edit the two files in the A_Import folder. These scripts convert the anatomical and functional dcm files to nii. They also rename the images and move them to appropriate folders. 

-this step also drops unwanted volumes from the beginning of each functional run. The nDropped should also be included in a__preproc.

a__PREPROC.m
This is the primary script for the toolbox. It will guide you through manual alignment of the imported nii’s, automate all remaining steps through smoothing, and then guide you through manual quality control of coregistration. QC info can be found in the sub qc directories (e.g. s001/r1/qc).

TO RUN:
-open and edit the “settings” section in a__PREPROC.m. For a new study, you might run in cell mode for a single participant, edit 'subs', and then batch the rest.

#Note about manual alignment:
- SPM is quite good at segmentation and normalization given rough initial alignment (origin on the AC, and proper orientation along planes (sagittal= acpc plane) ). Accordingly, the first thing the script will do is open the SPM gui and load the first anatomical image. (Read the spm manual for how to use it). 

- After entering appropriate parameters, reorient all, and select every image for that sub (anat and all functionals for all runs). The script will then run for a while. You need to press enter in the command window before it brings up the next anat.

- It is generally good practice to check alignment of the anat and funcs (1 per run) after each sub. --I use mricron.
