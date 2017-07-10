function sout2=subsasgn(sout,s1,x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

%if sout.varcount == 189
%    tt = 0;
%end
x=derivtape(x,0);
if (isa(s1,'derivtape'))
    s1=s1.val;
end

if length(s1.subs) == 1
    I=s1.subs{1};
    if isa(I,'derivtape') 
        I=I.val; 
    end
    if ~isempty(I)
        if ~isempty(sout)
            sout2.val=sout.val;
            sout2.val(I)=x.val;
        else
            if strcmp(I,':')
                mm=length(x.val);
            else
                mm=max(I); 
            end
            sout2.val=zeros(mm,1);
            sout2.val(I)=x.val;
        end
        sout2.varcount=varcounter;
        sout2=class(sout2,'derivtape');
        if ~isempty(sout)
            savetape('subsasgn',sout2,sout.varcount, x.varcount,I);
        else
            savetape('subsasgn',sout2,0,x.varcount,I);
        end
    else
        sout2=sout;
    end
elseif length(s1.subs) == 2
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivtape') I1=I1.val; end
    if isa(I2,'derivtape') I2=I2.val; end
    if ~isempty(I1) & ~isempty(I2)
        if ~isempty(sout)
            sout2.val=sout.val;
            sout2.val(I1,I2)=x.val;
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
            sout2.val=zeros(mm,nn);
            sout2.val(I1,I2)=x.val;
        end

        sout2.varcount=varcounter;
        sout2=class(sout2,'derivtape');
        if ~isempty(sout)
            savetape('subsasgn',sout2,sout.varcount,x.varcount,I1,I2);
        else
            savetape('subsasgn',sout2,0,x.varcount,I1,I2);
        end
    else
        sout2=sout;
    end
else

    I1=s1.subs{1};
    I2=s1.subs{2};
    I3=s1.subs{3};
    if isa(I1,'derivtape') I1=I1.val; end
    if isa(I2,'derivtape') I2=I2.val; end
    if isa(I3,'derivtape') I3=I3.val; end
    if ~isempty(I1) & ~isempty(I2) & ~isempty(I3)
        if ~isempty(sout)
            sout2.val=sout.val;
            sout2.val(I1,I2,I3)=x.val;
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
            if strcmp(I3,':')
                pp=size(x.val,3);
            else
                pp=max(I3);
            end
            sout2.val=zeros(mm,nn,pp);
            sout2.val(I1,I2,I3)=x.val;
        end

        sout2.varcount=varcounter;
        sout2=class(sout2,'derivtape');
        if ~isempty(sout)
            savetape('subsasgn',sout2,sout.varcount,x.varcount,I1,I2,I3);
        else
            savetape('subsasgn',sout2,0,x.varcount,I1,I2,I3);
        end
    else
        sout2=sout;
    end
end
