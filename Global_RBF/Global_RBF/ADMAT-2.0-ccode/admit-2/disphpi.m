function [numg]=disphpi(HPI,verb)
%
%dispHPI
%       Display sparsity and coloring information for sparse Hessians
%       computed by GetHPI.
%
%       The level of output can be controlled by parameter verb.
%       verb = 0  => No display
%       verb = 1  => Number of groups are shown.
%       verb = 2  => The sparsity pattern of Hessian is also shown
%
%       dispHPI(PartInfo,1)
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE evalH, GetHPI
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin < 2 verb=1; end
  H=HPI.SPH;
  group = HPI.group;
  numg=max(group);
if (verb >=1)
        disp(sprintf('size of the Hessian %dx%d',n,n));
        disp(sprintf('Number of groups = %d',max(group)));
end
if (verb >= 2)
        subplot(1,1,1)
        spy(H);
        title 'Sparsity Structure of H'
end
 
