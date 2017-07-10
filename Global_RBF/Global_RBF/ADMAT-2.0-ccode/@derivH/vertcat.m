function sout=vertcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


s1=varargin{1};
sout=s1;
for i=2:nargin
    s2=varargin{i};
    s2=derivH(s2);
    newval=[sout.val;s2.val];
    [p,q]=size(sout.val);
    [p1,q1]=size(s2.val);
    newval=derivH(newval);
    
    if p==1 && q~=1
        if p1==1 || q1==1
            if p1==1
                newval.derivH=[sout.derivH';s2.derivH'];
            else
                newval.derivH=[sout.derivH';s2.derivH];
            end
        else
            newval.derivH=[sout.derivH';s2.derivH];
        end
    elseif p1==1 && q1~=1
        if p==1 || q==1
            newval.derivH=[sout.derivH;s2.derivH'];
        else
            newval.derivH=[sout.derivH;s2.derivH'];
        end
    else
        newval.derivH=[sout.derivH;s2.derivH];
    end
    sout=newval;
end

