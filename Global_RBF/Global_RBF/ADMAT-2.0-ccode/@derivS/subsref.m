function sout=subsref(x,s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if length(s1.subs)==1
    I=s1.subs{1};
    if isa(I,'derivS') 
        I=I.val;
    end
    if ~isempty(I)
        p=size(x.val);
        if (length(p)==2) && ((p(1)==1)||(p(2)==1))
            sout.val=x.val(I);
            sout.derivS=x.derivS(I,:);

        else
            sout.val=x.val(I);
            sout.derivS=x.derivS(I);
        end
        sout=class(sout,'derivS');
    else
        sout=derivS([]);
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
    if ~isempty(I1) && ~isempty(I2)
        sout=x.val(I1,I2);
        sout=derivS(sout);
        [p,q]=size(x.val);
        if (p==1)&&(q~=1)
            if length(I1)~=1
                sout.derivS=x.derivS(I2,I1);
                sout.derivS=sout.derivS';
            else
                sout.derivS=x.derivS(I2,:);
            end
        elseif (p==1) && (q==1)
            sout.derivS=x.derivS;
        else
            temp=x.derivS(I1,I2);
            sout.derivS=reshape(temp,size(sout.derivS));
        end
    else
        sout=derivS([]);
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
    if ~isempty(I1) && ~isempty(I2) && ~isempty(I3)
        sout=x.val(I1,I2,I3);
        sout=derivS(sout);
        temp=x.derivS(I1,I2,I3);
        sout.derivS=reshape(temp,size(sout.derivS));

    else
        sout=derivS([]);
    end

else
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

    if ~isempty(I1) && ~isempty(I2) && ~isempty(I3) && ~isempty(I4)
        sout=x.val(I1,I2,I3,I4);
        sout=derivS(sout);
        temp=x.derivS(I1,I2,I3,I4);
        sout.derivS=reshape(temp,size(sout.derivS));

    else
        sout=derivS([]);
    end

end

if isempty(sout.val)
    sout=derivS([]);
end

