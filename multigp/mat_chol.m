%fuction to evaluate the cholesky decomposition in cases where mat_init is not positive definite
function varargout=mat_chol(mat_init)
  regular_term=0.000001;
  eigs=eig(mat_init);
  test_val=sum(eigs>0);
  [~,ind]=chol(mat_init);
   ind~=0
  while test_val~=numel(eigs) | ind~=0
    regular_term=regular_term*1.01;
    mat_init=mat_init+regular_term*eye(size(mat_init));
    eigs=eig(mat_init);
    test_val=sum(eigs>0);
    [~,ind]=chol(mat_init);
    %[~,ind]=chol(mat_init);
  end
  inv_poss=0;
  while inv_poss==0
    try
      my_inv=chol(mat_init,'lower');
      inv_poss=1;
    catch
      mat_init=mat_init+regular_term*eye(size(mat_init))
      regular_term=regular_term*1.01;
    end
  end
  varargout{1}=my_inv;
  varargout{2}=regular_term;
end
