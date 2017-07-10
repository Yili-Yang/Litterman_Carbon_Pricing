function [numg]=dispjpi(JPI,n,method,verb)
%
%dispJPI
%
%       Display sparsity and coloring information for sparse Jacobians
%       computed by GetJPI.
%
%       The level of output can be controlled by parameter verb.
%       verb = 0  => No display
%       verb = 1  => Number of groups are shown.
%       verb = 2  => The sparsity pattern of Hessian is also shown
%
%       dispJPI(PartInfo,1) 
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE evalJ, GetJPI
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin < 3 method ='d'; end
if nargin < 4 verb=1; end
if isempty(method) method ='d'; end
if isempty(verb) verb=1; end

if ((method=='s') | (method =='d'))
Jc=JPI.Jc;
Jr=JPI.Jr;
[m,n]=size(Jc);
nrow=size(JPI.W,2);
ncol=size(JPI.V,2);
numg=nrow+ncol; 
if (verb >=1)
        disp(sprintf('Size of the Jacobian = %dx%d',m,n));
        disp(sprintf('Number of Row groups = %d',nrow));
        disp(sprintf('Number of column groups = %d',ncol));
        disp(sprintf('Total Number of groups = %d',nrow+ncol));
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

else

J=JPI.SPJ;
[m,n]=size(SPJ);
numg=max(JPI.group); 
if (verb >=1)
        disp(sprintf('Size of the Jacobian = %dx%d',m,n));
        disp(sprintf('Number of Column groups = %d',max(group)));
end
if (verb >= 2)
        subplot(1,1,1)
        spy(J);
        title 'Sparsity Structure of J'
end

end
