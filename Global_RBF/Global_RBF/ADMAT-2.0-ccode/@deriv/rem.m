function sout=rem(s1,s2)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a 
%              column vector
%   03/2007 -- rearrage the program for readibility
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
s1=deriv(s1);
s2=deriv(s2);
sout.val=rem(s1.val,s2.val);
[m,n]=size(sout.val);
if m==1 && n ==1                    % sout.val is a scalar
                                    % both s1.val and s2.val are scalars
    sout.deriv = s1.deriv - fix(s1.val/s2.val) .* s2.deriv;
else
    if (m==1) || (n==1)                 % sout.val is a vector
        if length(s1.val) == 1          % s1.val is a scalar and s2.val is a vector
            tmp = fix(s1.val ./ s2.val);
            len = length(s2.val);
            sout.deriv = s1.deriv(ones(len,1),:) - tmp(:,ones(1,globp)) .* s2.deriv;
        else  
            if length(s2.val) == 1      % s1.val is a vector and s2.val is a scalar
                tmp = fix(s1.val./s2.val);
                len = length(s1.val);
                sout.deriv = s1.deriv - tmp(:,ones(1,globp)) .* ...
                    s2.deriv(ones(len,1),:);
            else                        % both s1.val and s2.val are vectors
                tmp = fix(s1.val./s2.val);
                sout.deriv = s1.deriv - tmp(:,ones(1,globp)) .* s2.deriv;
            end
        end
    else                               % sout.val is a matrix
        if length(s1.val)==1           % s1.val is a scalar
            tmp = fix(s1.val ./s2.val);
            tmp1 = s1.deriv(ones(n,1), :);
            tmp1 = tmp1(:,:,ones(1,m));
            tmp1 = permute(tmp1, [3,1,2]);
            sout.deriv = tmp1 + tmp(:,:,ones(1,globp)) .* s2.deriv;
            
        elseif length(s2.val)==1         % s2.val is a scalar
            tmp = fix(s1.val./s2.val);
            tmp1 = s2.deriv(ones(n,1), :);
            tmp1 = tmp1(:,:,ones(1,m));
            tmp1 = permute(tmp1, [3,1,2]);
            sout.deriv = s1.deriv - tmp(:,:,ones(1,globp)) .* tmp1;
            
        else                             % both s1.val and s2.val are matrices
            tmp = fix(s1.val./s2.val);
            sout.deriv=s1.deriv-tmp(:,:,ones(1,globp)).*s2.deriv;
        end
    end
end

sout=class(sout,'deriv');
