function sout = mpower(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;


if ~isa(s1,'derivtapeH')
    sout.val=s1.^s2.val;
    [m,n]=size(getval(sout));
    val2=sout.val.*log(s1);
    if (m==1) || (n==1)
        for i=1:globp
            sout.deriv(:,i)=val2(:).*s2.deriv(:,i);
        end

    else
        if length(s1)==1
            for i=1:globp
                sout.deriv(:,:,i)= val2.*s2.deriv(:,:,i);
            end
        elseif length(s2.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val2.*s2.deriv(i);
            end

        else
            sout.deriv=val2.*s2.deriv;
        end
    end


elseif ~isa(s2,'derivtapeH')
    sout.val=s1.val.^s2;
    [m,n]=size(getval(sout));
    [m2,n2]=size(getval(s1));
    val1=s2.*(s1.val.^(s2-1));

    if (m==1) | (n==1)
        if (m2>1)|(n2>1)
            sout.deriv=repmat(val1,1,globp).*s1.deriv;
        else
            sout.deriv=val1*s1.deriv;
        end
    else
        if length(s1.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(i);
            end
        elseif length(s2)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i);
            end

        else
            sout.deriv=val1.*s1.deriv;
        end
    end


else
    sout.val=s1.val.^s2.val;
    [m,n]=size(getval(sout));

    val1=s2.val.*(s1.val.^(s2.val-1));
    val2=sout.val.*log(s1.val);
    if (m==1) | (n==1)
        for i=1:globp
            sout.deriv(:,i)=val1(:).*s1.deriv(:,i)+...
                val2(:).*s2.deriv(:,i);
        end

    else
        if length(s1.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(i)+...
                    val2.*s2.deriv(:,:,i);
            end
        elseif length(s2.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i)+...
                    val2.*s2.deriv(i);
            end

        else
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i)+...
                    val2.*s2.deriv(:,:,i);
            end
        end
    end
end

sout=class(sout,'derivtapeH');
