function y=permute(x,p)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
p=deriv(p);
y=permute(x.val,p.val);
y=deriv(y);


r=size(y.val);
s=size(x.val);
if length(r)==3
    if length(s)==3
        y.deriv = permute(x.deriv, [p.val; 4]);
%         for i=1:globp 
%             y.deriv(:,:,:,i)=permute(x.deriv(:,:,:,i),p.val);
%         end
    else
        if s(1)==1 || s(2)==1
            for i=1:globp 
                y.deriv(:,:,:,i)=permute(x.deriv(:,i),p.val); 
            end
        else
            for i=1:globp 
                y.deriv(:,:,:,i)=permute(x.deriv(:,:,i),p.val);
            end
        end
    end
else
    if r(1)==1 || r(2)==1
        for i=1:globp 
            y.deriv(:,i)=permute(x.deriv(:,i),p.val); 
        end
    else
        for i=1:globp 
            y.deriv(:,:,i)=permute(x.deriv(:,:,i),p.val); 
        end
    end

end
