function adjmldivide(i)
%
%
%
%   04/2007 -- reorganize the program and add documentation
%   04/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   04/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   04/2007 -- consider all cases for matrix dividsion. 
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

[m,n] = size(tape(i).val);
if ~isempty(tape(i).arg3vc)    
    if tape(i).arg3vc==-1                 % tape(i).arg1vc is not an object of derivtape class
        [m1,n1] = size(tape(i).arg1vc);
        [m2,n2] = size(tape(tape(i).arg2vc).val);
        if (m1 == 1 && n1 == 1) || (m2 == 1 && n2 == 1)
            temp=tape(i).arg1vc'\tape(i).W;
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+temp;
        else
            if n ~= 1       % tape(i).val is a matrix or a row vector
                if n1 == 1             % 3-D shrink to 2-D
                    for j = 1 : globp
                        temp=tape(i).arg1vc'\tape(i).W(:,j)';
                        tape(tape(i).arg2vc).W(:,:,j)= ...
                            tape(tape(i).arg2vc).W(:,:,j)+temp;
                    end
                elseif m1 == 1       % 2-D  expands to 3-D
                    for j=1:globp
                        temp=tape(i).arg1vc'\tape(i).W(:,:,j);
                        tape(tape(i).arg2vc).W(:,j) = ...
                            tape(tape(i).arg2vc).W(:,j) + temp';
                    end
                else             
                    for j=1:globp
                        temp=tape(i).arg1vc'\tape(i).W(:,:,j);
                        tape(tape(i).arg2vc).W(:,:,j)=...
                            tape(tape(i).arg2vc).W(:,:,j)+temp;
                    end
                end
            else                              % tape(i).val is a vector
                if globp > 1
                    for j=1:globp
                        temp=tape(i).arg1vc'\tape(i).W(:,j);
                        tape(tape(i).arg2vc).W(:,j)= ...
                            tape(tape(i).arg2vc).W(:,j)+temp;
                    end
                else
                    temp=tape(i).arg1vc'\tape(i).W;
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+temp;
                end
            end
        end
    else                                 % tape(i).arg2vc is not an object of derivtape class
                                         %  tape(i).arg3vc == -2
        [m1,n1] = size(tape(tape(i).arg1vc).val);
        [m2,n2] = size(tape(i).arg2vc);
        if (m1 == 1 && n1 == 1)
            temp=(tape(tape(i).arg1vc).val'\ tape(i).val) *tape(i).W;
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W  - temp;
        elseif (m2 == 1 && n2 == 1)
            temp = tape(tape(i).arg1vc).val'\ tape(i).val * tape(i).W;
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W - ...
               temp  ;
        else
            if n ~= 1                        % tape(i).val is a matrix
                if n1 == 1                    % 3-D shrinks to 2-D
                        temp= (tape(tape(i).arg1vc).val'\tape(i).val) * tape(i).W;
                        tape(tape(i).arg1vc).W= ...
                            tape(tape(i).arg1vc).W - temp;
                elseif m1 ==  1
                     for j=1:globp
                        temp = tape(tape(i).arg1vc).val'\tape(i).val * tape(i).W(:,:,j)';
                        tape(tape(i).arg1vc).W(:,j)=...
                            tape(tape(i).arg1vc).W(:,j) - temp';
                     end
                else
                    if m1 == n1
                        for j=1:globp
                            temp =  (tape(tape(i).arg1vc).val\tape(i).val)' * tape(i).W(:,:,j);
                            tape(tape(i).arg1vc).W(:,:,j)= ...
                                tape(tape(i).arg1vc).W(:,:,j)-temp;
                        end
                    else
                        for j=1:globp
                            temp =  (tape(tape(i).arg1vc).val'\tape(i).val) * tape(i).W(:,:,j);
                            tape(tape(i).arg1vc).W(:,:,j)= ...
                                tape(tape(i).arg1vc).W(:,:,j)-temp;
                        end
                    end
                end
            else                              % n == 1
                if m == 1 && n == 1         % tape(i).val is a scalar
                    temp= (tape(tape(i).arg1vc).val'\tape(i).val) * tape(i).W;
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-...
                        temp;
                else
                    if globp > 1                % tape(i).val is a vector
                        if m1 > 1 && n1 >1
                            for j = 1 : globp
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                temp= tape(tape(i).arg1vc).val'\ tape(i).W(:,j)*tape(i).val';
                                tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-...
                                    temp;
                            end
                        else
                            temp= (tape(tape(i).arg1vc).val'\tape(i).val) * tape(i).W;
                            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W -...
                                    temp;
                        end
                    else
                        temp=tape(tape(i).arg1vc).val'\tape(i).W;
                        [I,J]=find(tape(tape(i).arg1vc).val);
                        value=-temp(I).*tape(i).val(J);
                        [m,n]=size(tape(tape(i).arg1vc).val);
                        tape(tape(i).arg1vc).W=...
                            tape(tape(i).arg1vc).W+sparse(I,J,value,m,n);
                        %tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-temp*tape(i).val';
                    end
                end
            end
        end
    end
else                               % both tape(i).arg2vc and tape(i).arg1vc are derivtape objects
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    [m1,n1] = size(x);
    [m2,n2] = size(y);
    [m3,n3] = size(tape(i).val);
    if m1 == 1 && n1 == 1          % x is a scalar
        temp= x'\tape(i).W;
        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+temp;
        if n3 == 1    % tape(i).val is a column vector
        temp = (x\ tape(i).val)' * tape(i).W;
        else    % tape(i).val is a column vector or a matrix
            temp = (x\ tape(i).val) * tape(i).W;
        end
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W  - temp;
    elseif m2 == 1 && n2 == 1     % y is a scalar
        temp = x'\tape(i).W;
        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+temp;
        temp = x'\tape(i).val* tape(i).W;
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W - ...
            temp;
    else
        if n ~= 1      % tape(i).val is not a coulmn vector
            if n1 == 1                    % 3-D shrinks to 2-D
                for j=1:globp
                    temp = x'\tape(i).W(:,j)';
                    tape(tape(i).arg2vc).W(:,:,j) = ...
                        tape(tape(i).arg2vc).W(:,:,j)+temp;
                    temp = x'\ tape(i).val * tape(i).W(:,j);
                    tape(tape(i).arg1vc).W(:,j)=...
                        tape(tape(i).arg1vc).W(:,j)-temp;
                end
            elseif m1 ==  1
                for j=1:globp
                    temp = x'\tape(i).W(:,:,j);
                    tape(tape(i).arg2vc).W(:,j) =...
                        tape(tape(i).arg2vc).W(:,j)+temp';
                    temp = x'\tape(i).val* tape(i).W(:,:,j)';
                    tape(tape(i).arg1vc).W(:,j)=...
                        tape(tape(i).arg1vc).W(:,j)+temp';
                end
            else
                if m1 == n1
                    for j=1:globp
                        temp = x'\tape(i).W(:,:,j);
                        tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)+temp;
                        temp = (x\tape(i).val)' * tape(i).W(:,:,j) ;
                        tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-temp;
                    end
                else
                    for j=1:globp
                        temp = x'\tape(i).W(:,:,j);
                        tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)+temp;
                        temp = (x'\tape(i).val) * tape(i).W(:,:,j) ;
                        tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-temp;
                    end
                end
            end
        else
            if m == 1 && n == 1
                temp= (x'\tape(i).val) * tape(i).W;
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-...
                    temp;
%                 for j=1:globp
                    temp = x'\tape(i).W;
                    tape(tape(i).arg2vc).W= ...
                        tape(tape(i).arg2vc).W+temp;
%                 end
            else
                if globp > 1                % tape(i).val is a vector
                    for j = 1 : globp
                        temp= x'\tape(i).W(:,j);
                        tape(tape(i).arg2vc).W(:,j) = tape(tape(i).arg2vc).W(:,j) + temp;
                    end
                    
                    for j = 1 : globp
                        temp= (x'\ tape(i).W(:,j))*tape(i).val';
                        tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)-...
                            temp;
                    end
                else
                    temp=x'\tape(i).W;
                    [I,J]=find(tape(tape(i).arg1vc).val);
                    value=-temp(I).*tape(i).val(J);
                    [m,n]=size(tape(tape(i).arg1vc).val);
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sparse(I,J,value,m,n);
                    %tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-temp*tape(i).val';
                end
            end
        end
    end
end
