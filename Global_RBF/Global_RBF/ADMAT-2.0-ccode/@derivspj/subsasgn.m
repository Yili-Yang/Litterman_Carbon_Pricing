function a=subsasgn(a,s1,x)
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
prevadhess=ADhess;
x=derivspj(x);
%s1=derivspj(s1);
%s1=s1.val;
if length(s1.subs) == 1
    I=s1.subs{1};

    if ~isempty(I)

        if isa(I,'derivspj')
            I=I.val;
        end
        if ~isempty(a)
            a=derivspj(a);
            a.val(I)=x.val;
            if iscell(a.derivspj) || iscell(x.derivspj)
                a=subsasgncell(a,x,I);
            else
                a.derivspj(I,:)=x.derivspj;
            end
        else
            a=derivspj(ones(max(I),1));
            a.val(I)=x.val;
            if iscell(a.derivspj) || iscell(x.derivspj)
                a=subsasgncell(a,x,I);
            else
                a.derivspj(I,:)=x.derivspj;
            end
        end

    else

        if isempty(a) 
            a=derivspj([]); 
        else
            a=derivspj(a);
        end
    end

else

    I1=s1.subs{1};
    I2=s1.subs{2};
    if ~isempty(I1) && ~isempty(I2)

        if isa(I1,'derivspj')
            I1=I1.val;
        end
        if isa(I2,'derivspj')
            I2=I2.val;
        end
        if ~isempty(a)
            a=derivspj(a);
            tmp= size(a.val,2);
            if tmp == 1 && I2 ==1
                I2 = ':';
            end
            a.val(I1,I2)=x.val;
            if iscell(a.derivspj) || iscell(x.derivspj)
                a=subsasgncell(a,x,I1,I2);
            else
                if strcmp(I1,':')
                    for k=1:size(a.val,1)
                        temp=x(k);
                        a.derivspj{k}(I2,:)=temp.derivspj;
                    end
                else
                    [m,n]=size(getval(a));
                    if m > 1 &&  n>1
                        for k=1:length(I1) 
                            a.derivspj{I1(k)}(I2,:)=x(k).derivspj; 
                        end
                    else
                        a.derivspj(I1,I2)=x.derivspj;
                    end
                end
            end
        else
            a=derivspj(ones(max(I1),max(I2)));
            a.val(I1,I2)=x.val;
            if iscell(a.derivspj) || iscell(x.derivspj)
                a=subsasgn(a,x,I1,I2);
            else
                tmp= size(a.val,2);
                if tmp == 1 && I2 ==1
                    I2 = ':';
                end
                a.derivspj(I1, I2) = x.derivspj;
                %                 for k=1:length(I1)
                %                     a.derivspj{I1(k)}(I2,:)=x.derivspj;
                %                 end
            end
        end

    end
end
ADhess=prevadhess;

