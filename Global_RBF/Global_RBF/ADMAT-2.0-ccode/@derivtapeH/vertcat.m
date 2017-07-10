function sout=vertcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
s1=varargin{1};
if ~isa(s1, 'derivtapeH')
    s1 = derivtapeH(s1, 0);
end
sout=s1;
if nargin > 1
    for i=2:nargin
        s2=varargin{i};
        if ~isa(s2, 'derivtapeH')
            s2=derivtapeH(s2,0);
        end
        [m,n]=size(getval(sout));
        m2 = size(getval(s2),1);
        sout.val=[sout.val;s2.val];
        temp=derivtape(zeros([m+m2 n globp]),0);

        if n==1
            temp=[sout.deriv; s2.deriv];
        else

            if m2==1 && m==1
                for j=1:globp
                    temp(:,:,j)=[sout.deriv(:,j)'; s2.deriv(:,j)'];
                end
            else

                if m==1
                    for j=1:globp
                        temp(:,:,j)=[sout.deriv(:,j)'; s2.deriv(:,:,j)];
                    end
                elseif m2==1
                    for j=1:globp
                        temp(:,:,j)=[sout.deriv(:,:,j); s2.deriv(:,j)'];
                    end
                else
                    for j=1:globp
                        temp(:,:,j)=[sout.deriv(:,:,j); s2.deriv(:,:,j)];
                    end
                end
            end
        end

        sout.deriv=temp;

    end
end

