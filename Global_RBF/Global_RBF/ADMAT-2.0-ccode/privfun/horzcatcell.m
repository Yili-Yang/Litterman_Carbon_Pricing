function sout=horzcatcell(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
sout = cell(globp, globp);
for i=1:globp
    for j=1:globp
        sout{i,j}=[s1(i,j) s2(i,j)];
    end
end
