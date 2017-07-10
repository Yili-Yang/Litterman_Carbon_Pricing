function a=subsasgn(a,s1,x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

if ~isa(x, 'derivtapeH')
    x=derivtapeH(x,0);
end

if isa(s1,'derivtapeH')
    s1=getval(s1);
end

if length(s1.subs) == 1
    I=s1.subs{1};
    if isa(I,'derivtapeH') 
        I=getval(I);
    end
    if ~isempty(I)
        if ~isempty(a)
%             if ~isa(a, 'derivtapeH')
%                 a=derivtapeH(a,0);
%             end
            a.val(I)=x.val;
        else
            if (strcmp(I,':')) 
                mm=length(x.val);
            else
                mm=max(I);
            end
            %a=derivtapeH(zeros(mm,1),0);
            a.val(I)=x.val;
        end
        [m,n]=size(a.val);
        if (m==1) 
            m=n;
        end
        if (max(I) <= m) || strcmp(I,':')
            if globp==1
                a.deriv(I)=x.deriv;
            else
                a.deriv(I,:)=x.deriv;
            end
        else
            if globp==1
                for i=1:length(I)
                    jindex=ceil(I(i)/n);
                    iindex=I(i)-m*(jindex-1);
                    a.deriv(iindex,jindex)=x.deriv(i);
                end
            else
                for i=1:length(I)
                    jindex=ceil(I(i)/n);
                    iindex=I(i)-m*(jindex-1);
                    a.deriv(iindex,jindex,:)=x.deriv(i,:);
                end
            end

        end
    end
else

    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivtapeH') 
        I1=getval(I1);
    end
    if isa(I2,'derivtapeH') 
        I2=getval(I2); 
    end
    if ~isempty(I1) && ~isempty(I2)
        if ~isempty(a)
%             if ~isa(a, 'derivtapeH')
%                 a=derivtapeH(a,0);
%             end
            a.val(I1,I2)=x.val;
            if globp==1
                a.deriv(I1,I2)=x.deriv;
            else
                a.deriv(I1,I2,:)=x.deriv;
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
            %a=derivtapeH(zeros(mm,nn),0);
            a.val(I1,I2)=x.val;
            if globp==1
                a.deriv(I1,I2)=x.deriv;
            else
                a.deriv(I1,I2,:)=x.deriv;
            end
        end
    end
end

% if ~isempty(a) 
%   a = class(a,'derivtapeH');
% end