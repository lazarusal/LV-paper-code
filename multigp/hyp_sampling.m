function val=hyp_sampling(train_par,train_sim,gp_ker,sample_dir,emulator_dir,varargin)
    NUMBERINDICATOR = str2num(getenv('SGE_TASK_ID'));
    p=sobolset(4);
    num_starts=varargin{1};
    num_iterations=varargin{2};
    inits=net(p,num_starts); %initial points for multiple MCMC runs. Ideally these will all be run on different parallel processes but so far not been achievable
    inits=inits*(1-0.01)+0.01;
    inits=log(inits);
    init=inits(NUMBERINDICATOR,:);
    D=train_sim; %simulations for emulator design
    des_points=train_par; %input points for emulator design
    data={des_points,D}
    size(D)
    size(des_points)
    if size(des_points,1)~=size(D,1)
      error('no one to one pairing of design points and simulations')
    end %if chosen method for finding the roughness hyperparameter is to sample using MCMC
    num_starts=varargin{1} %number of initialisations of MCMC sampling from posterior. Higher value ensures more sure convergence when checking PSRF
    num_iterations=varargin{2} %number of mcmc iterations. Burnin will end at num_iterations/2

    p=sobolset(4);
    inits=net(p,num_starts); %initial points for multiple MCMC runs. Ideally these will all be run on different parallel processes but so far not been achievable
    inits=inits*(1-0.01)+0.01;
    samples=zeros(num_iterations/2,size(train_par,2),num_starts);
    accepts=[];
    kernel=gp_ker;
    [sample, acceptance]=posterior_sampling(init, num_iterations,kernel,data,'mh',@hyp_prior,0.08);
    burnin=sample(1:(num_iterations/2),:);
    accepts=acceptance;
    save(strcat('/home/alan/PhD/data/rssc_emulation/integrated/sampled_roughness/Samples',num2str(NUMBERINDICATOR)),'sample','burnin','accepts')
end
