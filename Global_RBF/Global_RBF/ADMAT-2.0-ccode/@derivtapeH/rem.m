function sout=rem(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if (~isa(s1,'derivtapeH'))
    s1=derivtapeH(s1); 
end
if (~isa(s2,'derivtapeH'))
    s2=derivtapeH(s2); 
end

sout.val=rem(getval(s1),getval(s2));

sout.deriv=s1.deriv-timesvec(fix(s1.val./s2.val),s2.deriv);

sout=class(sout,'derivtapeH');
