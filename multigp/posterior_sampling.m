%MCMC sampling from the approximate posterior distribution of the kernel hyperparameters.
%This is found in eq. 8 of the original paper.
%Function takes as input:

function varargout=posterior_sampling(inits,iterations,kernel,training_dat,method,prior,varargin)
  inputs=training_dat{1};
  D=training_dat{2};
  if method=='mh'
  jump=varargin{1};
  H=inputs';
  H=[ones(1,size(inputs,1)); H]';

  [sample acceptance]=methast(inits,jump,iterations,@hyp_posterior,iterations/2,inputs,D,kernel,H,prior);
  %save(strcat('/home/alan/PhD/data/rssc_emulation/integrated/sampled_roughness/sample',num2str(ind)),'sample')
  varargout{1}=sample;
  varargout{2}=acceptance;
  end
end
