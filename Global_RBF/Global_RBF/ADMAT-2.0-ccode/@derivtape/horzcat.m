function sout=horzcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

s1=varargin{1};
s1=derivtape(s1,0);
sout=s1;
if nargin > 1
    for i=2:nargin
        s2=varargin{i};
        s2=derivtape(s2,0);
        sout.val=[s1.val s2.val];
        s1=sout;
        sout.varcount=varcounter;
        savetape('horzcat',sout,s1.varcount,s2.varcount);
    end
    
end
