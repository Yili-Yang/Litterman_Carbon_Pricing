function y = reshape(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
global tape;
m = getval(m);
if nargin ==3 
    n = getval(n);
end


if ~isa(x,'derivtapeH')
    if nargin ==2
        y.val=reshape(x,m);
    else
        y.val=reshape(x,m,n);
    end
else
    if nargin ==2
        y.val=reshape(x.val,m);
    else
        y.val=reshape(x.val,m,n);
    end
    % y=derivtapeH(y,0);
    p=size(getval(x.val));
    r=size(getval(y.val));
    if length(r)==3 && length(p)==3
        if nargin ==2
            for i=1:globp 
                y.deriv(:,:,:,i) = reshape(x.deriv(:,:,:,i),m); 
            end
        else
            for i=1:globp 
                y.deriv(:,:,:,i) = ...
                    reshape(x.deriv(:,:,:,i),m,n);
            end
        end

    elseif length(r)==3
        if nargin ==2
            if (p(1)==1) || (p(2)==1)
                for i=1:globp 
                    y.deriv(:,:,:,i)=reshape(x.deriv(:,i),m); 
                end
            else
                for i=1:globp 
                    y.deriv(:,:,:,i)=reshape(x.deriv(:,:,i),m);
                end
            end
        else
            for i=1:globp 
                y.deriv(:,:,:,i) = ...
                    reshape(x.deriv(:,:,i),m,n);
            end
        end
    elseif length(p)==3
        if nargin ==2
            if (r(1)==1) || (r(2)==1)
                y.deriv = zeros(m,globp);
                y.deriv = cons(y.deriv, x.deriv);
                for i=1:globp 
                    y.deriv(:,i)=reshape(x.deriv(:,:,:,i),m);
                end
            else
                for i=1:globp 
                    y.deriv(:,:,i)=reshape(x.deriv(:,:,:,i),m); 
                end
            end
        else
            if (r(1)==1) || (r(2)==1)
                for i=1:globp 
                    y.deriv(:,i) = ...
                        reshape(x.deriv(:,:,:,i),m,n); 
                end
            else
               y.deriv = zeros(m,n,globp);
               y.deriv = cons(y.deriv, x.deriv);
                for i=1:globp 
                    y.deriv(:,:,i) = ...
                        reshape(x.deriv(:,:,:,i),m,n); 
                end
            end
        end
    else
        if nargin ==2
            if (p(1)==1) || (p(2)==1)
                if (r(1)==1) || (r(2)==1)
                   y.deriv = zeros(m,globp);
                   y.deriv = cons(y.deriv, x.deriv);
                    for i=1:globp 
                        y.deriv(:,i)=reshape(x.deriv(:,i),m); 
                    end
                else
                    for i=1:globp 
                        y.deriv(:,:,i)=reshape(x.deriv(:,i),m);
                    end
                end
            else
                if (r(1)==1) || (r(2)==1)
                    y.deriv = zeros(m,globp);
                    y.deriv = cons(y.deriv, x.deriv);
                    for i=1:globp
                        y.deriv(:,i)=reshape(x.deriv(:,:,i),m);
                    end
                else
                    for i=1:globp 
                        y.deriv(:,:,i)=reshape(x.deriv(:,:,i),m);
                    end
                end
            end
        else

            if (p(1)==1) || (p(2)==1)
                if (r(1)==1) || (r(2)==1)
                    y.deriv = reshape(x.deriv, m,n);
                    % y.deriv = setxdot(y.deriv, getval(x.deriv));
                    % y.deriv=x.deriv;
                else
                   y.deriv = zeros(m,n,globp);
                   y.deriv = cons(y.deriv, x.deriv);
                    for i=1:globp 
                        y.deriv(:,:,i) = reshape(x.deriv(:,i),m,n); 
                    end
                end
            else
                if (r(1)==1) || (r(2)==1)
                    for i=1:globp
                        y.deriv(:,i) = ...
                            reshape(x.deriv(:,:,i),m,n); 
                    end
                else
                    y.deriv = zeros(m,n,globp);
                    y.deriv = cons(y.deriv, x.deriv);
                    for i=1:globp 
                        y.deriv(:,:,i) = ...
                            reshape(x.deriv(:,:,i),m,n);
                    end

                end
            end
        end
    end

end

y = class(y, 'derivtapeH');
