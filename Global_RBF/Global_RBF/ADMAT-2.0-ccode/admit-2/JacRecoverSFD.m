  function[f,Jout] = JacRecoverSFD(fun,x,Extra,m,verb,JPI,stepsize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate sparse Jacobian matrix J by sparse finite
% differences.
%
% INPUT:
%  fun : Handle to the function
%   x: Estimate J at the current point x.
%   J: the sparse matrix structure of the Jacobian
%   group: group(i) = j means that column i belongs to group (or color)
%          j. Each group (or color) corresponds to a finite difference.
%
% OUTPUT:
%   J: the sparse Jacobian estimate.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=length(x);
 
if nargin < 6
JPI=[];
end

if isempty(JPI)
% Get the Sparsity Pattern of the Jacobian Matrix
JPI= getJPI(fun, m, n,Extra, 'f');
end
J=JPI.SPJ;
group=JPI.group;
if isempty(verb) 
    verb=0;
end
if (verb >=1)
        disp(sprintf('Number of SFD groups = %d',max(group)));
end
if (verb >= 2)
        subplot(1,1,1)
        spy(J);
        title 'Sparsity Structure of J'
end

  [m,n] = size(J); 
  ncol = max(group); 
  V = zeros(n,ncol);
  for k = 1:ncol
      V(:,k) = (group == k);
  end
  epsvec=stepsize.*ones(ncol,1);
  if ncol > 0
	  [f,v] =fdapprox(fun,x,V,m,epsvec,Extra);
  else
  	f=funcvalJ(fun,x,m,Extra);
  end
  [i, j]=find(J);
  group(logical(group==0))=ones(length(find(group==0)),1);
  Jout = sparse(i,j,v((group(j)-1)*m + i),m,n);

