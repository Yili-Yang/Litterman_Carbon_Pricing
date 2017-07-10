function n=length(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp
n.val=length(x.val);
n.deriv=zeros(1,globp);
n=class(n,'deriv');
