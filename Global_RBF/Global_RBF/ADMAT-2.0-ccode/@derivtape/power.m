function sout=power(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;
if ~isa(s1,'derivtape')
sout.val=s1.^s2.val;
sout.varcount=varcounter;
sout=class(sout,'derivtape');
savetape('power',sout,s1,s2.varcount,-1);

elseif ~isa(s2,'derivtape')
sout.val=s1.val.^s2;
sout.varcount=varcounter;
sout=class(sout,'derivtape');
savetape('power',sout,s1.varcount,s2,-2);

else
sout.val=s1.val.^s2.val;
sout.varcount=varcounter;
sout=class(sout,'derivtape');
savetape('power',sout,s1.varcount,s2.varcount);
end
