function f_batch_create_maskedAnat(subs,mriFldr)

script_path=cd;
for s=1:numel(subs)
   sub=subs(s);
   file1=dir([mriFldr '/s' sprintf('%3.3d',sub) '/anat/s' sprintf('%3.3d',sub) '*.nii']);
   file2=dir([mriFldr '/s' sprintf('%3.3d',sub) '/anat/c1s' sprintf('%3.3d',sub) '*.nii']);
   file3=dir([mriFldr '/s' sprintf('%3.3d',sub) '/anat/c2s' sprintf('%3.3d',sub) '*.nii']);
   file4=dir([mriFldr '/s' sprintf('%3.3d',sub) '/anat/c3s' sprintf('%3.3d',sub) '*.nii']);
   
   matlabbatch{1}.spm.util.imcalc.input = {
      [mriFldr '/s' sprintf('%3.3d',sub) '/anat/' file1.name ',1']
      [mriFldr '/s' sprintf('%3.3d',sub) '/anat/' file2.name ',1']
      [mriFldr '/s' sprintf('%3.3d',sub) '/anat/' file3.name ',1']
      [mriFldr '/s' sprintf('%3.3d',sub) '/anat/' file4.name ',1']
      };
   
   matlabbatch{1}.spm.util.imcalc.output = ['masked_s' sprintf('%3.3d',sub) '.nii'];
   matlabbatch{1}.spm.util.imcalc.outdir = {[mriFldr '/s' sprintf('%3.3d',sub) '/anat/']};
   matlabbatch{1}.spm.util.imcalc.expression = 'i1.*(i2+i3+i4)';
   matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
   matlabbatch{1}.spm.util.imcalc.options.mask = 0;
   matlabbatch{1}.spm.util.imcalc.options.interp = 1;
   matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

   spm_jobman('run', matlabbatch);
end
