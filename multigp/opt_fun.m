%Function to be optimised to evaluate parameters from the emulator

function loss=opt_fun(pars,true_dat,hyps,B_gls,H,kernel,data,A_inv)
    out_sam=pred_mean(pars,hyps,B_gls,H,kernel,data,A_inv);
    if size(out_sam)~=size(true_dat)
        out_sam=out_sam';
    end
    loss=sqrt(sum((out_sam-true_dat).^2));
  end
