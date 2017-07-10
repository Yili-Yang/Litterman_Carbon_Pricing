function normout=norm(x,p)
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%

if nargin < 2
    p=2;
end

[m,n]=size(x.val);

if m==1 || n==1         % x.val is a vector
    if isequal(p, inf)
        normout=max(abs(x));
    elseif isequal(p,-inf)
        normout=min(abs(x));
    else                % other norm
        normout.val=norm(x.val,p);
        if normout.val~=0
            if m==1
                normout.derivS=((abs(x.val).^(p-1))./(normout.val^(p-1)))*x.derivS;
            else
                normout.derivS=((abs(x.val).^(p-1))./(normout.val^(p-1)))'*x.derivS;
            end
        else
            normout.derivS=sum(x.derivS);
        end

        normout=class(normout,'derivS');
    end

else
    % matrices

    if isequal(p, inf)
        normout=max(sum(abs((x'))));
    elseif strcmp(p,'fro')
        normout=sqrt(sum(diag(x'*x)));
    elseif p==1
        normout=max(sum(abs((x))));
    else
        normout=max(svd(x));
    end

end

