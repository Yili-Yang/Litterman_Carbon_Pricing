function sout=subsref(x,s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;


if ~isa(x,'derivtape') 
    x=derivtape(x,0); 
end
I = s1.subs;
if length(I)==1
    I=s1.subs{1};
    if isa(I,'derivtape') 
        I=I.val;
    end
    if isempty(I)
        sout=[];
    else
        sout.val=x.val(I);
        sout.varcount=varcounter;
        sout=class(sout,'derivtape');
        savetape('subsref',sout,x.varcount,I);
    end
elseif length(I)==2
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivtape') 
        I1=I1.val;
    end
    if isa(I2,'derivtape') 
        I2=I2.val;
    end
    sout.val=x.val(I1,I2);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('subsref',sout,x.varcount,I1,I2);
else
    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    if isa(I1,'derivtape') 
        I1=I1.val;
    end
    if isa(I2,'derivtape') 
        I2=I2.val;
    end
    if isa(I3,'derivtape') 
        I2=I3.val; 
    end
    sout.val=x.val(I1,I2,I3);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('subsref',sout,x.varcount,I1,I2,I3);
end
