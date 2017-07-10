function sout=mpower(s1,s2)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   04/2007 -- remove the case s1.val or s2.val is a vector and
%              the case both of them are matrices since one of 
%              them must be a scalar 
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
sout.val=getval(s1)^getval(s2);
[m,n] = size(sout.val);
if ~isempty(sout.val)
    if ~isa(s1,'deriv')
        val2=sout.val.*log(s1);
        if m==1 && n ==1
            sout.deriv = val2 .* s2.deriv;
        else
            if length(s1)==1          % s1 is a scalar
                sout.deriv = val2(:, :,ones(1,globp)) .*s2.deriv;
            elseif length(s2.val)==1  % s2.val is a scalar
                tmp = s2.deriv(ones(n,1), :);
                tmp = tmp(:,:,ones(1, m));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = val2(:,:, ones(1,globp)) .* tmp;
            end
        end

    elseif ~isa(s2,'deriv')        % s2 does not belong to deriv class 
        val1=s2.*(s1.val.^(s2-1));
        if m ==1 && n == 1
            sout.deriv = val1 .* s1.deriv;
        else
            % sout.val is a matrix
            if length(s1.val)==1      % s1.val is a scalar
                tmp = s1.deriv(ones(n,1), :);
                tmp = tmp(:,:,ones(1,m));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = val1(:,:,ones(1,globp)) .* tmp;
            elseif length(s2)==1    % s2 is a scalar
                sout.deriv = val1(:,:,ones(1,globp)) .* s1.deriv;
            end
        end

    else                           % both s1 and s2 belong to deriv class
        
        val1=s2.val.*(s1.val.^(s2.val-1));
        val2=sout.val.*log(s1.val);
        if m == 1 && n == 1
            sout.deriv = val1 .* s1.deriv + val2 .* s2.deriv;
        else
            % sout.val is a matrix
            if length(s1.val)==1        % s1.val is a scalar and s2.val is a matrix
                tmp = s1.deriv(ones(n,1), :);
                tmp = tmp(:,:,ones(1, m));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = val1(:,:,ones(1,globp)) .* tmp + ...
                    val2(:,:,ones(1,globp)) .* s2.deriv;
            elseif length(s2.val)==1     % s2.val is a scalar
                tmp = s2.deriv(ones(n,1), :);
                tmp = tmp(:,:,ones(1,m));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = val1(:,:,ones(1,globp)) .* s1.deriv + ...
                    val2(:,:,ones(1,globp)) .* tmp;
            end
        end
    end
    sout=class(sout,'deriv');
else
    sout=[];
end

