%Run a metropolis hastings sampler for sampling roughness parameters

function varargout=methast(varargin)
  initial_point=varargin{1}; jump=varargin{2}; iterations=varargin{3};
  myposterior=varargin{4};burnin=varargin{5};des_points=varargin{6};
  simulations=varargin{7};kernel=varargin{8};H=varargin{9};prior=varargin{10};
  samples=[];
  oldpoint=initial_point;
  oldposterior=myposterior(oldpoint,des_points,simulations,kernel,H,prior);
  samples(1,:)=oldpoint;
  for i=2:iterations
      newpoint=oldpoint+normrnd(0,jump,size(initial_point));
      newposterior=myposterior(newpoint,des_points,simulations,kernel,H,prior);
      alpha=log(rand(1));
      myratio=newposterior-oldposterior;
      if myratio>alpha
          samples(i,:)=newpoint;
          oldpoint=newpoint;
          oldposterior=newposterior;
      else
          samples(i,:)=oldpoint;
      end
  end
  uniquerows = size(unique(samples,'rows'), 1);
  perct_accept=uniquerows/iterations;
  varargout{1}=samples;
  varargout{2}=perct_accept;
end
