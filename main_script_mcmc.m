%script to run the multiple output emulator with MAP estimate of the roughness hyperparameter.
%code currently written to run on SGE. Should be easily adapted for
%general use.

function main_script_mcmc(num_near)
    
    NUMBERINDICATOR = str2num(getenv('SGE_TASK_ID'));
    mult_out_paths;
    sav_dir_res=strcat('/home/alan/PhD/data/rssc_emulation/integrated/mcmc_results/k',num2str(n_near)); %please change accordingly
    sav_dir_rough=strcat('/home/alan/PhD/data/rssc_emulation/integrated/sampled_roughness/k',num2str(n_near)); %please change accordingly
    %%
    [Xtrain, ytrain, `, yTest] = loading_data('LV_emulator_nogeometry'); %loading the training set and test set
    %%   
    n_near=num_near;
    nnind=knnsearch(ytrain,yTest(NUMBERINDICATOR,:),'k',n_near);
    emul_time=tic;
    [opt_hyp, optim_time, inf_par]=multiout(Xtrain(nnind,:),ytrain(nnind,:),@SE_kernel, ...
    'mcmc','function_local', yTest(NUMBERINDICATOR,:),NUMBERINDICATOR,1,1000,'mh');
    mytime=toc(emul_time);

    if exist(sav_dir_rough,'dir')==7
      ;
    else
      mkdir(sav_dir_rough)
    end
    fileid=strcat(sav_dir_rough,'/rough',num2str(NUMBERINDICATOR),'.txt');
    fid=fopen(fileid,'a');
    fprintf(fid,num2str(opt_hyp));
    fprintf(fid,strcat('\n',num2str(optim_time)));
    fclose(fid);

    if exist(sav_dir_res,'dir')==7
      ;
    else
      mkdir(sav_dir_res)
    end

    fileid=strcat(sav_dir_res,'/Results',num2str(NUMBERINDICATOR),'.txt');
    fid=fopen(fileid,'a');
    fprintf(fid,num2str(inf_par))
    fprintf(fid,strcat('\n',num2str(mytime)))
    fprintf(fid,strcat('\n',num2str(optim_time+mytime)))
    fclose(fid)
end
