%Code for multioutput emulator found in paper by O'Hagan and Toni
%Closed form emulation solution where hyperparameters may be sampled by MCMC
%or optimised. Where MCMC is used, samples must be provided to this script.
%train_par is emulator input points
%train_sim simulator points for emulator design
%gp_ker is kernel to be used for cross simulation correlation
%sample directory is where MCMC samples should be saved.



function varargout=multiout(train_par,train_sim,gp_ker,...
                            method,use,test_point,varargin)
  D=train_sim; %simulations for emulator design
  des_points=train_par; %input points for emulator design
  data={des_points,D};
  size(D);
  size(des_points);

  if size(des_points,1)~=size(D,1)
      error('no one to one pairing of design points and simulations')
  end
  switch method
      case 'mcmc' %if chosen method for finding the roughness hyperparameter is to sample using MCMC
          hyp_time=tic;
          num_starts=varargin{1} %number of initialisations of MCMC sampling from posterior. Higher value ensures more sure convergence when checking PSRF
          num_iterations=varargin{2} %number of mcmc iterations. Burnin will end at num_iterations/2
          routine=varargin{3} %chosen mcmc routine for sampling. So far code only uses simple MH.
          p=sobolset(4,'Skip',1000); %creating start points for MCMC, skipping the first 1000 points to allow sobol to warm-up
          inits=net(p,num_starts); %initial points for multiple MCMC runs
          inits=log(inits*(5-0.1)+0.1);
          samples=zeros(num_iterations/2,size(train_par,2),num_starts);
          accepts=[];
          chains=[];
          kernel=gp_ker;
            for i=1:num_starts %i is index of initialisation. This should be parallelised for multiple chains but for used here for suitability on all machines
                init=inits(i,:);
                [sample, acceptance]=posterior_sampling(init, num_iterations,...
                kernel,data,'mh',@hyp_prior,0.09);
                samples(:,:,i)=sample((num_iterations/2+1):end,:);
                burnin(:,:,i)=sample(1:(num_iterations/2),:);
                chains(:,:,i)=sample;
                accepts(i)=acceptance;
            end %ending run of multiple MCMC chains for sampling the roughness parameters
            %save(fullfile(sample_dir,strcat('Samples',num2str(ind_test))), 'samples','accepts','burnin')
            if sum(accepts<0.15)>1
                warning('some mcmc acceptance lower than 0.15')
            elseif sum(accepts>0.3)>1
                warning('some acceptance rate higher than 0.3')
            else
                ;
            end %warnings based on MCMC acceptance
            psrf_val=psrf(chains)
            if psrf_val<1.1
                ;
            else
                warning('psrf of MCMC is not lower than 1.1')
            end
          em_hyp=median(exp(samples(:,:,num_starts))); 
          mytime=toc(hyp_time);
          %varargout{4}=chains;
      case 'optimize'
          hyp_time=tic;
          H=[ones(size(des_points,1),1) des_points];
          %em_hyp=fminunc(@(x) -hyp_posterior(x,data{1},...
          %data{2},gp_ker,H,@hyp_prior),log([.5 .5 .5 .5]))
          %options = optimset('TolFun', 1e-2);
          em_hyp=fmincon(@(x) -hyp_posterior(x,data{1},...
          data{2},gp_ker,H,@hyp_gam_prior),log([2 2 2 2]),[],[],[],[],[-10 -10 -10 -10],[1 1 1 1],@mycon);
          em_hyp=exp(em_hyp)
          mytime=toc(hyp_time);
     % case 'variational'


  end
  switch use %switching based on whether using nearest neighbours in function space...
      %or nearest neighbours in parameter space (want to add sparsity but requires
      %some method development)
    case 'function_local'
      %H=des_points';
      %H=[ones(1,size(des_points,1)); H]';
      H=[ones(size(des_points,1),1) des_points];
      A=zeros(size(D,1),size(D,1));
      for i=1:size(D,1)
          for j=1:size(D,1)
              A(i,j)=gp_ker([des_points(i,:); des_points(j,:)],em_hyp); %sim are being sampled on log scale so must correct here with exp(sim)
          end
      end

      A_inv=A\eye(size(A,1));
      mul=H'*A_inv*H;
      mul_inv=mul\eye(size(mul,1));
      mul=H'*A_inv*D;
      b_gls=mul_inv*mul;
      problem=createOptimProblem('fmincon','objective',@(x) opt_fun(x,test_point,...
      em_hyp,b_gls,H,gp_ker,data,A_inv),'x0',[1 1 1 1],'lb',[0.1 0.1 0.1 0.1],'ub', [5 5 5 5], 'nonlcon', @mycon);
      gs=GlobalSearch('NumTrialPoints',2000)
      [x]=run(gs,problem);


      varargout{1}=em_hyp;
      varargout{2}=mytime;
      varargout{3}=x
    case 'parameter_local'
        %H=des_points';
        %H=[ones(1,size(des_points,1)); H]';
        H=[ones(size(des_points,1),1) des_points];
        A=[];
        for i=1:size(D,1)
            for j=1:size(D,1)
                A(i,j)=gp_ker([des_points(i,:); des_points(j,:)],em_hyp); %sim are being sampled on log scale so must correct here with exp(sim)
            end
        end

        A_inv=A\eye(size(A,1));
        mul=H'*A_inv*H;
        mul_inv=mul\eye(size(mul,1));
        mul=H'*A_inv*D;
        b_gls=mul_inv*mul;
        loss=opt_fun(pars,true_dat,hyps,B_gls,H,kernel,data,A_inv)
  end
end
