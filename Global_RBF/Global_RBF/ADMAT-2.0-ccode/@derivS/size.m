function [m,n]=size(s1,p)
%
%  March, 2007 -- replace constructing a derivtape object
%                 with creating the derivtape class in oder
%                 to avoid implicit recusion in the constructor 
%                 of derivtape class.
%  
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin==1
    if nargout ==2
        [m1,n1]=size(s1.val);
        m.val = m1;
        m.derivS = 0;
        m = class(m, 'derivS');
        n.val = n1;
        n.derivS = 0;
        n = class(n, 'derivS');
    else
        m1=size(s1.val);
        m.val = m1;
        m.derivS = zeros(size(m1))';
        m = class(m, 'derivS');
    end
else
    m1 = size(s1.val,p);
    m.val = m1;
    m.derivS = 0;
    m = class(m,'derivS');
end
