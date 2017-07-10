function sout=triu(s1)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


[m,n] = size(s1);
sout = cell(m,n);

for i=1:m
    for j=1:n
        sout{i,j}=triu(s1{i,j});
    end
end
