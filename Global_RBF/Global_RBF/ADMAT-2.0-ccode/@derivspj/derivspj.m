function s= derivspj(a,V)
%
% DERIVSPJ  --  Construct DERIVSPJ Objects
%
%   S=derivpj(a) constructs the object S, of class derivspj from a.
%   If the input argument is a numerical scalar or matrix, the
%   result is a derivspj object having the same value and
%   derivative field set to 0.
%
%   If input is a derivspj object, it is returned as it is.
%
%   S=derivspj(a,V) sets the derivative field of the output to
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
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end
%
%
if nargin==0
    s.val=0;
    s.derivspj=sparse(1,globp);
    s=class(s,'derivspj');
elseif nargin==1
    if isempty(a)
        s.val=[];
        s.derivspj=[];
        s=class(s,'derivspj');
    elseif isa(a,'derivspj')
        s=a;
    else
        s.val=a;
        if isstruct(a) 
            error('Wrong use of derivspj class');
        end
        [m,n]=size(getval(a));
        if ((m==1) && (n==1))
            s.derivspj=sparse(1,globp);
        elseif (m==1)
            s.derivspj=sparse(n,globp);
        elseif (n==1)
            s.derivspj=sparse(m,globp);
        else
            %	if globp > 1
            s.derivspj=cell(globp,1);
            for i=1:globp 
                s.derivspj{i}=sparse(m,n); 
            end
            %	else
            %		s.derivspj=sparse(m,n);
            %	end
        end
        s=class(s,'derivspj');
    end
else    
%     if iscell(V)
%         globp = size(V,1);
%     else
%         globp = size(V,2);
%     end
% 
%     s.val = a;
%     s.derivspj=V;
   if iscell(V)
        globp = size(V,1);
        s.val = a;
        s.derivspj=V;
    else
        [m,n] = size(a);
        if m>1 && n>1
            globp = size(V,3);
              s.val = a;
            if globp > 1
                for i = 1 : globp
                    s.derivspj{i} = sparse(V(:,:,i));
                end
            else  % globp == 1
                s.derivspj{1} = sparse(V);
            end    
            % s=class(s,'derivspj');
        elseif m == 1 || n==1
            globp = size(V,2);
            s.val = a;  
            s.derivspj = V;
            
        end
    end 
     s=class(s,'derivspj');
end
