%Code for running the kernel function in the multioutput GP from Ohagan and Toni
%des_points should contain rows of inputs at which to evaluate kernel function
%pars should be a vector of roughness hyperparameters.

function varargout=SE_kernel(des_points, pars)
    val=exp(-(des_points(1,:)-des_points(2,:))*diag(pars)*(des_points(1,:)-des_points(2,:))');
    varargout{1}=val;
end
