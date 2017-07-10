function sout=celltospj(s1)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
if globp==1
    sout=s1{1};
else
    [m,n]=size(s1{1});
    if (n==1) && (m==1)
        sout = cell(globp,1);
        for i=1:globp
            sout{i}=s1{i}(:);
        end
    else
        sout=s1;
    end

end

