function s= deriv(a,V)
%
% DERIV  --  Construct DERIV Objects
%
%   S=deriv(a) constructs the object S, of class deriv from a.
%   If the input argument is a numerical scalar or matrix, the 
%   result is a deriv object having the same value and 
%   derivative field set to 0.
%
%   If input is a deriv object, it is returned as it is.
%
%   S=deriv(a,V) sets the derivative field of the output to
%   be equal to V.
%
%   Also see getval, getydot, derivtape, derivspj, derivsph

%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
global globp;
% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.');
% end


%
%
if nargin==0
    s.val=0;
    s.deriv=zeros(1,globp);
    s=class(s,'deriv');
else
    if isempty(a)
        s.val=[];
        s.deriv=[];
        s=class(s,'deriv');
    elseif isa(a,'deriv')
        s=a;
        if globp==1 && issparse(s.val)
            s.deriv=full(s.deriv);
        end
    else
        s.val=a;
        m=size(a);
        if (length(m)==2)
            n=m(2);
            m=m(1);
            if ((m==1) && (n==1))
                s.deriv=zeros(1,globp);
            elseif (m==1)
                s.deriv=zeros(n,globp);
            elseif (n==1)
                s.deriv=zeros(m,globp);
            else
                if globp==1 && issparse(s.val)
                    s.deriv=sparse(m,n);
                else
                    s.deriv=zeros(m,n,globp);
                end
            end

        else
            s.deriv=zeros([m globp]);
        end
        s=class(s,'deriv');
    end
    if nargin==2
        s.deriv=V;
        [p,q]=size(s.val);

        if (p > 1) && (q > 1)
            globp=size(V,3);
        else
            globp=size(V,2);
        end
    end
end
