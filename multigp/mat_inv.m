%function to compute the numerically unstable matrix inversion for multiple output gp

function varargout=mat_inv(mat_init)
  eps=double(1.0); %determine machine precision
  while 1 < 1 + eps
    eps=eps*0.5;
  end
  eps=eps*2;
  regular_term=0.001;
  while cond(mat_init)>1/eps*0.8
    regular_term=regular_term*1.1;
    mat_init=mat_init+regular_term*eye(size(mat_init));
  end
  my_inv=mat_init\eye(size(mat_init));
  varargout{1}=my_inv;
  varargout{2}=regular_term;
end
