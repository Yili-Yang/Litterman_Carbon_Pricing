function [numg]=numgrJ(PartInfo,method,n)
%
%numgrJ
%
%       Returns the total number of groups used in the partition
%       PartInfo returned by GetJPI
%
%       numg=numgrJ(PartInfo,'d',10) 
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


if nargin < 2 method ='d'; end
if nargin < 3 n=size(PartInfo,2)/2; end
if isempty(method) method ='d'; end
if isempty(n) n=size(PartInfo,2)/2; end


[m,n]=size(PartInfo);
m=m-1;
group=PartInfo(m+1,:);
numg=max(group);
numg=full(numg);
