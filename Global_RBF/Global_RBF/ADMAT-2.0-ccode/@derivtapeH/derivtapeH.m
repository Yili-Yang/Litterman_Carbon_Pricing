function s= derivtapeH(a,i,V)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
% Derivative class for AD of M-files
%
global globp;
global tape_begin;
global varcounter;
% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end

if nargin==0
    s.val=derivtape(0);
    s.deriv=derivtape(0);
    s=class(s,'derivtapeH');
elseif isa(a,'derivtapeH')
    s.val=a.val;
    s.deriv=a.deriv;
    s=class(s,'derivtapeH');
    if nargin==3 
        s.deriv=derivtape(V); 
    end
else 
    if ~isa(a,'derivtape') 
        a = derivtape(a);
    end    
    s.val=a;
    [m,n]=size(getval(a));
    if nargin == 3 
        s.deriv=derivtape(V);
        if m==1||n==1 
            globp=size(V,2); 
        else
            globp=size(V,3); 
        end
    else
        if ((m==1) && (n==1))
            s.deriv=derivtape(zeros(1,globp));
        elseif (m==1)
            s.deriv=derivtape(zeros(n,globp));
        elseif (n==1)
            s.deriv=derivtape(zeros(m,globp));
        else
            s.deriv=derivtape(zeros(m,n,globp));
        end
    end
    s=class(s,'derivtapeH');
end
if nargin >= 2
    if i == 1
        tape_begin = varcounter; 
    end
    tmp = getval(s.val);
    s.val = derivtape(tmp,i);
    tmp = getval(s.deriv);
    s.deriv = derivtape(tmp,0);
end
        