function sout=horzcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
s1=varargin{1};
if ~isa(s1, 'derivtapeH')
    s1 = derivtapeH(s1,0);
end
sout=s1;
for i=2:nargin
    s2=varargin{i};
    if ~isa(s2, 'derivtapeH')
        s2 = derivtapeH(s2,0);
    end
    [m2,n2]=size(getval(s2));
    [m,n]=size(getval(sout));
    sout.val=[sout.val s2.val];
    temp=derivtape(zeros([m n+n2 globp]),0);
    
    if (m==1)
        sout.deriv=[sout.deriv; s2.deriv];
    else
        if n==1 && n2==1
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,j) s2.deriv(:,j)];
            end
        elseif n2==1
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,:,j) s2.deriv(:,j)];
            end
        elseif n==1
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,j) s2.deriv(:,:,j)];
            end
        else
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,:,j) s2.deriv(:,:,j)];
            end
        end
        sout.deriv=temp;
    end
end
