function sout=vertcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

s1=varargin{1};
sout=derivspj(s1);

for i=2:nargin
    s2=varargin{i};
    s2=derivspj(s2);
    newval=[sout.val;s2.val];
    [p,q]=size(sout.val);
    [p1,q1]=size(s2.val);
    newval=derivspj(newval);

    if p==1 && q~=1
        if p1==1
            
            for j = 1 : globp 
                newval.derivspj{j}=[sout.derivspj(:,j)';s2.derivspj(:,j)']; 
            end
        else
            for j=1:globp  
                newval.derivspj{j}=[sout.derivspj(:,j)';s2.derivspj{j}];
            end
        end

    elseif p1==1 && q1~=1
        if p==1 || q==1
            for j=1:globp 
                newval.derivspj{j}=[sout.derivspj(:,j)';s2.derivspj(:,j)']; 
            end
        else
            for j=1:globp 
                newval.derivspj{j}=[sout.derivspj{j};s2.derivspj(:,j)']; 
            end
        end

    else

        if (p==1 || q==1) && (p1==1 || q1==1)
            newval.derivspj=[sout.derivspj;s2.derivspj];
        elseif (p==1 || q==1)
            for j=1:globp
                newval.derivspj{j}=[sout.derivspj(:,j);s2.derivspj{j}]; 
            end

        elseif (p1==1 || q1==1)
            for j=1:globp
                newval.derivspj{j}=[sout.derivspj{j};s2.derivspj(:,j)];
            end

        else
            for j=1:globp 
                newval.derivspj{j}=[sout.derivspj{j};s2.derivspj{j}];
            end

        end

    end
    sout=newval;
end