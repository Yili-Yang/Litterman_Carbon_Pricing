function sout=ldivide(s2,s1)
%
%
%   03/2007 -- matrix operation is used to avoid
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a
%              column vector
%   04/2007 -- consider the case s1.val is a row vector
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
sout.val=getval(s2).\getval(s1);

if ~isempty(sout.val)
    if ~isa(s1,'deriv')                 % s1 is not an instance of deriv class
        if issparse(s2.deriv)
            m = prod(size(s2.val));
            tmp = -sout.val ./ s2.val;
            [ib,jb,sb] = find(s2.deriv);
            sout.deriv = sparse(ib,jb, reshape(tmp(ib), size(sb)).*sb, m, globp);
        else
            [m,n]=size(sout.val);
            if m==1 && n==1                % sout.val is a scalar
                tmp = -s1./(s2.val.*s2.val);
                sout.deriv = tmp .* s2.deriv;
            elseif (m==1) || (n==1)             % sout.val is a vector
                if n == 1                       % sout.val is a column vector
                    tmp = -s1./(s2.val.*s2.val);
                    if length(s2.val) == 1           % s2.val is a scalar
                        sout.deriv = tmp(:, ones(1,globp)) .* s2.deriv(ones(m,1),:);
                    else                             % s2.val is a column vector
                        if size(s2.deriv, 2) == size(tmp, 2)
                            sout.deriv = tmp .* s2.deriv;
                        else
                            sout.deriv = tmp(:, ones(1,globp)) .* s2.deriv;
                        end
                    end
                else                            % sout.val is a row vector
                    tmp = -s1./(s2.val.*s2.val);
                    tmp = tmp(:);
                    if length(s2.val) == 1
                        sout.deriv = tmp(:, ones(1,globp)) .* ...
                            s2.deriv(ones(length(s1),1),:);
                    else
                        sout.deriv = tmp(:, ones(1,globp)) .* s2.deriv;
                    end
                end
            else                            % sout.val is a matrix
                if length(s1)==1            % s1 is a scalar
                    tmp = -s1./(s2.val.*s2.val);
                    sout.deriv = tmp(:,:, ones(1,globp)) .* s2.deriv;
                elseif length(s2.val)==1    % s2.val is a scalar
                    tmp = -s1./(s2.val.*s2.val);
                    tmp1 = s2.deriv(ones(n,1),:);
                    tmp1 = tmp1(:,:,ones(1,m));
                    tmp1 = permute(tmp1, [3,1,2]);
                    sout.deriv = tmp(:,:,ones(1,globp)) .* tmp1;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=  (-s1./(s2.val.*s2.val)).*s2.deriv(i);
                    %                 end
                else                        % both s1 and s2.val are matrices
                    tmp = -s1./(s2.val.*s2.val);
                    sout.deriv=  tmp(:,:,ones(1,globp)).*s2.deriv;
                end
            end
        end
    elseif ~isa(s2,'deriv')
        if issparse(s1.deriv)
            bb = 1./s2(:);
            if prod(size(s2)) == 1
                sout.deriv = bb * s1.deriv;
            else
                m = prod(size(s1.val));
                [ia,ja,sa] = find(s1.deriv);
                sout.deriv = sparse(ia,ja, reshape(bb(ia), size(sa)).*sa, m, globp);
            end
        else
            [m,n]=size(sout.val);
            if m==1 && n ==1             % sout.val is a scalar
                tmp = 1./s2;
                sout.deriv = tmp .* s1.deriv;
            elseif (m==1) || (n==1)           % sout.val is a vector
                if n == 1                % column vector
                    tmp = ones(m,1)./s2;
                    if length(s1.val) == 1              % s1.val is a scalar
                        sout.deriv = tmp(:, ones(1, globp)) .* ...
                            s1.deriv(ones(length(s2),1), :);
                    else                      % s1.val is a vector
                        if size(s1.deriv,2) == size(tmp, 2)
                            sout.deriv = tmp .* s1.deriv;
                        else
                            sout.deriv = tmp(:, ones(1, globp)) .* s1.deriv;
                        end
                    end
                else                     % row vector
                    tmp = ones(1,n)./s2;
                    tmp = tmp(:);
                    if length(s1.val) == 1            % s1.val is a scalar
                        sout.deriv = tmp(:, ones(1,globp)) .* ...
                            s1.deriv(ones(length(s2),1), :);
                    else
                        sout.deriv = tmp(:, ones(1,globp)) .* s1.deriv;
                    end
                end
            else                          % sout.val is a matrix
                if length(s1.val)==1      % s1.val is a scalar
                    tmp = 1./s2;
                    tmp1 = s1.deriv(ones(n,1),:);
                    tmp1 = tmp1(:,:,ones(1,m));
                    tmp1 = permute(tmp1, [3,1,2]);
                    sout.deriv = tmp(:,:,ones(1,globp)) .* tmp1;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=(1./s2).*s1.deriv(i);
                    %                 end
                elseif length(s2)==1      % s2 is a scalar
                    sout.deriv=(1/s2).*s1.deriv;
                else                      % Both s1.val and s2 are matrices
                    tmp = 1./s2;
                    sout.deriv = tmp(:,:, ones(1, globp)) .* s1.deriv;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=(1./s2).*s1.deriv(:,:,i);
                    %                 end
                end
            end
        end

    else                        % both s1 and s2 belong to deriv class
        if issparse(s1.deriv) | issparse(s2.deriv)
            m = prod(size(s1.val));
            if prod(size(s2.val)) == 1
                bx = sparse(s2.val(:));
                D = 1./ sqr(bx);
                tmp = bx * s1.deriv - s1.val * s2.deriv;
                [i,j,s] = find(tmp);
                sout.deriv = sparse(i,j,s.*D, m,  globp);
            elseif m == 1
                n = prod(size(s2.val));
                sout.deriv = sparse(1:n, 1:n, 1./sqr(s2.val(:))) * ...
                  (s2.val(:)*s1.deriv - s1.val*s2.deriv);   
            else
                sout.deriv = sparse(1:m,1:m,1./sqr(s2.val(:))) * ...
                    (sparse(1:m,1:m, s2.val(:)) * s1.deriv - sparse(1:m,1:m, s1.val(:))*s2.deriv);
            end
        else
            [m,n]=size(sout.val);
            if (m==1) || (n==1)     % sout.val is a vector or scalar
                tmp1 = 1./s2.val;
                tmp2 = s1.val./(s2.val.*s2.val);
                if m == 1 && n == 1            % sout.val is a scalar
                    sout.deriv = tmp1 .* s1.deriv - tmp2 .* s2.deriv;
                else
                    if length(s1.val) == 1     % s1.val is a scalar
                        if n == 1              % coulmn vector
                            sout.deriv = tmp1(:, ones(1,globp)).* ...
                                s1.deriv(ones(m,1), :) - ...
                                tmp2(:,ones(1,globp)) .* s2.deriv;
                        else                   % row vector
                            tmp1 = tmp1(:);
                            tmp2 = tmp2(:);
                            sout.deriv = tmp1(:, ones(1,globp)).* ...
                                s1.deriv(ones(n,1), :) - ...
                                tmp2(:,ones(1,globp)) .* s2.deriv;
                        end
                    else
                        if length(s2.val) == 1          % s2.val is a scalar
                            if n == 1                   % column vector
                                sout.deriv = tmp1 .* s1.deriv - ...
                                    tmp2(:, ones(1, globp)) .* ...
                                    s2.deriv(ones(m,1), :);
                            else                        % row vector
                                tmp1 = tmp1(:);
                                tmp2 = tmp2(:);
                                sout.deriv = tmp1 .* s1.deriv - ...
                                    tmp2(:, ones(1, globp)) .* ...
                                    s2.deriv(ones(n,1), :);
                            end
                        else                          % both s1.val and s2.val are vectors
                            if n == 1                % column vector
                                if size(tmp1, 2) == size(s1.deriv, 2) && ...
                                        size(tmp2, 2) == size(s2.deriv, 2)
                                    sout.deriv = tmp1 .* s1.deriv - ...
                                        tmp2 .* s2.deriv;
                                else
                                    sout.deriv = tmp1(:,ones(1,globp)) .* s1.deriv - ...
                                        tmp2(:, ones(1,globp)) .* s2.deriv;
                                end
                            else                     % row vector
                                tmp1 = tmp1(:);
                                tmp2 = tmp2(:);
                                sout.deriv = tmp1(:,ones(1,globp)) .* s1.deriv - ...
                                    tmp2(:, ones(1,globp)) .* s2.deriv;
                            end
                        end
                    end
                end
            else                   % sout.val is a matrix
                if length(s1.val)==1         % s1.val is a scalar
                    val1 = 1./s2.val;
                    val2 = s1.val./(s2.val.*s2.val);
                    tmp = s1.deriv(ones(n,1),:);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp,[3,1,2]);
                    sout.deriv = val1(:,:,ones(1,globp)) .* tmp - ...
                        val2(:,:,ones(1,globp)) .* s2.deriv;
                elseif length(s2.val)==1      % s2.val is a scalar
                    val1 = 1./s2.val;
                    val2 = s1.val./(s2.val.*s2.val);
                    tmp = s2.deriv(ones(n,1),:);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp,[3,1,2]);
                    sout.deriv = val1 .* s1.deriv - ...
                        val2(:,:,ones(1,globp)) .* tmp;
                else                        % both s1.val and s2.val are matrices
                    tmp1 = 1./s2.val;
                    tmp2 = s1.val./(s2.val.*s2.val);
                    sout.deriv = tmp1(:,:,ones(1,globp)) .* s1.deriv - ...
                        tmp2(:,:,ones(1,globp)) .* s2.deriv;
                end
            end
        end
    end

    sout=class(sout,'deriv');

else             % sout.val is empty.
    sout=[];
end
