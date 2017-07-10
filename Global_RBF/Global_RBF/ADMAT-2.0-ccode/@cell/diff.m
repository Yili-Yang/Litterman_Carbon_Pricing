function sout=diff(s1, N, DIM)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


[m,n]=size(s1);
sout = cell(m,n);
if nargin == 1
    N = 1;
    if m == 1
        DIM = 2;
    else
        DIM = 1;
    end
else if nargin == 2
        if m == 1
            DIM = 2;
        else
            DIM = 1;
        end
    end
end

if nargin < 3 && m == 1
    DIM = 1;
end
for i=1:m
    for j=1:n
        sout{i,j}=diff(s1{i,j}, N, DIM);
    end
end
