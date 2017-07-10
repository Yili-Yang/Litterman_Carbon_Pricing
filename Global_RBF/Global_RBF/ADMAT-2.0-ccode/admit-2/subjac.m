function [Jout]= sunjac(fun,SPJ,x,verb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Returns jacobian given struture, using substitution
%
%
%	fun : handle to the function
%       x= Current Point
%       SPJ=Sparsity Pattern
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[m,n]=size(SPJ);

% Partition the Matrix and form the groups.

[o,rc,SPJr,SPJc,gr,gc]=partsubmex(SPJ);
if isempty(verb) verb=0; end
if (verb >=1)
    disp(sprintf('Number of Row groups = %d',max(gr)));
    disp(sprintf('Number of column groups = %d',max(gc)));
    disp(sprintf('Total Number of groups = %d',max(gc)+max(gr)));
end
if (verb >= 2)
    subplot(2,2,1);
    spy(SPJ);
    title 'Sparsity Structure of J'
    subplot(2,2,2);
    spy(SPJr);
    title 'Jr: Part computed by reverse AD'
    subplot(2,2,3);
    spy(SPJc);
    title 'Jc: Part computed by forward AD'
end

Jout=JacRecoverSub(fun,x,SPJ,SPJc,SPJr,[gc gr],o,rc);
