function y=reshape(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
m=deriv(m);
if nargin ==3 
    n=deriv(n); 
end


if ~isa(x,'deriv')
    if nargin ==2
        y=reshape(x,m.val);
    else
        y=reshape(x,m.val,n.val);
    end
else

    if nargin ==2
        y=reshape(x.val,m.val);
    else
        y=reshape(x.val,m.val,n.val);
    end
    y=deriv(y);
    p=size(x.val);
    r=size(y.val);
    if length(r)==3 && length(p)==3
        if nargin ==2
            for i=1:globp 
                y.deriv(:,:,:,i)=reshape(x.deriv(:,:,:,i),m.val); 
            end
        else
            for i=1:globp 
                y.deriv(:,:,:,i)=reshape(x.deriv(:,:,:,i),m.val,n.val);
            end
        end

    elseif length(r)==3
        if nargin ==2
            if (p(1)==1) || (p(2)==1)
                for i=1:globp 
                    y.deriv(:,:,:,i)=reshape(x.deriv(:,i),m.val); 
                end
            else
                for i=1:globp 
                    y.deriv(:,:,:,i)=reshape(x.deriv(:,:,i),m.val);
                end
            end
        else
            for i=1:globp 
                y.deriv(:,:,:,i)=reshape(x.deriv(:,:,i),m.val,n.val); 
            end
        end
    elseif length(p)==3
        if nargin ==2
            if (r(1)==1) || (r(2)==1)
                for i=1:globp 
                    y.deriv(:,i)=reshape(x.deriv(:,:,:,i),m.val); 
                end
            else
                for i=1:globp
                    y.deriv(:,:,i)=reshape(x.deriv(:,:,:,i),m.val); 
                end
            end
        else
            if (r(1)==1) || (r(2)==1)
                for i=1:globp 
                    y.deriv(:,i)=reshape(x.deriv(:,:,:,i),m.val,n.val); 
                end
            else
                for i=1:globp 
                    y.deriv(:,:,i)=reshape(x.deriv(:,:,:,i),m.val,n.val);
                end
            end
        end
    else
        if nargin ==2
            if (p(1)==1) || (p(2)==1)
                if (r(1)==1) || (r(2)==1)
                    for i=1:globp 
                        y.deriv(:,i)=reshape(x.deriv(:,i),m.val);
                    end
                else
                    for i=1:globp 
                        y.deriv(:,:,i)=reshape(x.deriv(:,i),m.val);
                    end
                end
            else
                if (r(1)==1) || (r(2)==1)
                    for i=1:globp 
                        y.deriv(:,i)=reshape(x.deriv(:,:,i),m.val); 
                    end
                else
                    for i=1:globp 
                        y.deriv(:,:,i)=reshape(x.deriv(:,:,i),m.val);
                    end
                end
            end
        else

            if (p(1)==1) || (p(2)==1)
                if (r(1)==1) || (r(2)==1)
                    y.deriv=x.deriv;
                else
                    for i=1:globp
                        y.deriv(:,:,i)=reshape(x.deriv(:,i),m.val,n.val); 
                    end
                end
            else
                if (r(1)==1) || (r(2)==1)
                    for i=1:globp 
                        y.deriv(:,i)=reshape(x.deriv(:,:,i),m.val,n.val); 
                    end
                else
                    for i=1:globp 
                        y.deriv(:,:,i)=reshape(x.deriv(:,:,i),m.val,n.val);
                    end

                end
            end
        end
    end

end
