function y = consitent(x, a)
%
%    Let input x have the same data type with a
%  
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%
global globp;
global tape;
global varcounter;

if isa(a, 'deriv')
    y = deriv(x, eye(globp));
elseif isa(a, 'derivS')
    y = derivS(x);
elseif isa(a, 'derivspj')
    y = derivspj(x);
elseif isa(a, 'derivsph');
    y = derivsph(x);
elseif isa(a, 'derivtape')
    y = derivtape(x,0);
elseif isa(a, 'derivH')
    y = derivH(x);
elseif isa(a, 'derivtapeH')
    y = derivtape(x,0);
else
    y = x;
end
    
