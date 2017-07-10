function sout=sum(s1, dim)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if nargin < 2
    dim = 1;
end
sout.val=sum(s1.val, dim);
sout.val = squeeze(sout.val);
sout.varcount=varcounter;

sout=class(sout,'derivtape');

savetape('sum',sout,s1.varcount, dim);
