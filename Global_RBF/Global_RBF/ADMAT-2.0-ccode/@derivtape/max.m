function sout=max(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if ~isa(s1, 'derivtape')
    s1=derivtape(s1,0);
end
if nargin > 1
    if ~isa(s2, 'derivtape')
        s2=derivtape(s2,0);
    end
    sout.val=max(s1.val,s2.val);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('max',sout,s1.varcount,s2.varcount);
else
    sout.val=max(s1.val);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('max',sout,s1.varcount);
end
