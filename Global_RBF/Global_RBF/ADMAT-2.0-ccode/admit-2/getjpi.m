function [PartInfo,SPJ]= getjpi(fun, m, n, Extra, method, SPJ)
%
%GetJPI 
%       Compute sparsity and coloring information for sparse Jacobians.
%       This is really useful for efficiency of the  computing sparse
%       Jacobians with evalJ, because once computed sparsity and coloring
%       Information can be saved once for all. 
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       PartInfo = GetJPI(fun,m,n)  computes  sparsity + coloring Info for m xn J.
%
%       Please refer to ADMIT users manual for complete reference. 
%       
%       Extra contains extra matrix argument for user's function. See users manual
%       for reference
%
%       ALSO SEE evalJ, dispJPI
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if (nargin < 2) error('need at least 2 input arguments'); end
if nargin < 3 n=m; end
if nargin < 4 Extra=[]; end
if nargin < 5 method =[]; end
if nargin < 6 SPJ=[]; end
if isempty(method) method='d'; end
if isempty(n) n=m; end

if isempty(SPJ)
    SPJ=jacsp(fun,m,n,Extra);
end
SPJ=spones(SPJ);
m=size(SPJ,1);
if isequal(n,1)
    PartInfo.SPJ=spones(m,1);
    PartInfo.group= 1;
    if ~isequal(method,'f')
        PartInfo.method= 'c';
    else
        PartInfo.method='f';
    end
elseif isequal(m,1)
    PartInfo.SPJ=sparse(ones(1,n));
    PartInfo.group= 1;
    if ~isequal(method,'f')
        PartInfo.method= 'r';
    else
        PartInfo.method='f';
    end
else
    %SPJ=spones(SPJ);
    if (method =='d')
        PartInfo=partmex(SPJ);
    elseif (method =='s')
        PartInfo=partsubmex(SPJ);
    elseif ((method =='c') || (method =='f'))
        H=spones(SPJ'*SPJ);
        p=id(H,full(sum(H)));
        g=colorHess(H,p);
        PartInfo.SPJ=SPJ;
        PartInfo.group= g;
    else
        H=spones(SPJ*SPJ');
        p=id(H,full(sum(H)));
        g=colorHess(H,p);
        PartInfo.SPJ=SPJ;
        PartInfo.group= g;
    end
    PartInfo.method= method;
end
