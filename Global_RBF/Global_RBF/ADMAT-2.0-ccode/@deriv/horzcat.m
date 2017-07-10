function sout=horzcat(varargin)
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
s1=varargin{1};
s1=deriv(s1);
sout=s1;
for i=2:nargin
    s2=varargin{i};
    s2=deriv(s2);
    [m2,n2]=size(s2.val);
    [m,n]=size(sout.val);
    sout.val=[sout.val s2.val];
    if (m==1)
        sout.deriv=[sout.deriv; s2.deriv];
    else
        temp=zeros([size(sout.val),globp]);
        if n==1 && n2==1                  % s1.val and s2.val are vecotrs
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,j) s2.deriv(:,j)];
            end
        elseif n2==1 && n > 1
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,:,j) s2.deriv(:,j)];
            end
        elseif n==1 && n2 >1
            for j=1:globp
                temp(:,:,j)=[sout.deriv(:,j) s2.deriv(:,:,j)];
            end
        else
            temp = [sout.deriv s2.deriv];
%             for j=1:globp
%                 temp(:,:,j)=[sout.deriv(:,:,j) s2.deriv(:,:,j)];
%             end
        end
        sout.deriv=temp;
    end
end
