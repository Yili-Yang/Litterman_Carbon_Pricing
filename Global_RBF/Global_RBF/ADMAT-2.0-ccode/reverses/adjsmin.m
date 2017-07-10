function adjsmin(i)
%
%
%  04/2007 -- rearrage the program for readibilty
%  04/2007 -- correct the computation of derivative
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global tape;

[m,n] = size(tape(i).val);
if isempty(tape(i).arg2vc)
    [temp,I]=min(tape(tape(i).arg1vc).val);
    if m == 1 && n == 1
        tape(tape(i).arg1vc).W(I) = tape(tape(i).arg1vc).W(I) + ...
            tape(i).W;
    else                  % m == 1 && n > 1
        for j = 1 : n
            tape(tape(i).arg1vc).W(I(j), j) = tape(tape(i).arg1vc).W(I(j), j) + ...
                tape(i).W(I(j),j);
        end
    end
    
elseif size(tape(i).val,1)==1 || size(tape(i).val,2)==1
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    I1=find(x - y > 0);
    I2=find(x - y == 0);
    I3=find(x - y < 0);
    if length(x)==1
        if ~isempty(I3) 
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                sum(tape(i).W(I3));
        end
        if ~isempty(I1)
            tape(tape(i).arg2vc).W(I1) = tape(tape(i).arg2vc).W(I1) + ...
                tape(i).W(I1);
        end
        if ~isempty(I2)
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                sum(tape(i).W(I2))./2;
            tape(tape(i).arg2vc).W(I2) = tape(tape(i).arg2vc).W(I2) + ...
                tape(i).W(I2)/2;
        end
    elseif length(y)==1
        if ~isempty(I1) 
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(tape(i).W(I1));
        end
        if ~isempty(I3)
            tape(tape(i).arg1vc).W(I3) = tape(tape(i).arg1vc).W(I3) + ...
                tape(i).W(I3); 
        end
        if ~isempty(I2)
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(tape(i).W(I2))/2;
            tape(tape(i).arg1vc).W(I2)=tape(tape(i).arg1vc).W(I2)+...
                tape(i).W(I2)/2;
        end
    else                              % both x and y are vectors
        if ~isempty(I1) 
            tape(tape(i).arg2vc).W(I1)=tape(tape(i).arg2vc).W(I1) + ...
                tape(i).W(I1);
        end
        if ~isempty(I3) 
            tape(tape(i).arg1vc).W(I3) = tape(tape(i).arg1vc).W(I3)+...
                tape(i).W(I3);
        end
        if ~isempty(I2)
            tape(tape(i).arg2vc).W(I2)=tape(tape(i).arg2vc).W(I2)+...
                tape(i).W(I2)/2;
            tape(tape(i).arg1vc).W(I2)=tape(tape(i).arg1vc).W(I2)+...
                tape(i).W(I2)/2;
        end
    end

else                             % output is a matrix
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    [I1,I1j]=find(x-y > 0);
    [I2,I2j]=find(x-y == 0);
    [I3,I3j]=find(x-y < 0);
    if length(x)==1
        if ~isempty(I3) 
            for j=1:length(I3) 
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tape(i).W(I3(j),I3j(j)); 
            end; 
        end
        if ~isempty(I1) 
            for j=1:length(I1)
                tape(tape(i).arg2vc).W(I1(j),I1j(j),:) = tape(tape(i).arg2vc).W(I1(j),I1j(j),:) + ...
                    tape(i).W(I1(j),I1j(j),:); 
            end 
        end
        if ~isempty(I2)
            for j = 1 : length(I2)
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                sum(tape(i).W(I2(j), I2j(j)))./2;
            tape(tape(i).arg2vc).W(I2(j),I2j(j)) = tape(tape(i).arg2vc).W(I2(j), I2(j))+...
                tape(i).W(I2(j), I2j(j))/2;
            end
        end
    elseif length(y)==1
        if ~isempty(I1) 
            for j=1:length(I1) 
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    tape(i).W(I1(j),I1j(j)); 
            end
        end
        if ~isempty(I3)
            for j=1:length(I3) 
                tape(tape(i).arg1vc).W(I3(j),I3j(j))=tape(tape(i).arg1vc).W(I3(j),I3j(j))+...
                    tape(i).W(I3(j),I3j(j));
            end
        end
        if ~isempty(I2)
            for j=1:length(I2)
                tape(tape(i).arg2vc).W =tape(tape(i).arg2vc).W+...
                    tape(i).W(I2(j),I2j(j))/2;
                tape(tape(i).arg1vc).W(I2(j),I2j(j))=tape(tape(i).arg1vc).W(I2(j),I2j(j))+...
                    tape(i).W(I2(j),I2j(j))/2;
            end
        end
    else                                       % both x and y are matrices
        if ~isempty(I1)
            for j=1:length(I1)
                tape(tape(i).arg2vc).W(I1(j),I1j(j))=tape(tape(i).arg2vc).W(I1(j),I1j(j))+...
                    tape(i).W(I1(j),I1j(j)); 
            end
        end
        if ~isempty(I3) 
            for j=1:length(I3) 
                tape(tape(i).arg1vc).W(I3(j),I3j(j))=tape(tape(i).arg1vc).W(I3(j),I3j(j))+...
                    tape(i).W(I3(j),I3j(j)); 
            end
        end
        if ~isempty(I2)
            for j = 1 : length(I2)
                tape(tape(i).arg2vc).W(I2(j),I2j(j))=tape(tape(i).arg2vc).W(I2(j),I2j(j))+...
                    tape(i).W(I2(j),I2j(j))/2;
                tape(tape(i).arg1vc).W(I2(j),I2j(j))=tape(tape(i).arg1vc).W(I2(j),I2j(j))+...
                    tape(i).W(I2(j),I2j(j))/2;
            end
        end
    end
end

