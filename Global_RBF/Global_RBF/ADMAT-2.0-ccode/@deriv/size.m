function [m,n]=size(s1,p)
%
%
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

global globp;
if nargin==1
    if nargout ==2
        [m1,n1]=size(s1.val);
        m.val = m1;
        m.deriv = zeros(1,globp);
        m = class(m,'deriv');
%         m=deriv(m);
%         n=deriv(n);
        n.val = n1;
        n.deriv = zeros(1, globp);
        n = class(n,'deriv');
    else
        m1=size(s1.val);
        k = size(m1, 2);
        m.val = m1;
        m.deriv = zeros(k, globp);
        m = class(m, 'deriv');
    end
else
    m1=size(s1.val,p);
    m.val = m1;
    m.deriv = zeros(1, globp);
    m = class(m,'deriv');
end
