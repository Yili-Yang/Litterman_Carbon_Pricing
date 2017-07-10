function sout=horzcatcell(s1,s2)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if iscell(s1) && iscell(s2)
    [m,n]=size(s1);
    sout = cell(m,n);
    for i=1:m
        for j=1:n
            sout{i,j}=[s1{i,j} s2{i,j}];
        end
    end
elseif iscell(s1) && ~iscell(s2)
    [m,n]=size(s1);
    sout = cell(m,n);
    for i=1:m
        for j=1:n
            sout{i,j}=[s1{i,j} s2(i,j)];
        end
    end
else
    [m,n]=size(s2);
    sout = cell(m,n);
    for i=1:m
        for j=1:n
            sout{i,j}=[s1(i,j) s2{i,j}];
        end
    end
end
