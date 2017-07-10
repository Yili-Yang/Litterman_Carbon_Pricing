function sout=subsref(x,s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;


if length(s1.subs)==1
    I=s1.subs{1};
    if isa(I,'deriv')
        I=I.val;
    end
    if ~isempty(I)
        p=size(x.val);
        sout.val=x.val(I);
        if (length(p)==2) && (p(2)==1) 
            sout.deriv=x.deriv(I,:);
        elseif (length(p)==2) && (p(1)==1) 
            sout.deriv=x.deriv(I,:);
        else
            if strcmp(I,':')
                for i=1:globp
                    temp=x.deriv(:,:,i);
                    sout.deriv(:,i)=temp(:);
                end
            else
                if size(I,2) >1 && size(I,1) >1  % I is a matrix
                    sout.deriv = x.deriv(I);
                else
                    sout.deriv=x.deriv(I,:,:);
                end
            end
        end
        sout=class(sout,'deriv');
    else
        sout=[];
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
    if ~isempty(I1) && ~isempty(I2)
        sout=x.val(I1,I2);
        sout=deriv(sout);
        [p,q]=size(x.val);
        if (p==1)&&(q~=1)
            if length(I1)~=1
                for i = 1 : globp
                    tmp = x.deriv(:,i)';
                    sout.deriv(:,:,i) = tmp(I1, I2);
                end
                %sout.deriv=x.deriv(I2,:,I1);
                %sout.deriv=sout.deriv';
            else
                sout.deriv=x.deriv(I2,:);
            end
            %elseif (p==1) & (q==1)
            %sout.deriv=x.deriv;
        else
            if (ndims(x.deriv) < 3) && globp > 1
                temp1=reshape(x.deriv,[size(x.deriv,1) 1 globp]);
            else
                temp1=x.deriv;
            end
            temp=temp1(I1,I2,:);
            sout.deriv=reshape(temp,size(sout.deriv));
        end
    else
        sout=[];
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
    if ~isempty(I1) && ~isempty(I2) && ~isempty(I3)
        sout=x.val(I1,I2,I3);
        sout=deriv(sout);
        temp=x.deriv(I1,I2,I3,:);
        sout.deriv=reshape(temp,size(sout.deriv));

    else
        sout=[];
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

    if ~isempty(I1) && ~isempty(I2) && ~isempty(I3) && ~isempty(I4)
        sout=x.val(I1,I2,I3,I4);
        sout=deriv(sout);
        temp=x.deriv(I1,I2,I3,I4,:);
        sout.deriv=reshape(temp,size(sout.deriv));

    else
        sout=[];
    end

end
