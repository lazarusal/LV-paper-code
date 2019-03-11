%function to evaluate log posterior at each step of MCMC sampling

function [val]=hyp_posterior(sim,inputs, simulations,kernel,varargin)
  H=varargin{1}; prior=varargin{2};
  q=size(simulations,2);
  n=size(inputs,1);
  m=size(inputs,2)+1;
  D=simulations;
  A=zeros(size(D,1),size(D,1));
  for i=1:size(simulations,1)
      for j=1:size(simulations,1)
          A(i,j)=kernel([inputs(i,:); inputs(j,:)],exp(sim)); %sim are being sampled on log scale so must correct here with exp(sim)
      end
  end
  %b_gls=(H'*A\H)\H'*A\D;
  %s_gls=1/(n-m)*(D-H*b_gls)'*A\(D-H*b_gls);
  inv_A=mat_inv(A); %singularity issues
  mul=H'*inv_A*H;
  inv_mul=mat_inv(mul);
  G=inv_A-inv_A*H*(inv_mul)*H'*inv_A;
  AL=mat_chol(A); %computing cholesky lower decomposition to aid with stabilization of posterior calculation
  mulL=mat_chol(mul);
  DL=mat_chol(D'*G*D);
  %val=prior(sim)*det(A)^-(q/2)*det(mul)^-(q/2)*det(D'*G*D)^-((n-m)/2);
  val=log(prior(sim))-q*sum(arrayfun(@log,diag(AL)))-q*sum(arrayfun(@log,diag(mulL)))-(n-m)*sum(arrayfun(@log,diag(DL)));
end
