function a=subsasgn(a,s1,x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if ~isa(x,'derivH')
    x=derivH(x);
end
if ~isa(s1,'derivH')
    s1=derivH(s1);
end
s1=s1.val;


if length(s1.subs) == 1
    I=s1.subs{1};
    if isa(I,'derivH') 
        I=I.val; 
    end
    if ~isempty(I)
        if ~isempty(a)
            a=derivH(a);
            [p,q]=size(a.val);
            if (p==1) ||(q==1)
                a.val(I)=x.val;
                a.derivH(I,:)=x.derivH;
            else
                a.val(I)=x.val;
                a.derivH(I)=x.derivH;
            end

        else
            mm=length(x.val);
            if (I==':') 
                mm=length(x.val);
            end
            a=derivH(zeros(mm,1));
            a.val(I)=x.val;
            a.derivH(I,:)=x.derivH;
        end
    end
elseif length(s1.subs)==2
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivH') 
        I1=I1.val; 
    end
    if isa(I2,'derivH') 
        I2=I2.val; 
    end
    if (~isempty(I1) && ~isempty(I2))
        if ~isempty(a)
            a=derivH(a);
            [mmp,nnp]=size(a.val);
            a.val(I1,I2)=x.val;
            [mm,nn]=size(a.val);
            if (mm > 1) && (nn > 1)
                if ((mmp==1) || (nnp==1))
                    temp = zeros(mm,nn);
                    if (nnp==1) && (nn > 1)
                        temp(:,1)=a.derivH;
                    else
                        temp(1,:)=a.derivH;
                    end
                    a.derivH=temp;
                end
                a.derivH(I1,I2)=x.derivH;
            elseif nn==1
                a.derivH(I1,:)=x.derivH;
            else
                a.derivH(I2,:)=x.derivH;
            end
        else
            if (I1==':') 
                mm=size(x.val,1); 
            else
                mm=max(I1); 
            end
            if (I2==':') 
                nn=size(x.val,2); 
            else
                nn=max(I2); 
            end
            a=derivH(zeros(mm,nn));
            a.val(I1,I2)=x.val;
            if (mm > 1) && (nn > 1)
                a.derivH(I1,I2,:)=x.derivH;
            elseif nn==1
                a.derivH(I1,:)=x.derivH;
            else
                a.derivH(I2,:)=x.derivH;
            end
        end
    end
else
    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    if isa(I1,'derivH') 
        I1=I1.val;
    end
    if isa(I2,'derivH') 
        I2=I2.val; 
    end
    if isa(I3,'derivH')
        I3=I3.val; 
    end
    if ~isempty(a)
        a=derivH(a);

        ppp=size(a.val);
        if isempty(x.val)

            a.val(:,I2,:)=[];
            if (length(ppp)==2) && ((ppp(1)==1)||(ppp(2)==1))
                a.derivH(I2,:,:)=[];
            else
                a.derivH(:,I2,:,:)=[];
            end

        else
            a.val(I1,I2,I3)=x.val;
            if (length(ppp)==2) && ((ppp(1)==1)||(ppp(2)==1))
                a.derivH(I2,:,:)=x.derivH;
            else
                a.derivH(I1,I2,I3,:)=x.derivH;
            end

        end

    end
end
