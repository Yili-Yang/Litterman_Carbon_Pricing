function a=subsasgn(a,s1,x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global ADhess;
prevadhess=ADhess;

x=derivsph(x);
if length(s1.subs) == 1
    I=s1.subs{1};
    if ~isa(I,'double') 
        I=getval(I); 
    end
    if ~isempty(a)
        a=derivsph(a);
        a.val(I)=x.val;
        if iscell(a.derivsph)
            newI.subs=cell(1);
            newI.subs{1}=I;
            a.derivsph=subsasgn(a.derivsph,newI,x.derivsph);
        else

            a.derivsph=x.derivsph;

        end
    else
        a=derivsph(ones(max(I),1));
        a.val(I)=x.val;
        if iscell(a.derivsph)
            newI.subs=cell(1);
            newI.subs{1}=I;
            a.derivsph=subsasgn(a.derivsph,newI,x.derivsph);
        else

            a.derivsph=x.derivsph;

        end
    end

else

    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivsph')
        I1=getval(I1);
    end
    if isa(I2,'derivsph')
        I2=getval(I2); 
    end
    if ~isempty(a)
        a=derivsph(a);
        a.val(I1,I2)=x.val;
        a.derivsph(I1,I2)=x.derivsph;
    else
        a=derivsph(ones(max(I1),max(I2)));
        a.val(I1,I2)=x.val;
        a.derivsph(I1,I2)=x.derivsph;
    end

end
ADhess=prevadhess;

