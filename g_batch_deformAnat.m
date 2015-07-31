

function g_batch_deformAnat(subs,~,mriFldr)



for s=1:numel(subs)
    sub=subs(s);
    anat_dfrm=filenames([mriFldr '/s' sprintf('%3.3d',sub) '/anat/y_s' sprintf('%3.3d',sub) '*.nii'],'char');
    maskedAnat=filenames([mriFldr '/s' sprintf('%3.3d',sub) '/anat/mask*.nii'],'char');
    
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = cellstr(anat_dfrm);
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(maskedAnat);
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
    
    
    
    

    spm_jobman('run', matlabbatch);
end

