function sout=exp(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

tmp = s1.val;
sout.val=exp(tmp);
sout.varcount=varcounter;

sout=class(sout,'derivtape');

savetape('exp',sout,s1.varcount);
