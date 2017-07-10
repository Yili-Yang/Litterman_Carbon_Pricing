function s= derivS(a,V)
%
% DERIVS  --  Construct DERIVS Objects
%
%   S=derivS(a) constructs the object S, of class derivS from a.
%   If the input argument is a numerical scalar or matrix, the
%   result is a derivS object having the same value and
%   derivSative field set to 0.
%
%   If input is a derivS object, it is returned as it is.
%
%   S=derivS(a,V) sets the derivSative field of the output to
%   be equal to V.
%
%   Also see getval, getydot, derivStape, derivSspj, derivSsph
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
global Lflag;


% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end

%
%
if nargin==0
    s.val=0;
    s.derivS=0;
    s=class(s,'derivS');
else
    if isempty(a)
        s.val=[];
        s.derivS=[];
        s=class(s,'derivS');
    elseif isa(a,'derivS')
        s=a;
    else
        s.val=a;
        m=size(a);
        if (length(m)==2)
            n=m(2);
            m=m(1);
            if ((m==1) && (n==1))
                s.derivS=0;
            elseif (m==1)
                s.derivS=zeros(n,1);
            elseif (n==1)
                s.derivS=zeros(m,1);
            else
                if issparse(s.val)
                    s.derivS=sparse(m,n);
                else
                    s.derivS=zeros(m,n);
                end
            end
        else
            s.derivS=zeros(m);
        end
        s=class(s,'derivS');
    end
    if nargin==2
        s.derivS=V;
    end
end
