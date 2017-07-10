function y = cons(x, a)
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


if isa(a, 'deriv') && ~isa(x, 'deriv')
    y = deriv(x);
elseif isa(a, 'derivS') && ~isa(x, 'derivS')
    y = derivS(x);
elseif isa(a, 'derivspj') && ~isa(x, 'derivspj')
    y = derivspj(x);
elseif isa(a, 'derivsph') && ~isa(x, 'derivsph')
    y = derivsph(x);
elseif isa(a, 'derivtape') && ~isa(x, 'derivtape')
    y = derivtape(x,0);
elseif isa(a, 'derivH') && ~isa(x, 'derivH')
    y = derivH(x);
elseif isa(a, 'derivtapeH') && ~isa(x, 'derivtapeH')
    y = derivtapeH(x,0);
else
    y = x;
end
    
