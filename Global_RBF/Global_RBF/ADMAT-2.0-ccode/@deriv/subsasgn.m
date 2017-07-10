function a=subsasgn(a,s1,x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

if ~isa(x,'deriv') 
    x=deriv(x); 
end
if ~isa(s1,'deriv') 
    s1=deriv(s1);
end
s1=s1.val;


if length(s1.subs) == 1
    I=s1.subs{1};
    if isa(I,'deriv') 
        I=I.val;
    end
    if ~isempty(I)
        if ~isempty(a)
            a=deriv(a);
            [p,q]=size(a.val);
            if (p==1)||(q==1)
                a.val(I)=x.val;
                if length(x.val) == 1 && islogical(I)   % x.val is a scale
                    len = sum(I);
                    a.deriv(I,:) = x.deriv(ones(len,1),:);
                else
                   a.deriv(I,:)=x.deriv;
                end
            else
                a.val(I)=x.val;
                a.deriv(I)=x.deriv;
            end

        else
            mm=length(x.val);
            if strcmp(I,':')
                mm=length(x.val);
            end
            a=deriv(zeros(mm,1));
            a.val(I)=x.val;
            a.deriv(I,:)=x.deriv;
        end
    end


elseif length(s1.subs)==2
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'deriv') 
        I1=I1.val; 
    end
    if isa(I2,'deriv')
        I2=I2.val; 
    end
    if (~isempty(I1) && ~isempty(I2))
        if ~isempty(a)
            a=deriv(a);
            [mmp,nnp]=size(a.val);
            if isempty(x.val) 
                a.val(I1,I2)=[]; 
            else
                a.val(I1,I2)=x.val;
            end
            [mm,nn]=size(a.val);

            if ((mm>1) && (nn>1))
                temp = zeros(mm,nn,globp);

                if (nnp==1)
                    temp(:,1,:)=a.deriv;
                    a.deriv=temp;
                elseif mmp==1
                    temp(1,:,:)=a.deriv;
                    a.deriv=temp;
                else
                end

                if isempty(x.deriv) 
                    a.deriv(I1,I2,:)=[];
                else
                    a.deriv(I1,I2,:)=x.deriv;
                end

            elseif nn==1
                a.deriv(I1,:)=x.deriv;
            else
                a.deriv(I2,:)=x.deriv;
            end

        else

            if strcmp(I1,':') 
                mm=size(x.val,1); 
            else
                mm=max(I1);
            end
            if strcmp(I1,':')  
                nn=size(x.val,2);
            else
                nn=max(I2); 
            end
            a=deriv(zeros(mm,nn));
            a.val(I1,I2)=x.val;
            if (mm > 1) && (nn > 1)
                a.deriv(I1,I2,:)=x.deriv;
            elseif nn==1
                a.deriv(I1,:)=x.deriv;
            else
                a.deriv(I2,:)=x.deriv;
            end
        end
    end

elseif length(s1.subs)==3
    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    if isa(I1,'deriv') 
        I1=I1.val; 
    end
    if isa(I2,'deriv')
        I2=I2.val; 
    end
    if isa(I3,'deriv')
        I3=I3.val;
    end
    if ~isempty(a)
        a=deriv(a);
        ppp=size(a.val);
        if isempty(x.val)

            a.val(:,I2,:)=[];
            if (length(ppp)==2) && ((ppp(1)==1) ||(ppp(2)==1))
                a.deriv(I2,:,:)=[];
            else
                a.deriv(:,I2,:,:)=[];
            end

        else
            a.val(I1,I2,I3)=x.val;
            if (length(ppp)==2) && ((ppp(1)==1)||(ppp(2)==1))
                a.deriv(I2,:,:)=x.deriv;
            else
                a.deriv(I1,I2,I3,:)=x.deriv;
            end

        end

    else
    end

else

    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    I4=s1.subs{4};
    if isa(I1,'deriv')
        I1=I1.val; 
    end
    if isa(I2,'deriv') 
        I2=I2.val;
    end
    if isa(I3,'deriv') 
        I3=I3.val;
    end
    if isa(I4,'deriv')
        I4=I4.val;
    end

    a.val(I1,I2,I3,I4)=x.val;
    a.deriv(I1,I2,I3,I4,:)=x.deriv;


end
