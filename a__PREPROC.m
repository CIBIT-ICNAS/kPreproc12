% kPreproc toolbox
% ======================================================
% this is the primary script to access toolbox functions. 
% see the README for instructions.
%
% kurt braunlich 2012

%% --------------
clear all;clear mex;clc
kSpmSwitch(12);
spm('defaults','fmri');
spm_jobman('initcfg');

%% Settings:
% -----------------------------------------
subs=[3:5 7:21 24:26 101];
runs=[1:3];                                  

nDropped=3;                                 % nVolumes dropped from beginning of each run
nFiles=428-nDropped;                        % nTotalVolumes-nDropped

TR=2;                                       % (seconds)
nSlices=33;                                 %
TA=TR-(TR/nSlices);                         %
refSlice=19;                                % 

% slice order -----------------
sliceOrder=[1:2:nSlices 2:2:nSlices];       % ascending interleaved
% sliceOrder=[nSlices:-2:1,nSlices-1:-2:1];   % descending interleaved
% sliceOrder=1:1:nSlices;                     % ascending
% sliceOrder=nSlices:-1:1;                    % descending
% -----------------------------

% smoothing:
fwhm=6;                                     % smoothing (scalar --assumes iso)
% segmentation:
seg.template= 'eastern';                    % 'eastern' or 'mni'
seg.saveDeformFields = [1 1];               % need at least [0 1] for this step.
% housecleaning:
ave_anat=2;                                 % 1= create averaged anat
q=2;                                        % 1= quit at end to allow sleep

home=pwd;
mriFldr='/Volumes/Sarapiqui/valueAcmltr/mriData/spm12';
script_fldr='/Volumes/Sarapiqui/valueAcmltr/scripts';
preproc_fldr=[ script_fldr '/kPreproc12' ];
addpath(preproc_fldr);

tic

%% manual alignment 
% -----------------------------------------
a_align(subs,mriFldr);
disp('alignment done')

%% STC
% -----------------------------------------
b_batch_stc(subs,runs,mriFldr,nFiles,refSlice,sliceOrder,TR,nSlices,TA)
disp('stc done')
close all

% %% MC (estimate and reslice)
% % -----------------------------------------
c_batch_mc(subs,runs,mriFldr,nFiles)
disp('mc done')
% 
% %% coregistration
% % -----------------------------------------
d_batch_coreg(subs,runs,mriFldr,nFiles,0,0)
disp('coreg done')


%% anatomical segmentation
% -----------------------------------------
e_batch_seg(subs,mriFldr,0,seg)
disp('seg done')

%% skull strip
% -----------------------------------------
f_batch_create_maskedAnat(subs,mriFldr);
disp('skull done')

%% deformation: anatomical
% % -----------------------------------------
g_batch_deformAnat(subs,runs,mriFldr);
disp('deform anat done')

%% deformation:  functional 
% -----------------------------------------
h_batch_deformFuncs(subs,runs,mriFldr,nFiles);
disp('deform funcs done')

%% smooth
% -----------------------------------------
i_batch_smooth(subs,runs,mriFldr,nFiles,fwhm);
disp('smooth done')

%% quality control
% -----------------------------------------
kSpmSwitch(8)
addpath(genpath('/Users/kurtb/Dropbox/kMat/tor/diagnostics'))
addpath(genpath('/Users/kurtb/Dropbox/kMat/KSPM/spm_u'))

for sub=subs
    for run=runs
        j_kQuality(mriFldr,sub, run)
        j_checkNorm(mriFldr,sub,run);
    end
    j_spike(mriFldr,sub,runs)
    cd(preproc_fldr)
end
close all
disp('quality assessment done')
kSpmSwitch(12)

%% compress folders
% -----------------------------------------
k_batch_zip(subs,runs,mriFldr)

%% check registration
% -----------------------------------------
l_batch_checkReg(subs,runs,mriFldr,nFiles)

%% create mean anatomical
% -----------------------------------------
% placed here for convenience. check qc first
if ave_anat==1
    cd(mriFldr)
    cd ..
    for i=1:numel(subs)
        sub=subs(i);
        imgs(i,:)=filenames([mriFldr sprintf('/s%3.3d/anat/wmasked_*.nii',sub)],'char')
    end
    spm_mean(imgs)
end
%%
toc
if q==1
    quit % allow wimoweh to sleep
end
