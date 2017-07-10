function sout=vertcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=varargin{1};
sout=derivS(s1);
for i=2:nargin
    s2=varargin{i};
    s2=derivS(s2);
    newval=[sout.val;s2.val];
    [p,q]=size(sout.val);
    [p1,q1]=size(s2.val);
    newval=derivS(newval);
    if p==1 && q~=1
        if p1==1 || q1==1
            if p1==1
                newval.derivS=[sout.derivS';s2.derivS'];
            else
                newval.derivS=[sout.derivS';s2.derivS];
            end
        else
            newval.derivS=[sout.derivS';s2.derivS];
        end
    elseif p1==1 && q1~=1
        if p==1 || q==1
            newval.derivS=[sout.derivS;s2.derivS'];
        else
            newval.derivS=[sout.derivS;s2.derivS'];
        end
    else
        newval.derivS=[sout.derivS;s2.derivS];
    end
    sout=newval;
end

