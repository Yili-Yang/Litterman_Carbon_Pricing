function sout=det(s1)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

sout.val=det(s1.val);
iA=inv(s1.val);

for i=1:globp
    sout.deriv(:,i)=sout.val*trace(iA*s1.deriv(:,:,i));
end

sout=class(sout,'deriv');
