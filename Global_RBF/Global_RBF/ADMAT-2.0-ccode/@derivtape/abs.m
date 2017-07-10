function sout=abs(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

[m,n] = size(s1.val);

sout.val=abs(s1.val);

sout.varcount=varcounter;

sout=class(sout,'derivtape');

savetape('abs',sout,s1.varcount);
