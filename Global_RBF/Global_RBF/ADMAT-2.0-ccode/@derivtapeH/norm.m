function normout=norm(x,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
if nargin < 2 
    p=2; 
end
[m,n]=size(x.val);

if m==1 || n==1                    % vector norm

    if isequal(p, inf)            % infinite norm
        normout=max(abs(x));
    elseif isequal(p, -inf)
        normout=min(abs(x));       % minus infinite norm
    else
        if strcmp(p, 'fro')
            p = 2;
        end
        normout.val=norm(x.val,p);
        if normout.val~=0          % normout.val is nonzero
            if m==1                % x.val is a row vector
                tmp = abs(x.val).^(p-1)./normout.val^(p-1);
                normout.deriv = tmp * x.deriv;
%                 for i=1:globp
%                     normout.deriv(:,i)=((abs(x.val).^(p-1))./(normout.val^(p-1)))*x.deriv(:,i);
%                 end
            else                   % x.val is a column vector
                tmp = abs(x.val).^(p-1)./normout.val^(p-1);
                normout.deriv = tmp' * x.deriv;
%                 for i=1:globp
%                     normout.deriv(:,i)=((abs(x.val).^(p-1))./(normout.val^(p-1)))'*x.deriv(:,i);
%                 end
            end
        else                       % normout.val is a zero
            normout.deriv = ones(1, size(x.deriv,1)) * x.deriv;
%             for i=1:globp
%                 normout.deriv(:,i)=sum(x.deriv(:,i));
%             end
        end
        normout=class(normout,'derivtapeH');
    end

else                          % matrix norm
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



% normout.val=norm(x.val);
% tmp = (x.val./normout.val);
% normout.deriv = tmp .* x.deriv;
% 
% normout=class(normout,'derivtapeH');
