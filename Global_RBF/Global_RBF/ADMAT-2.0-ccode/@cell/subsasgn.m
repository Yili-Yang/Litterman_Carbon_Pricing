function a = subsasgn(a,s1,x)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global ADhess;

if length(s1.subs)==1
    I=s1.subs{1};
    if ~((strcmp(I,':')) && ischar(I))
        if ~ADhess
            sout = cell(globp,1);
            for i=1:globp
                sout{i}(I)=x(:,i);
            end

        else
            if length(I) == 1
                for i=1:globp
                    for j=1:globp
                        a{i,j}(I)=x(i,j);
                    end
                end
            else
                for i=1:globp
                    for j=1:globp
                        a{i,j}(I)=x{i,j};
                    end
                end
            end
        end
    else
        a=x;
    end

else
    
    I1=s1.subs{1};
    I2=s1.subs{2};
    if ~((strcmp(I1,':')) && ischar(I1))
        if size(x{1}(I1,I2),1) > 1 && size(x{1}(I1,I2),2) > 1
            if ~ADhess
                sout = cell(globp,1);
                for i=1:globp
                    sout{i}(I1,I2)=x{i};
                end
            else
                for i=1:globp
                    for j=1:globp
                        a{i,j}(I1,I2)=x{i,j};
                    end
                end
            end
        else
            a=x;
        end
    end
end
