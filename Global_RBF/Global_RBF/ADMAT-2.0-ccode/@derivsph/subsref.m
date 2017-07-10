function sout=subsref(x,s1)

global ADhess
prevadhess=ADhess;

if ~isa(x,'derivsph') 
    x=derivsph(x); 
end

if length(s1.subs)==1
    I=s1.subs{1};
    if ~isa(I,'double') 
        I=getval(I); 
    end
    if ~isempty(I)
        sout.val=x.val(I);
        if iscell(x.derivsph)
            newI.subs=cell(1);
            newI.subs{1}=I;
            sout.derivsph=subsref(x.derivsph,newI);
        else
            [p,q]=size(x.val);

            if strcmp(I,':')
                sout.derivsph=x.derivsph;
            else
                if (p==1) || (q==1)
                    sout.derivsph=x.derivsph(I,:);
                else
                    sout.derivsph=x.derivsph(I);
                end

            end
        end

        sout=class(sout,'derivsph');

    else
        sout=derivsph([]);
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
    if ~isempty(I1) && ~isempty(I2)
        sout.val=x.val(I1,I2);
        if iscell(x.derivsph)
            I.subs=cell(2,1);
            I.subs{1}=I1;
            I.subs{2}=I2;
            sout.derivsph=subsref(x.derivsph,I);
        else
            [p,q]=size(x.val);
            if ((p==1) && (q~=1))
                if length(I1)~=1
                    sout.derivsph=x.derivsph(I2,I1);
                    sout.derivsph=sout.derivsph';
                else
                    sout.derivsph=x.derivsph(I2,:);
                end
            elseif (p==1) && (q==1)
                sout.derivsph=x.derivsph;
            else
                sout.derivsph=squeeze(x.derivsph(I1,I2));
            end
        end
        sout=class(sout,'derivsph');
    else
        sout=derivsph([]);
    end
end
if iscell(sout.derivsph)
    if length(sout.derivsph)==1 
        sout.derivsph=sout.derivsph{1}; 
    end
end
if isempty(sout.val)
    sout=derivsph([]);
end
ADhess=prevadhess;

