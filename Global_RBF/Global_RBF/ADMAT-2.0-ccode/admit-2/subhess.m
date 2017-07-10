function [colors,o]= subhess(SPH)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

n =size(SPH,1);
o=id(SPH,full(sum(SPH)));
colors=zeros(n,1);
J=tril(SPH(o,o));
H1=spones(J'*J);
p1=id(H1,full(sum(H1)));
colors(o)=colorHess(H1,p1);

