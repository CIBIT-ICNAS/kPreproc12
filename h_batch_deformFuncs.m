

function h_batch_deformFuncs(subs,runs,mriFldr,nFiles)


for s=1:numel(subs)
    sub=subs(s);
    anat_dfrm=filenames([mriFldr '/s' sprintf('%3.3d',sub) '/anat/y_s' sprintf('%3.3d',sub) '*.nii'],'char');
    
    for r=1:numel(runs)
        run=runs(r);
        run_fldr=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc'];
        fList=filenames([run_fldr '/ra*nii'],'char');
        
        matlabbatch{r}.spm.spatial.normalise.write.subj.def = cellstr(anat_dfrm);
        matlabbatch{r}.spm.spatial.normalise.write.subj.resample = cellstr(fList);
        matlabbatch{r}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{r}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
        matlabbatch{r}.spm.spatial.normalise.write.woptions.interp = 4;
        
        
    end
    
    spm_jobman('run', matlabbatch);
    
    %% move
    for r=1:numel(runs)
        run=runs(r);
        destDir=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/norm'];
        mkdir(destDir);
        movefile([mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc/wra*'],destDir);
        
    end
end
