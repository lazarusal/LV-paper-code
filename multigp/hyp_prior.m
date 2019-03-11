%Function to evaluate noninformative prior for roughness hyperparameter
function varargout=hyp_prior(pars)
  pars=exp(pars);
  myvec=arrayfun(@inv,1+pars.^2);
  varargout{1}=prod(myvec)*prod(pars);
end
