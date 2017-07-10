function adjmrdivide(i)
%
%
%
%   04/2007 -- reorganize the program and add documentation
%   04/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   04/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global tape;
global globp;

if ~isempty(tape(i).arg3vc)

    if tape(i).arg3vc==-1                 % tape(i).arg1vc is not an object of derivtape class
        if size(tape(i).val,2)~=1         % tape(i).val is a matrix
            for j=1:globp
                temp=tape(i).arg1vc\tape(i).W(:,:,j);
                tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)+temp;
            end
        else                              % tape(i).val is a vector
            if globp > 1
                for j=1:globp
                    temp=tape(i).arg1vc\tape(i).W(:,j);
                    tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+temp;
                end
            else
                temp=tape(i).arg1vc\tape(i).W;
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+temp;
            end
        end
    else                                 % tape(i).arg2vc is not an object of derivtape class
                                         %  tape(i).arg3vc == -2
        if size(tape(i).val,2)~=1        % tape(i).val is a matrix
            for j=1:globp
                temp=tape(tape(i).arg1vc).val\(tape(i).W(:,:,j) *tape(i).val) ;
                tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-temp;
            end
        else                           
            if globp > 1                % tape(i).val is a vector
                for j=1:globp
                    temp=tape(tape(i).arg1vc).val\(tape(i).W(:,j)*tape(i).val);
                    tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)-temp;
                end
            else
                temp=tape(tape(i).arg1vc).val'\tape(i).W;
                [I,J]=find(tape(tape(i).arg1vc).val);
                value=-temp(I).*tape(i).val(J);
                [m,n]=size(tape(tape(i).arg1vc).val);
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sparse(I,J,value,m,n);
                %tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-temp*tape(i).val';
            end
        end
    end
else                               % both tape(i).arg2vc and tape(i).arg1vc are derivtape objects

    if size(tape(i).val,2)~=1      % tape(i).val is not a coulmn vector

        if size(tape(i).val,1)==1         % tape(i).val is a row vector
            if length(tape(tape(i).arg1vc).val)==1            % tape(tape(i).arg1vc).val is a scalar
                temp=tape(tape(i).arg1vc).val\tape(i).W;
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+temp;
                tmp = -tape(tape(i).arg1vc).val\(tape(i).val * tape(i).W);
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W - tmp;
%                 for j=1:globp
%                     temp=tape(tape(i).arg1vc).val\tape(i).W(:,j);
%                     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+temp;
%                     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)-sum(temp\tape(i).val);
%                 end
            else                     % tape(tape(i).arg1vc).val is a matrix
                temp = tape(tape(i).arg1vc).val\tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+temp;
                temp=tape(tape(i).arg1vc).val\(tape(i).val*tape(i).W);
                temp = temp(ones(globp,1), :);
                temp = temp(:,:,ones(1, globp));
                temp = permute(temp, [3,1,2]);
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W - temp;
%                 for j=1:globp
%                     temp=tape(tape(i).arg1vc).val\tape(i).W(:,j);
%                     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+temp;
%                     temp=tape(tape(i).arg1vc).val\tape(i).W(:,j)
%                     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)-temp\tape(i).val;
%                 end
            end

        else                      % tape(i).val is a matrix

            if length(tape(tape(i).arg1vc).val)==1     % tape(tape(i).arg1vc).val is a scalar
                for j=1:globp
                    temp=tape(tape(i).arg1vc).val\tape(i).W(:,:,j);
                    tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)+temp;
                    temp = tape(tape(i).arg1vc).val\(tape(i).val*tape(i).W(:,:,j));
                    tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)-sum(sum(temp));
                end
            else                                       % tape(tape(i).arg1vc).val is a matrix
                for j=1:globp
                    temp=tape(tape(i).arg1vc).val\tape(i).W(:,:,j);
                    tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)+temp;
                    temp=tape(tape(i).arg1vc).val\(tape(i).val*tape(i).W(:,:,j));
                    tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-temp;
                end
            end
        end

    elseif size(tape(i).val,1)~=1               % tape(i).val is a column vector
        if globp > 1 
            if length(tape(tape(i).arg1vc).val)==1           % tape(tape(i).arg1vc).val is a scalar
                temp=tape(tape(i).arg1vc).val\tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + temp;
                temp=tape(tape(i).arg1vc).val\(tape(i).val'*tape(i).W);
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W - temp;
       
%                 for j=1:globp
%                     temp=tape(tape(i).arg1vc).val\tape(i).W(:,j);
%                     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+temp;
%                      temp=tape(tape(i).arg1vc).val\(tape(i).W(:,j)*tape(i).val);
%                     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)-sum(temp);
%                 end
            else                        % tape(tape(i).arg1vc).val is a matrix
                temp=tape(tape(i).arg1vc).val\tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + temp;
                temp = tape(tape(i).arg1vc).val\(tape(i).W'*tape(i).val);
                temp = temp(:, ones(1, globp))';
                temp = temp(:,:,ones(1, globp));
                temp = permute(temp, [3,1,2]);
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W - temp;
%                 for j=1:globp
%                     temp=tape(tape(i).arg1vc).val'\tape(i).W(:,j);
%                     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+temp;
%                     temp=tape(tape(i).arg1vc).val'\(tape(i).W(:,j));
%                     tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-temp * tape(i).val';
%                 end

            end
        else                       % globp == 1
            temp=tape(tape(i).arg1vc).val\tape(i).W;
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+temp;
            if length(tape(tape(i).arg1vc).val)==1
                temp=tape(tape(i).arg1vc).val\(tape(i).W*tape(i).val);
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-sum(temp);
            else
                [I,J]=find(tape(tape(i).arg1vc).val);
                value=-temp(I).*tape(i).val(J);
                [m,n]=size(tape(tape(i).arg1vc).val);
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sparse(I,J,value,m,n);
            end
        end
    else                % tape(i).val is a scalar
        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + tape(i).W./tape(tape(i).arg1vc).val;
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-...
            tape(i).W.*tape(i).val./tape(tape(i).arg1vc).val;
    end
end

%tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(tape(i).W'/tape(tape(i).arg2vc).val)';
val2=tape(tape(i).arg2vc).val; val2=val2(:);
val1=tape(tape(i).arg1vc).val; val1=val1(:);

if (length(tape(tape(i).arg2vc).val)==1) & (length(tape(tape(i).arg1vc).val)~=1)

for j=1:globp
     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
     sum((val1./(val2.*val2)).*tape(i).W(:,j));
     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+(1./val2).*tape(i).W(:,j);
end
elseif (length(tape(tape(i).arg2vc).val)~=1) & (length(tape(tape(i).arg1vc).val)==1)
for j=1:globp
     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
     (val1./(val2.*val2)).*tape(i).W(:,j);
     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+sum((1./val2).*tape(i).W(:,j));
end
else


for j=1:globp
     tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
     (val1./(val2.*val2)).*tape(i).W(:,j);
     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+(1./val2).*tape(i).W(:,j);
end
end

