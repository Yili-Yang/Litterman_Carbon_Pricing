  function [f,Jout] = JacRecoverSub(fun,x,Extra,m,verb,JPI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Compute the Jacobian matrix by substitution bicoloring
%
% INPUT:
%  fun : handle to the function
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
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=length(x);
if nargin < 6
    JPI=[];
end

if isempty(JPI)
    JPI= getJPI(fun, m, n,Extra,'s');
end
Jc=JPI.Jc;
Jr=JPI.Jr;
V=JPI.V;
W=JPI.W;
gr=JPI.gr;
gc=JPI.gc;
% o=JPI.order;
% rc=JPI.roworcol;
% rowcons=JPI.rowcons;
% colcons=JPI.colcons;
% invpermrow=JPI.invpermrow;
% invpermrow=JPI.invpermcol;
p=JPI.p;
p1=JPI.p1;
q=JPI.q;
A=JPI.A;
m=size(Jc,1);
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
    spy(Jr+Jc);
    title 'Sparsity Structure of J'
    subplot(2,2,2);
    spy(Jr);
    title 'Jr: Part computed by reverse AD'
    subplot(2,2,3);
    spy(Jc);
    title 'Jc: Part computed by forward AD'
end
JV = zeros(m,ncol);
WJ=zeros(n,nrow);
% Form AD products
if ncol >0
    [f,JV] =forwprod(fun,x,V,m,Extra);
end
if nrow >0
    [f,WJ] =revprod(fun,x,W,Extra);
end
if ((ncol==0)&&(nrow==0))
    f=funcvalJ(fun,x,m,Extra); 
end

if (ncol==0)
    gc(logical(gc==0))=ones(length(find(gc==0)),1);
    [i, j]=find(Jr);
    Jout = sparse(i,j,WJ((gr(i)-1)*n + j),m,n);
end

if (nrow==0)
%     gr(logical(gr==0))=ones(length(find(gr==0)),1);
    [i, j]=find(Jc);
    Jout = sparse(i,j,JV((gc(j)-1)*m + i),m,n);
end
if (ncol> 0) && (nrow > 0)
    JV=JV';
    WJ=WJ';
    b=[];
    if ncol> 0
        b=[b;reshape(JV,m*ncol,1)];
    end
    if nrow > 0
        b=[b;reshape(WJ,n*nrow,1)];
    end
    b=b(p1(p));
    Jflat=A\b;
    Jflat(q)=Jflat;
    [i,j]=find((Jr+Jc)');
    Jout=sparse(i,j,Jflat,n,m);
    Jout=Jout';
end
