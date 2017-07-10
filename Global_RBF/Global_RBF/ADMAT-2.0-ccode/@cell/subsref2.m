function sout=subsref2(x,s1)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp
[m,n]=size(x);


if length(s1.subs)==1
    I=s1.subs{1};
    if ~((I==':') && ischar(I))
        m2=length(I);
        if max(I) <= m
            sout=cell(m2,n);
            for i=1:m2
                for j=1:n
                    sout(i,j)=x(I(i),j);
                end
            end
        else
            sout=sparse(m2,globp);
            for i=1:m2
                jindex=ceil(I(i)/size(x{1},1));
                iindex=I(i)-m*(jindex-1);
                temp=x{iindex};
                sout(i,:)=temp(jindex,:);
            end
        end
    else
        sout=[];
        for i=1:m
            for j=1:size(x{1},1)
                sout=[sout;x{i}(j,:)];
            end
        end
    end

else
    
    I1=s1.subs{1};
    I2=s1.subs{2};
    if I1~=':'
        m2=length(I1);
        sout=cell(m2,n);
        for i=1:m2
            for j=1:n
                temp=x{I1(i),j};
                if I2==':' 
                    sout{i,j}=temp; 
                else
                    sout{i,j}=temp(I2,:); 
                end
            end
        end
    else
        sout=cell(m,n);
        for i=1:m
            for j=1:n
                temp=x{i,j};
                if I2==':' 
                    sout{i,j}=temp; 
                else
                    sout{i,j}=temp(I2,:);
                end
            end
        end
    end
end
