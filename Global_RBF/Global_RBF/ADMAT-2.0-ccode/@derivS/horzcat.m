function sout=horzcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=varargin{1};
s1=derivS(s1);
sout=s1;

for i=2:nargin
    s2=varargin{i};
    s2=derivS(s2);
    % [m2,n2]=size(s2.val);
    m=size(sout.val,1);
    sout.val=[sout.val s2.val];
    if (m==1)
        sout.derivS=[sout.derivS; s2.derivS];
    else
        sout.derivS=[sout.derivS s2.derivS];
    end
end
