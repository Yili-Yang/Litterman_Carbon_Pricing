function sout=coth(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

sout.val=coth(s1.val);
sout.varcount=varcounter;

sout=class(sout,'derivtape');

savetape('coth',sout,s1.varcount);
