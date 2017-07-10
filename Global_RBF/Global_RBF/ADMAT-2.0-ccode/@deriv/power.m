function sout=power(s1,s2)
%
%
%   03/2007 -- matrix operation is used to avoid
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a
%              column vector
%   03/2007 -- rearrage the program for readibility
%   05/2009 -- add the sparse case for deriv field.

%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

sout.val=getval(s1).^getval(s2);
[m,n]=size(sout.val);

if ~isempty(sout.val)
    if ~isa(s1,'deriv')            % s1 doesn't belong to seriv class
        val2 = sout.val.*log(s1);
        if m==1 && n==1             % sout.val is a scalar
            sout.deriv = val2 .* s2.deriv;
        else
            if (m==1) || (n==1)         % sout.val is a vector
                val2 = val2(:);
                if length(s1) == 1      % s1 is a scalar, s2.val is a vector
                    if size(val2, 2) == size(s2.deriv, 2)
                        sout.deriv = val2 .* s2.deriv;
                    else
                        if issparse(s2.deriv)
                            sizederiv = size(s2.deriv,1);
                            [ia,ja,sa] = find(s2.deriv);
                            dsout = val2(ia).*sa;
                            sout.deriv = sparse(ia,ja, dsout, sizederiv, globp);
                        else
                            sout.deriv = val2(:, ones(1,globp)) .*  s2.deriv;
                        end
                    end
                else
                    if length(s2.val) == 1   % s1 is a vector, s2.val is a scalar
                        sout.deriv = val2(:, ones(1,globp)) .* s2.deriv(ones(length(val2),1), :);
                    else                 % both s1 and s2.val are vectors
                        if size(val2, 2) == size(s2.deriv, 2)
                            sout.deriv = val2 .* s2.deriv;
                        else
                            if issparse(s2.deriv)
                                sizederiv = size(s2.deriv,1);
                                [ia,ja,sa] = find(s2.deriv);
                                dsout = val2(ia).*sa;
                                sout.deriv = sparse(ia,ja, dsout, sizederiv, globp);
                            else
                                sout.deriv = val2(:, ones(1,globp)) .* s2.deriv;
                            end
                        end
                    end
                end

            else                       % sout.val is a matrix
                if length(s1)==1       % s1 is a scalar
                    sout.deriv = val2(:,:, ones(1,globp)) .* s2.deriv;

                elseif length(s2.val)==1       % s2.val is a scalar
                    tmp = s2.deriv(ones(n,1), :);
                    tmp = tmp(:,:, ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = val2(:,:,ones(1,globp)) .* tmp;

                else
                    sout.deriv = val2(:,:, ones(1,globp)).*s2.deriv;
                end
            end
        end

    elseif ~isa(s2,'deriv')                  % s2 doesn't belong to deriv class
        val1=s2.*(s1.val.^(s2-1));
        if m==1 && n==1                      % sout.val is a scalar
            sout.deriv = val1 .* s1.deriv;
        else
            if (m==1) || (n==1)                  % sout.val is a vector
                val1 = val1(:);
                if length(s1.val) == 1           % s1.val is a scalar, s2 is a vector
                    len = length(val1);
                    sout.deriv = val1(:, ones(1,globp)) .*  s1.deriv(ones(len,1), :);
                else
                    if length(s2) == 1           % s1.val is a vector, s2 is a scalar
                        if size(val1,2) == size(s1.deriv, 2)
                            sout.deriv = val1 .* s1.deriv;
                        else
                            if issparse(s1.deriv)
                                sizederiv = size(s1.deriv,1);
                                [ia,ja,sa] = find(s1.deriv);
                                dsout = val1(ia).*sa;
                                sout.deriv = sparse(ia,ja, dsout, sizederiv, globp);
                            else
                                sout.deriv = val1(:, ones(1,globp)) .*  s1.deriv;
                            end
                        end
                    else                         % both s1.val and s2 are vectors
                        if size(val1, 2) == size(s1.deriv, 2)
                            sout.deriv = val1 .* s1.deriv;
                        else
                            if issparse(s1.deriv)
                                sizederiv = size(s1.deriv,1);
                                [ia,ja,sa] = find(s1.deriv);
                                dsout = val1(ia).*sa;
                                sout.deriv = sparse(ia,ja, dsout, sizederiv, globp);
                            else
                                sout.deriv = val1(:, ones(1,globp)) .*  s1.deriv;
                            end
                        end
                    end
                end
            else                                % sout.val is a matrix
                if length(s1.val)==1             % s1.val is a scalar, s2 is a matrix
                    tmp = s1.deriv(ones(n,1), :);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = val1(:,:,ones(1,globp)) .* tmp;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=val1.*s1.deriv(i);
                    %                 end
                elseif length(s2)==1             % s2 is a scalar, s1.val is a matrix
                    sout.deriv = val1(:,:, ones(1,globp)) .* s1.deriv;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i);
                    %                 end
                else                          % both s2 and s1.val are matrices
                    sout.deriv=val1(:,:,ones(1,globp)).*s1.deriv;
                end
            end
        end

    else                                  % both s1 and s2 belong to deriv class
        val1=s2.val.*(s1.val.^(s2.val-1));
        val2=sout.val.*log(s1.val);

        if m == 1 && n == 1                % sout.val is a scalar
            sout.deriv = val1 .* s1.deriv + val2 .* s2.deriv;
        else
            if (m==1) || (n==1)                % sout.val is a vector
                val1 = val1(:);
                val2 = val2(:);
                if length(s1.val) == 1         % s1.val is a scalar, s2.val is a vector
                    len = length(val1);
                    if issparse(s2.deriv)
                        sizederiv = size(s2.deriv,1);
                        [ia,ja,sa] = find(s2.deriv);
                        dsout = val2(ia).*sa;
                        tmp = sparse(ia,ja, dsout, sizederiv, globp);
                    else
                        tmp = val2(:,ones(1,globp)) .* s2.deriv;
                    end
                    sout.deriv = val1(:,ones(1,globp)) .* s1.deriv(ones(len,1),:) + ...
                        tmp;

                else
                    if length(s2.val) == 1     % s1.val is a vector, s2.val is a scalar
                        len = length(val2);
                        if issparse(s1.deriv)
                            sizederiv = size(s1.deriv,1);
                            [ia,ja,sa] = find(s1.deriv);
                            dsout = val1(ia).*sa;
                            tmp = sparse(ia,ja, dsout, sizederiv, globp);
                        else
                            tmp = val1(:,ones(1,globp)) .* s1.deriv;
                        end
                        sout.deriv = tmp + ...
                            val2(:,ones(1,globp)).* s2.deriv(ones(len,1), :);
                    else                       % both s1.val and s2.val are vectors
                        if size(val1, 2) == size(s1.deriv, 2) && ...
                                size(val2, 2) == size(s2.deriv, 2)
                            sout.deriv = val1.* s1.deriv + ...
                                val2 .* s2.deriv;
                        else
                            if issparse(s1.deriv)
                                sizederiv = size(s1.deriv,1);
                                [ia,ja,sa] = find(s1.deriv);
                                dsout = val1(ia).*sa;
                                tmp1 = sparse(ia,ja, dsout, sizederiv, globp);
                            else
                                tmp1 =  val1(:,ones(1,globp)) .* s1.deriv;
                            end
                            if issparse(s2.deriv)
                                sizederiv = size(s2.deriv,1);
                                [ia,ja,sa] = find(s2.deriv);
                                dsout = val2(ia).*sa;
                                tmp2 = sparse(ia,ja, dsout, sizederiv, globp);
                            else
                                tmp2 =  val2(:,ones(1,globp)) .* s2.deriv;
                            end
                            sout.deriv = tmp1 + tmp2;
                        end
                    end
                end
            else                               % sout.val is a matrix
                if length(s1.val)==1           % s1.val is a scalar and s2.val is a matrix
                    tmp = s1.deriv(ones(n,1),:);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = val1(:,:, ones(1,globp)) .* tmp +...
                        val2(:,:,ones(1,globp)) .* s2.deriv;

                elseif length(s2.val)==1        % s2.val is a scalar while s1.val is a matrix
                    tmp = s2.deriv(ones(n,1), :);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = val1(:,:,ones(1,globp)) .* s1.deriv + ...
                        val2(:,:, ones(1,globp)) .* tmp;

                else                            % both s1.val and s2.val are matrices
                    sout.deriv = val1(:,:,ones(1,globp)) .* s1.deriv + ...
                        val2(:,:, ones(1,globp)) .* s2.deriv;

                end
            end
        end
    end

    sout=class(sout,'deriv');
else
    sout=[];
end

