function y=reshape(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m=derivS(m);
if nargin ==3 
    n=derivS(n);
end

if ~isa(x,'derivS')
    if nargin ==2
        y=reshape(x,m.val);
    else
        y=reshape(x,m.val,n.val);
    end
else            % x belongs to derivS
    if nargin ==2
        y=reshape(x.val,m.val);
    else
        y=reshape(x.val,m.val,n.val);
    end
    y=derivS(y);
    
    if nargin ==2
        y.derivS=reshape(x.derivS,m.val);
    else
        y.derivS=reshape(x.derivS,m.val,n.val);
    end

    if ndims(y.val)==2
        [p,q]=size(y.val);
        if p==1 && q~=1 
            y.derivS=y.derivS(:);
        end
    end

end


