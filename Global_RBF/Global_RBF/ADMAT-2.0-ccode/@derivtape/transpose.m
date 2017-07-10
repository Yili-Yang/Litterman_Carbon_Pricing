function sout=transpose(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

sout.val=s1.val';
sout.varcount=varcounter;

sout=class(sout,'derivtape');
savetape('transpose',sout,s1.varcount);
