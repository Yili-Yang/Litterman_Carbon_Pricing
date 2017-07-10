function sout=subsref(x,s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if length(s1.subs)==1
    I=s1.subs{1};
    if isa(I,'derivH') 
        I=I.val; 
    end
    if ~isempty(I)
        p=size(x.val);
        if (length(p)==2) && ((p(1)==1)||(p(2)==1))
            sout.val=x.val(I);
            sout.derivH=x.derivH(I,:);
        else
            sout.val=x.val(I);
            sout.derivH=x.derivH(I);
        end
        sout=class(sout,'derivH');
    else
        sout=derivH([]);
    end

else
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivH') 
        I1=I1.val; 
    end
    if isa(I2,'derivH') 
        I2=I2.val; 
    end
    if ~isempty(I1) && ~isempty(I2)
        sout=x.val(I1,I2);
        sout=derivH(sout);
        [p,q]=size(x.val);
        if (p==1) && (q~=1)
            if length(I1)~=1
                sout.derivH=x.derivH(I2,I1,:);
                sout.derivH=sout.derivH';
            else
                sout.derivH=x.derivH(I2,:);
            end
        elseif (p==1) && (q==1)
            sout.derivH=x.derivH;
        else
            temp=x.derivH(I1,I2,:);
            sout.derivH=reshape(temp,size(sout.derivH));
        end
    else
        sout=derivH([]);
    end
end
