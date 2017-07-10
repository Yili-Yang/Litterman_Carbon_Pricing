function a=subsasgn(a,s1,x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if ~isa(x,'derivS') 
    x=derivS(x); 
end
if ~isa(s1,'derivS') 
    s1=derivS(s1);
end
s1=s1.val;


if length(s1.subs) == 1
    I=s1.subs{1};
    if isa(I,'derivS') 
        I=I.val;
    end
    if ~isempty(I)
        if ~isempty(a)
            a=derivS(a);
            [p,q]=size(a.val);
            if (p==1)||(q==1)
                a.val(I)=x.val;
                a.derivS(I,:)=x.derivS;
            else
                a.val(I)=x.val;
                a.derivS(I)=x.derivS;
            end

        else
            mm=length(x.val);
            if strcmp(I,':')
                mm=length(x.val);
            end
            a=derivS(zeros(mm,1));
            a.val(I)=x.val;
            a.derivS(I,:)=x.derivS;
        end
    end
elseif length(s1.subs)==2
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivS') 
        I1=I1.val;
    end
    if isa(I2,'derivS') 
        I2=I2.val; 
    end
    if (~isempty(I1) && ~isempty(I2))
        if ~isempty(a)
            a=derivS(a);
            [mmp,nnp]=size(a.val);
            [mm,nn]=size(a.val);
            if isempty(x.val) 
                a.val(I1,I2)=[]; 
            else
                a.val(I1,I2)=x.val; 
            end
            if (mm > 1) && (nn > 1)

                if ((mmp==1) || (nnp==1))
                    temp = zeros(mm,nn);
                    if (nnp==1) && (nn > 1)
                        temp(:,1)=a.derivS;
                    else
                        temp(1,:)=a.derivS;
                    end
                    a.derivS=temp;
                end

                if isempty(x.derivS) 
                    a.derivS(I1,I2)=[]; 
                else
                    a.derivS(I1,I2)=x.derivS; 
                end
            elseif nn==1
                a.derivS(I1,:)=x.derivS;
            else
                a.derivS(I2,:)=x.derivS;
            end
        else
            if strcmp(I1,':')
                mm=size(x.val,1); 
            else
                mm=max(I1); 
            end
            if strcmp(I2,':')
                nn=size(x.val,2); 
            else
                nn=max(I2); 
            end
            a=derivS(zeros(mm,nn));
            a.val(I1,I2)=x.val;
            if (mm > 1) && (nn > 1)
                a.derivS(I1,I2,:)=x.derivS;
            elseif nn==1
                a.derivS(I1,:)=x.derivS;
            else
                a.derivS(I2,:)=x.derivS;
            end
        end
    end

elseif length(s1.subs)==3
    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    if isa(I1,'derivS') 
        I1=I1.val;
    end
    if isa(I2,'derivS') 
        I2=I2.val;
    end
    if isa(I3,'derivS') 
        I3=I3.val;
    end
    if ~isempty(a)
        a=derivS(a);

        ppp=size(a.val);
        if isempty(x.val)

            a.val(:,I2,:)=[];
            if (length(ppp)==2) && ((ppp(1)==1) || (ppp(2)==1))
                a.derivS(I2,:,:)=[];
            else
                a.derivS(:,I2,:,:)=[];
            end

        else
            a.val(I1,I2,I3)=x.val;
            if (length(ppp)==2) && ((ppp(1)==1) || (ppp(2)==1))
                a.derivS(I2,:,:)=x.derivS;
            else
                a.derivS(I1,I2,I3,:)=x.derivS;
            end

        end

    end

    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    I4=s1.subs{4};
    if isa(I1,'derivS') 
        I1=I1.val; 
    end
    if isa(I2,'derivS') 
        I2=I2.val;
    end
    if isa(I3,'derivS') 
        I3=I3.val; 
    end
    if isa(I4,'derivS') 
        I4=I4.val;
    end

    a.val(I1,I2,I3,I4)=x.val;
    a.deriv(I1,I2,I3,I4)=x.derivS;

end
