function sout=diff(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if nargin > 1
    error('Reverse mode dose not support more than two input argements');
end
sout.val=diff(s1.val);
sout.varcount=varcounter;

sout=class(sout,'derivtape');

savetape('diff',sout,s1.varcount);
