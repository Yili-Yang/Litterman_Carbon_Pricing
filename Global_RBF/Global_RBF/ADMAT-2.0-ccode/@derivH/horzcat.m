function sout=horzcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


s1=varargin{1};
s1=derivH(s1);
sout=s1;
for i=2:nargin
    s2=varargin{i};
    s2=derivH(s2);
    m = size(sout.val,1);
    sout.val=[sout.val s2.val];
    if (m==1)
        sout.derivH=[sout.derivH; s2.derivH];
    else
        sout.derivH=[sout.derivH s2.derivH];
    end
end
