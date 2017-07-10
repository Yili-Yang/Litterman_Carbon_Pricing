function p = setxdot(q,V)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

p=q;

if (~isa(V,'derivtape'))
    V=derivtape(V,0);
end

p.deriv=V;
