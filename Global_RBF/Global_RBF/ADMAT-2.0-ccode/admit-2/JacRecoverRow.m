  function[f,Jout] = JacRecoverRow(fun,x,Extra,m,verb,JPI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate sparse Jacobian matrix J by one-sided row method
%
% INPUT:
%  fun: Integer Handle for the function.
%   x: Estimate J at the current point x.
%   Extra: parameters to be used in the function, "fun".
%   m: size of the function
%   verb: switch for the display level
%   JPI: the sparse matrix structure of the Jacobian
%
% OUTPUT
%   f : function value at x
%   Jout : Jacobian matrix of 'fun' at x
%
%   
%  04/2007 -- reorganized the program for readibility
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n=length(x);
 n=length(x);
if nargin < 6
    JPI=[];
end

if isempty(JPI)
    JPI=getJPI(fun,m,n,Extra,'r');
end
J=JPI.SPJ;
group=JPI.group;
m=size(J,1);
if isempty(verb) verb=0; end
if (verb >=1)
    disp(sprintf('Number of Row groups = %d',max(group)));
end
if (verb >= 2)
    subplot(1,1,1)
    spy(J);
    title 'Sparsity Structure of J'
end

ncol = max(group);
W = zeros(m,ncol);
for k = 1:ncol
    W(:,k) = (group == k);
end


if ncol > 0
    [f,WtJ] =revprod(fun,x,W,Extra);
else
    f=funcvalJ(fun,x,m,Extra);
end

[i, j]=find(J);
group(logical(group==0))=ones(length(find(group==0)),1);
Jout = sparse(i,j,WtJ((group(i)-1)*n + j),m,n);

