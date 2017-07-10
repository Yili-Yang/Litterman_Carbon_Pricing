function sout=subsref(x,s1)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global ADhess;
global globp;

prevadhess=ADhess;
if ~isa(x,'derivspj')
    x=derivspj(x);
end

if length(s1.subs)==1
    I=s1.subs{1};
    if isa(I,'derivspj')
        I=I.val;
    end
    if ~isempty(I)
        sout.val=x.val(I);
        if iscell(x.derivspj)
            newI.subs=cell(1);
            newI.subs{1}=I;
            sout.derivspj=subsref(x.derivspj,newI);
        else
            [p,q]=size(x.val);
            
            if strcmp(I,':')
                sout.derivspj=x.derivspj;
            else
                if (p==1) || (q==1)
                    sout.derivspj=x.derivspj(I,:);
                else
                    sout.derivspj=x.derivspj(I);
                end
                
            end
        end
        sout=class(sout,'derivspj');
    else
        sout=derivspj([]);
    end
else
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivspj')
        I1=I1.val;
    end
    if isa(I2,'derivspj')
        I2=I2.val;
    end
    if ~isempty(I1) && ~isempty(I2)
        sout.val=x.val(I1,I2);
        sout = derivspj(sout.val);
        if iscell(x.derivspj)
            I.subs=cell(2,1);
            I.subs{1}=I1;
            I.subs{2}=I2;
            sout.derivspj=subsref(x.derivspj,I);
        else
            [p,q]=size(x.val);
            if ((p==1)&&(q~=1))
                if length(I1)~=1
                    for i = 1 : globp
                        tmp = x.derivspj(:,i)';
                        sout.derivspj{i} = tmp(I1, I2);
                    end
                    %                     sout.derivspj=x.derivspj(I2,:);
                    %                     sout.derivspj=sout.derivspj';
                else
                    sout.derivspj=x.derivspj(I2,:);
                end
%             elseif (p~=1) && (q==1)
%                 sout.derivspj = x.derivspj(I1, :);
%             elseif (p==1) && (q==1)
%                 sout.derivspj=x.derivspj;
            else
                if (ndims(x.derivspj) < 3) && globp > 1
                    temp1=squeeze(x.derivspj(I1,I2));
                else
                    temp1=x.derivspj;
                end
                temp=cell(globp,1);
                for i = 1 : globp
                    temp{i} = temp1;
                end
                sout.derivspj = temp;
                
            end
        end
        %sout=class(sout,'derivspj');
    else
        sout=derivspj([]);
    end
end
if iscell(sout.derivspj)
    if length(sout.derivspj)==1
        sout.derivspj=sout.derivspj{1};
    end
end
if isempty(sout.val)
    sout=derivspj([]);
end
ADhess=prevadhess;
