function [Y,I]=sort(x,dim)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin ==2
    [Y.val,II]=sort(x.val,dim);
else
    [Y.val,II]=sort(x.val);
end

Y.derivS=x.derivS(II);
Y=class(Y,'derivS');

if nargout==2 
    I=II;
end
