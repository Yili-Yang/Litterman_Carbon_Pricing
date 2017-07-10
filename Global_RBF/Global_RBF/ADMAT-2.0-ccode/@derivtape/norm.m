function sout=norm(s1,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;
if nargin < 2
    p = 2;
end
sout.val=norm(s1.val, p);
sout.varcount=varcounter;
sout=class(sout,'derivtape');
savetape('norm',sout,s1.varcount, p);
