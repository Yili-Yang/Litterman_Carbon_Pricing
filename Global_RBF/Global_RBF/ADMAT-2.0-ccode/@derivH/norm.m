function normout=norm(x,p)

% normout.val=norm(x.val);
% normout.derivH=(x.val./normout.val)'*x.derivH;
% 
% normout=class(normout,'derivH');
%
%
%  
%
%   March, 2007 -- add comments and reorganize the program
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin < 2
    p=2;
end

[m,n]=size(x.val);

if m==1 || n==1         % x.val is a vector
    if strcmp(p,'inf')
        normout=max(abs(x));
    elseif strcmp(p,'-inf')
        normout=min(abs(x));
    else                % other norm
        xval = getvalue(x);
        tmp = norm(xval,p);
        normout.val = getval(tmp);
        if normout.val ~=0
            if m==1
                normout.derivH =((abs(xval).^(p-1))./(tmp.^(p-1)))*x.derivH;
            else
                normout.derivH=((abs(xval).^(p-1))./(tmp.^(p-1)))'*x.derivH;
            end
        else
            normout.derivS=sum(x.derivS);
        end

        normout=class(normout,'derivH');
    end

else
    % matrices

    if strcmp(p, 'inf')
        normout=max(sum(abs((x'))));
    elseif strcmp(p,'fro')
        normout=sqrt(sum(diag(x'*x)));
    elseif p==1
        normout=max(sum(abs((x))));
    else
        normout=max(svd(x));
    end

end

