function sout=plus(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if (~isa(s2,'derivtape'))
    sout.val=s1.val+s2;
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('plus',sout,s1.varcount,s2, -2);
elseif  (~isa(s1,'derivtape'))
    sout.val=s1+s2.val;
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('plus',sout,s1,s2.varcount,-1);
else
    sout.val=s1.val+s2.val;
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('plus',sout,s1.varcount,s2.varcount);
end
