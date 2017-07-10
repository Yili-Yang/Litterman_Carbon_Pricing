function sout=celltospj2(s1)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


[m,n]=size(s1);
[p,q]=size(s1{1,1});
if (m==1) && (n==1)
    sout = s1{1,1};
elseif (n==1) && (p==1)
    sout=sparse(m,q);
    for i=1:m
        sout(i,:)=s1{i};
    end
else
    sout=s1;
end


