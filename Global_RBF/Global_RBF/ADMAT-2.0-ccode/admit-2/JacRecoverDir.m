  function[f,Jout] = JacRecoverDir(fun,x,Extra,m,verb,JPI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Compute the Jacobian matrix of 'fun' by direct bicoloring method
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
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
% get the Sparsity Pattern of the Jacobian Matrix
n=length(x);
if nargin < 6
    JPI=[];
end

if isempty(JPI)
    JPI=getJPI(fun,m,n,Extra,'d');
end
SPJr=JPI.Jr;
SPJc=JPI.Jc;
gr=JPI.gr;
gc=JPI.gc;
% m=length(gr);
W=JPI.W;
V=JPI.V;
m=size(SPJr,1);
ncol=size(V,2);
nrow=size(W,2);

if isempty(verb)
    verb=0;
end
if (verb >=1)
    disp(sprintf('Number of Row groups = %d',max(gr)));
    disp(sprintf('Number of column groups = %d',max(gc)));
    disp(sprintf('Total Number of groups = %d',max(gc)+max(gr)));
end
if (verb >= 2)
    subplot(2,2,1);
    spy(SPJr+SPJc);
    title 'Sparsity Structure of J'
    subplot(2,2,2);
    spy(SPJr);
    title 'Jr: Part computed by reverse AD'
    subplot(2,2,3);
    spy(SPJc);
    title 'Jc: Part computed by forward AD'
end

Jr=sparse(m,n);
Jc=sparse(m,n);
f=[];
if (ncol > 0)
    % Call the ADMAT Driver to do forwardMode product
    [f,JV]=forwprod(fun,x,V,m,Extra);
    % Identify Elements
    [i, j]=find(SPJc);
    gc(logical(gc==0))=ones(length(find(gc==0)),1);
    Jc = sparse(i,j,JV((gc(j)-1)*m + i),m,n);
end



% Form the Matrix W, based on the coloring.
% W is a 0-1 Matrix
if (nrow > 0)
    % Call the ADMAT Driver to do ReverseMode product
    [f,WtJ] =revprod(fun,x,W,Extra);

    % Identify Elements
    gr(logical(gr==0))=ones(length(find(gr==0)),1);
    [i, j]=find(SPJr);
    Jr = sparse(i,j,WtJ((gr(i)-1)*n + j),m,n);
end
if isempty(f) 
    f=funcvalJ(fun,x,m,Extra); 
end
Jout=Jr+Jc;
