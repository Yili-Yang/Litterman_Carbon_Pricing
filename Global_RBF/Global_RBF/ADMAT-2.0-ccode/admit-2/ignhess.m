function [g,p]= ignhess(SPH)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

n =size(SPH,1);

H2=spones(SPH*SPH+speye(n));
p=id(H2,full(sum(H2)));
g=colorHess(H2,p);
