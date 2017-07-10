function south=updatesph(q2,s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
s1h=s1.derivsph;
s1j=getspj(s1);
q1=length(getval(s1));

% JUST ONE SPH

if q1==1 && q2~=1
    for i=1:globp
        for j=1:globp
            south{i,j}=s1h(i,j)+s1j'*s1j;
        end
    end
elseif q1==1
    south=s1h+s1j'*s1j;
else

    for i=1:globp
        for j=1:globp
            south{i,j}=s1j(:,i).*s1j(:,j);
        end
    end
    south=south+s1h;
end




