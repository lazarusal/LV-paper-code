%Function to evaluate the predictive mean at a new sample point based on t process given from conti ohagan paper

function val=pred_mean(pars,hyps,B_gls,H,kernel,data,A_inv)
    h=[1 pars]';
    t=[];
    des_set=data{1};
    for i=1:size(des_set,1)
        t(i)=kernel([pars;des_set(i,:)],hyps);
    end

    if size(t,1)==1
        t=t';
    end
    val1=B_gls'*h;
    val2=(data{2}-H*B_gls)'*A_inv*t;
    val=val1+val2;
end
