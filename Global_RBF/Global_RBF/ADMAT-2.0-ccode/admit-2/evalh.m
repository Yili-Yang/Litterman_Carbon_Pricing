function [val,grad,H]=evalh(fun,x,Extra,HPI,verb)
%
%evalJ  Compute Sparse Hessians Via AD
%       evalH is part of ADMIT toolbox. It computes sparse Hessian
%       of a general scalar nonlinear mapping.        
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       val=evalH(fun,x)  computes just the function value at point x. 
%       [val,grad]=evalH(fun,x) Also computes the n x 1 gradient at x.
%       [val,grad,H]=evalH(fun,x) Also computes the n x n
%                    sparse Hessian matrix at x.
%
%       Please refer to ADMIT users manual for complete reference. 
%       
%       HPI argument can be used to efficient execution. SEE GetHPI,dispHPI 
%       Extra contains extra matrix argument for user's function. See users manual
%       for reference
%
%       ALSO SEE  evalJ
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end
  
  if nargin < 2 error('Need at least Two input Argument. see help evalH'); end
  if nargin > 6 error('Need at most seven input Arguments. see help evalJ');
  end

  if nargin < 3 Extra=[]; end
  if nargin < 4 HPI = []; end
  if nargin < 5 verb = 0; end
  if nargin < 6 stepsize = []; end

  if isempty(stepsize) stepsize=1e-5; end	
  % MEX routine #1
  if(nargout==1)
	  val=funcval(fun,x,Extra);
  else
	  [val,grad]=funcval(fun,x,Extra);
  end
  % MEX routine #2
  if nargout > 2
		if length(x)~=1
		  H=HessRecover(fun,x,Extra,verb,HPI);
		  % Make it numerically symmetric
		  H=(H+H')/2;
		else
		H =HtimesV(fun,x,1,Extra);
		end
  end
