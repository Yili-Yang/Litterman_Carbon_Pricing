function s= derivsph(a,V)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
global ADhess;
ADhess=1;

% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end

%
if nargin==2
    if iscell(V)
        globp = size(V,1);
    else
        globp = size(V,2);
    end
end

if nargin==0
    s.val = derivspj;
    s.derivsph = sparse(globp,globp);
    s = class(s,'derivsph');
else
    if isempty(a)
        s.val = derivspj([]);
        s.derivsph = [];
        s=class(s,'derivsph');
    elseif isa(a,'derivsph')
        s=a;
    else
        if nargin==2
            s.val=derivspj(a,V);
        else
            s.val=derivspj(a);
        end
        [m,n]=size(getval(a));
        if ((m==1) && (n==1))
            s.derivsph = sparse(globp,globp);
        else
            s.derivsph = cell(globp,globp);
            for i=1: globp
                for j=1:globp
                    s.derivsph{i,j}=sparse(m,n);
                end
            end
        end
        s=class(s,'derivsph');
    end
 
end
