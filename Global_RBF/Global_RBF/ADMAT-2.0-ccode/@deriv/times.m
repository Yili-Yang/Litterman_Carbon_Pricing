function sout=times(s1,s2)
%
%   
%
%   03/2007 -- matrix operation is used to avoid
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a
%              column vector
%   04/2007 -- consider the case for the row vector
%   05/2009 -- add the sparse case for deriv field.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
sout.val=getval(s1).*getval(s2);

if ~isempty(sout.val)

    [m,n]=size(sout.val);

    if ~isa(s1,'deriv')               % s1 doesn't belong to deriv class
        if m == 1 && n == 1           % sout.val is a scalar
            sout.deriv = s1 .* s2.deriv;
        else
            if (m==1) || (n==1)           % sout.val is a vector
                tmp1 = s1(:);
                if length(s1) == 1        % s1 is a scalar, s2.val is a vector
                    sout.deriv = s1 .* s2.deriv;
                else
                    if length(s2.val) == 1  % s2.val is a scalar, s1 is a vector
                        len = length(s1);
                        sout.deriv = tmp1(:, ones(1,globp)) .* ...
                            s2.deriv(ones(len,1), :);
                    else                  % both s1 and s2.val are vectors
                        if size(s2.deriv,2 ) == size(tmp1, 2)
                            sout.deriv = tmp1 .* s2.deriv;
                        else
                            sizederiv = prod(size(s2.val));
                            if issparse(s2.deriv) & sizederiv ~= 1
                                [ia,ja,sa] = find(s2.deriv);
                                sout.deriv = sparse(ia,ja, reshape(tmp1(ia), size(sa)) .* sa, sizederiv, globp);
                            else
                                sout.deriv = tmp1(:, ones(1,globp)) .* s2.deriv;
                            end
                        end
                    end
                end
                %             for i=1:globp
                %                 sout.deriv(:,i)=s1(:).*s2.deriv(:,i);
                %             end
            else                          % sout.val is a matrix
                if length(s1)==1          % s1 is a scalar
                    sout.deriv = s1.*s2.deriv;
                elseif length(s2.val)==1       % s2.val is a scalar
                    tmp = s2.deriv(ones(n,1),:);
                    tmp = tmp(:,:, ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = s1(:,:,ones(1,globp)) .* tmp;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=s1.*s2.deriv(i);
                    %                 end
                else                       % both s1 and s2.val are matrices
                    sout.deriv=s1(:,:, ones(1,globp)).*s2.deriv;
                end
            end
        end

    elseif ~isa(s2,'deriv')         % s2 doesn't belong to deriv class
        if m == 1 && n == 1
            sout.deriv = s2 .* s1.deriv;
        else
            if (m==1) || (n==1)         % sout.val is a vector
                tmp2 = s2(:);
                if length(s1.val) == 1    % s1.val is a scalar and s2 is a vector
                    len = length(s2);
                    sout.deriv = s1.deriv(ones(len,1), :) .* ...
                        tmp2(:, ones(1,globp));
                else
                    if length(s2) == 1    % s2 is a scalar, s1.val is a vector
                        sout.deriv = s2 .* s1.deriv;
                    else                  % s2 and s1.val are vectors
                        if size(s1.deriv, 2) == size(tmp2, 2)
                            sout.deriv = s1.deriv .* tmp2;
                        else
                            sizederiv = prod(size(s1.val));
                            if issparse(s1.deriv) & sizederiv ~= 1
                                [ia,ja,sa] = find(s1.deriv);
                                sout.deriv = sparse(ia,ja, reshape(tmp2(ia), size(sa)) .* sa, sizederiv, globp);
                            else
                                sout.deriv = s1.deriv .* tmp2(:,ones(1,globp));
                            end
                        end
                    end
                end
            else                         % s2 and s1.val are matrices
                if length(s1.val)==1     % s1.val is a scalar
                    tmp = s1.deriv(ones(n,1),:);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp,[3,1,2]);
                    sout.deriv = s2 (:,:,ones(1,globp)) .* tmp;
                    %                 for i=1:globp
                    %                     sout.deriv(:,:,i)=s2.*s1.deriv(i);
                    %                 end
                elseif length(s2)==1         % s2 is a scalar
                    sout.deriv=s2.*s1.deriv;
                else                         % both s2 and s1.val are matrices
                    sout.deriv=s2(:,:,ones(1,globp)) .* s1.deriv;
                end
            end
        end

    else                           % both s1 and s2 are instances of deriv class
        if m == 1 && n == 1
            sout.deriv = s2.val .* s1.deriv + ...
                s1.val .* s2.deriv;
        else
            if ((m==1) || (n==1))       % sout.val is a vector
                tmp1 = s1.val(:);
                tmp2 = s2.val(:);
                if (length(s1.val) == 1 && length(s2.val) ==1)      % both s1.val and s2.val
                    % are scalars
                    sout.deriv = s1.val .* s2.deriv + ...
                        s2.val.* s1.deriv;
                else
                    if (length(s1.val) == 1)                % s1.val is a scalar, s2.val is vector
                        len = length(s2.val);
                        sout.deriv = s1.val .* s2.deriv + ...
                            tmp2(:, ones(1,globp)) .* s1.deriv(ones(len,1), :);
                    else
                        if (length(s2.val) == 1)            % s2.val is a scalar, s1.val is vector
                            len = length(s1.val);
                            sout.deriv = s2.val .* s1.deriv + ...
                                tmp1(:, ones(1,globp)) .* s2.deriv(ones(len,1), :);
                        else                               % both s1.val and s2.val are vectors
                            if size(tmp2,2) == size(s1.deriv, 2) && ...
                                    size(tmp1, 2) == size(s2.deriv, 2)
                                sout.deriv = tmp2 .* s1.deriv + ...
                                    tmp1 .* s2.deriv;
                            else
                                if issparse(s1.deriv)
                                    mm = prod(size(s1.val));
                                    [ia,ja,sa] = find(s1.deriv);
                                    tmpp1 = sparse(ia,ja, reshape(tmp2(ia), size(sa)) .* sa, mm, globp);
                                else
                                    tmpp1 = s1.deriv .* tmp2(:,ones(1,globp));
                                end
                                if issparse(s2.deriv)
                                    nn = prod(size(s2.val));
                                    [ia,ja,sa] = find(s2.deriv);
                                    tmpp2 = sparse(ia,ja, reshape(tmp1(ia), size(sa)) .* sa, nn, globp);
                                else
                                    tmpp2 = s2.deriv .* tmp1(:,ones(1,globp));
                                end
                                sout.deriv = tmpp1+ tmpp2;
                            end
                        end
                    end
                end

            else                   % sout.val is a matrix
                if length(s1.val)==1            % s1.val is a scalar
                    tmp = s1.deriv(ones(n,1), :);
                    tmp = tmp (:,:,ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = s1.val .* s2.deriv + ...
                        tmp .* s2.val(:,:,ones(1,globp));

                elseif length(s2.val)==1        % s2.val is a scalar
                    tmp = s2.deriv(ones(n,1),:);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    sout.deriv = tmp .* s1.val(:,:,ones(1,globp)) + ...
                        s2.val .* s1.deriv;

                else                          % s1.val and s2.val are matrices
                    sout.deriv = s2.val(:,:, ones(1,globp)) .* s1.deriv + ...
                        s1.val(:,:, ones(1,globp)) .* s2.deriv;
                end
            end
        end
    end
    sout=class(sout,'deriv');

else
    sout=[];
end
