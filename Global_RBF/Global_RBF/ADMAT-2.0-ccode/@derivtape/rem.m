function sout=rem(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

s1 = derivtape(s1,0);
s2 = derivtape(s2,0);

sout.val=rem(s1.val, s2.val);
sout.varcount=varcounter;

sout=class(sout,'derivtape');

savetape('rem',sout,s1.varcount,s2.varcount);
