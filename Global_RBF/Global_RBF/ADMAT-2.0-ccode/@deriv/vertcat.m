function sout=vertcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

s1=varargin{1};
sout=deriv(s1);

for i=2:nargin
    s2=varargin{i};
    s2=deriv(s2);
    newval=[sout.val;s2.val];
    [p,q]=size(sout.val);
    [p1,q1]=size(s2.val);
    newval=deriv(newval);

    if p==1 && q~=1
        if p1==1
            
            for j = 1 : globp 
                newval.deriv(:,:,j)=[sout.deriv(:,j)';s2.deriv(:,j)']; 
            end
        else
            for j=1:globp  
                newval.deriv(:,:,i)=[sout.deriv(:,j)';s2.deriv(:,:,j)];
            end
        end

    elseif p1==1 && q1~=1
        if p==1 || q==1
            for j=1:globp 
                newval.deriv(:,:,j)=[sout.deriv(:,j)';s2.deriv(:,j)']; 
            end
        else
            for j=1:globp 
                newval.deriv(:,:,j)=[sout.deriv(:,:,j);s2.deriv(:,j)']; 
            end
        end

    else

        if (p==1 || q==1) && (p1==1 || q1==1)
            newval.deriv=[sout.deriv;s2.deriv];
        elseif (p==1 || q==1)
            for j=1:globp
                newval.deriv(:,:,j)=[sout.deriv(:,j);s2.deriv(:,:,j)]; 
            end

        elseif (p1==1 || q1==1)
            for j=1:globp
                newval.deriv(:,:,j)=[sout.deriv(:,:,j);s2.deriv(:,j)];
            end

        else
            for j=1:globp 
                newval.deriv(:,:,j)=[sout.deriv(:,:,j);s2.deriv(:,:,j)];
            end

        end

    end
    sout=newval;
end


