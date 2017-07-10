function sout=mtimes(s1,s2)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if ~iscell(s1) 
    s11=cell(1); 
    s11{1}=s1;
    s1=s11;
end

if ~iscell(s2) 
    s12=cell(1);
    s12{1}=s2;
    s2=s12;
end

[m,n]=size(s1);
[p,q]=size(s1{1});
if (m==1) && (n~=1)
    sout=sparse(p,q);
    for i=1:n
        sout=sout+s1{i};
    end

else

    sout=sparse(m,q);
    for i=1:m
        temp=sum(s1{i});
        sout(i,:)=temp;
    end

end
