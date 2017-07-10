function [PartInfo,SPH]= gethpi(fun, n,Extra, method, SPH)
%
%GetHPI
%
%       Compute sparsity and coloring information for sparse Hessians.
%       This is really useful for efficiency of the  computing sparse
%       Hessians with evalH, because once computed sparsity and coloring
%       Information can be saved once for all.
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       PartInfo = GetHPI(fun,n)  computes  sparsity + coloring Info for nxn H.
%
%       Please refer to ADMIT users manual for complete reference.
%
%       Extra contains extra matrix argument for user's function. See users manual
%       for reference
%
%       ALSO SEE evalH, dispHPI
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if (nargin < 2)
    error('need at least 2 input arguments');
end
if nargin < 3
    Extra=[];
end
if nargin < 4
    method =[];
end
if (nargin < 5)
    SPH=[];
end
if isempty(method)
    method ='i-a';
end
if isempty(n)
    n =size(SPH,1);
end

if isequal(n,1)
    PartInfo.SPH=spones(1);
    PartInfo.group= 1;
    if ~isequal(method(3),'f')
        PartInfo.method='i-a';
    else
        PartInfo.method='i-f';
    end
else
    if isempty(SPH)
        SPH=hesssp(fun,n,Extra);
    end
    SPH=spones(SPH);

    if strcmp(method,'i-a') || strcmp(method,'i-f')
        [g,p]=ignhess(SPH);
        PartInfo.SPH=SPH;
        PartInfo.group=g;

    elseif strcmp(method,'d-a') || strcmp(method,'d-f')
        [g,o]=dirhess(SPH);
        PartInfo.SPH=SPH;
        PartInfo.group=g;
        PartInfo.o=o;
    else
        [colors,o]=subhess(SPH);
        PartInfo=sparse(n+2,n);
        PartInfo.SPH=SPH;
        PartInfo.group=colors;
        PartInfo.o=o;

    end
    PartInfo.method=method;
end
