function [f,J]=evalj(fun,x,Extra,m,JPI,verb,stepsize)
%
%evalJ	Compute Sparse Jacobian Via AD
%       evalJ is part of ADMIT toolbox. It computes sparse Jacobian
%       of a general nonlinear mapping.       
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       f=evalJ(fun,x)  computes just the function value at point x, the 
%                       is assume to return same number of output variables as in x.
%       [f,J]=evalJ(fun,x) Also computes the n x n sparse Jacobian at x.
%       
%       if the function uses the argument Extra, then the ful described in ADMIT user guide
%       Please refer to ADMIT users manual for complete reference. 
%       
%       JPI argument can be used to efficient execution. SEE GetJPI, dispJPI
%       Extra contains extra matrix argument for user's function. See users manual
%       for reference
%
%	ALSO SEE evalH
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

n=length(x);
if nargin < 2 error('Need at least Two input Arguments. see help evalJ'); end
if nargin > 7 error('Need at most seven input Arguments. see help evalJ'); end
if nargin < 3 Extra=[]; end
if nargin < 4 m=[]; end
if nargin < 5 JPI = []; end
if nargin < 6 verb = []; end
if nargin < 7 stepsize = []; end

if isempty(m) m=n; end
if isempty(verb) verb=0; end

if isempty(stepsize) stepsize=1e-5; end
if (nargout==1)
f=funcvalJ(fun,x,m,Extra);
end

% Call the appropriate Jacobian Computing device
if nargout > 1
    if length(x)~=1
        if isempty(JPI)
            JPI=getjpi(fun,m,n,Extra,'c');       
        end
        if (JPI.method=='d')
            [f,J]=JacRecoverDir(fun,x,Extra,m,verb,JPI);
        elseif (JPI.method=='s')
            [f,J]=JacRecoverSub(fun,x,Extra,m,verb,JPI);
        elseif (JPI.method=='c')
            [f,J]=JacRecoverCol(fun,x,Extra,m,verb,JPI);
        elseif (JPI.method=='r')
            [f,J]=JacRecoverRow(fun,x,Extra,m,verb,JPI);
        else
            [f,J]=JacRecoverSFD(fun,x,Extra,m,verb,JPI,stepsize);
        end
    else
        [f,J]=forwprod(fun,x,1,m,Extra);
    end
end
