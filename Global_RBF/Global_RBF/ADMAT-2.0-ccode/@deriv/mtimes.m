function sout=mtimes(s1,s2)
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
sout.val=getval(s1)*getval(s2);


[m,n] = size(sout.val);

if ~isempty(sout.val)
    [m1,n1]=size(getval(s1));
    [m2,n2]=size(getval(s2));

    if (~isa(s1,'deriv'))        % s1 doesn't belong to deriv class.
        if ((m1>1)&&(n1>1))      % s1 is a matrix
            if n2==1 && m2 ==1           % s2.val is a scalar.
                sout.deriv = zeros(m,n,globp);
                tmp = s2.deriv(ones(n,1),:);
                tmp = tmp(:,:,ones(1,m));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = s1(:,:,ones(1,globp)) .* tmp;
%                 for i = 1 : globp
%                     sout.deriv(:,:,i) = s1 * s2.deriv(i);
%                 end
            else
                if n2 == 1      % s2.val is column vector
                    sout.deriv = s1 * s2.deriv;
                    %                 for i=1:globp
                    %                     sout.deriv(:,i)=s1*s2.deriv(:,i);
                    %                 end
                else                  % s2.val is a matrix
                    sout.deriv = zeros(m,n,globp);
                    for i=1:globp
                        sout.deriv(:,:,i)=s1*s2.deriv(:,:,i);
                    end
                end
            end
        elseif ((m2>1)&&(n2>1))   % s1 is a scalar or row vector and
                                  % s2.val is a matrix
            if m1 == 1 && n1 == 1             % s1 is a scalar
                sout.deriv = s1 .* s2.deriv;
            else                  % s1 is a row vector
                sout.deriv = zeros(n,globp);
                for i=1:globp
                    sout.deriv(:,i) = s1*s2.deriv(:,:,i);
                end
            end
        else                    % neither s1 nor s2.val is matrix
            if ((length(s1)==1) || (length(s2.val)==1))    % one of s1 and s2.val
                                                           % are scalars
                if (length(s1)==1)
                    sout.deriv= s1 .* s2.deriv;
                else                    % s1 is a vector, s2.val is a scalar
                    if m1 == 1      % s1 is a row vector
                        sout.deriv = s1(ones(globp,1),:)' .* s2.deriv(ones(n1,1),:);
                    else            % s2 is a column vector
                        sout.deriv = s1(:,ones(1,globp)) .* s2.deriv(ones(m1,1),:);
                    end
                end
            elseif (m1 == 1)              % neither is a scalar
                %Inner product
                sout.deriv = s1 * s2.deriv;
            else
                sout.deriv = zeros(m,n,globp);
                %outer product
                for i=1:globp
                    sout.deriv(:,:,i)=s1*s2.deriv(:,i)';
                end
            end
        end

    elseif  (~isa(s2,'deriv'))               % s2 does not belong to deriv class
        if ((m1>1)&&(n1>1))                  % s1.val is a matrix
            if n2==1 && m2 ==1           % s1.val is a scalar.
                sout.deriv = s2 * s1.deriv;
            else if n2 == 1      % s1.val is column vector
                    sout.deriv = zeros(m,globp);
                    for i=1:globp
                        sout.deriv(:,i)=s1.deriv(:,:,i)*s2;
                    end
                else                  % s1.val is a matrix
                    sout.deriv = zeros(m,n,globp);
                    for i=1:globp
                        sout.deriv(:,:,i)=s1.deriv(:,:,i)*s2;
                    end
                end
            end
        elseif ((m2>1)&& (n2>1))     % s2 is a matrix
            if length(s1.val) == 1   % s1.val is scalar
                sout.deriv = zeros(m2,n2,globp);
                for i = 1 : globp
                    sout.deriv(:,:,i) = s1.deriv(i) * s2;
                end
            else
                sout.deriv = s2'*s1.deriv;
            end
        else                        % both s1.val and s2 are vectors or scalars
            if ((length(s1.val)==1) || (length(s2)==1))
                if (length(s2)==1)            % s2 is a scalar
                    sout.deriv=s2.*s1.deriv;
                else                % s1.val is a scalar
                    if m2 == 1      % s2 is a row vector
                        sout.deriv = s2(ones(globp,1),:)' .* s1.deriv(ones(n2,1),:);
                    else            % s2 is a column vector
                        sout.deriv = s2(:,ones(1,globp)) .* s1.deriv(ones(m2,1),:);
                    end
                end
            elseif (m1 == 1)               % s1.val is a row vector
                %Inner product
                sout.deriv = s2'*s1.deriv;
            else
                %outer product
                sout.deriv = zeros(m,n,globp);
                for i=1:globp
                    sout.deriv(:,:,i)=s1.deriv(:,i)*s2;
                end
            end
        end

    else                               % both s1 and s2 are in deriv class

        if ((m1>1)&&(n1>1))            % s1.val is a matrix
            if n2==1 && m2 == 1                   % s2.val is a scalar
                tmp = s2.deriv(ones(n1,1), :);
                tmp = tmp(:,:, ones(1,m1));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = s1.deriv.*s2.val + s1.val(:,:,ones(1,globp)).*tmp;
            else
                if n2 == 1             % s2.val is a column vector
                    sout.deriv = zeros(m,globp);
                    for i=1:globp
                        sout.deriv(:,i)=s1.deriv(:,:,i)*s2.val+s1.val*s2.deriv(:,i);
                    end
                else                       % s2.val is a matrix
                    sout.deriv = zeros(m,n,globp);
                    for i=1:globp
                        sout.deriv(:,:,i)=s1.deriv(:,:,i)*s2.val+s1.val*s2.deriv(:,:,i);
                    end
                end
            end
        elseif ((m2>1)&& (n2>1))      % s1.val is a vector and s2.val is a matrix
            if m1 == 1 && n1 == 1
                tmp = s1.deriv(ones(n2,1), :);
                tmp = tmp(:,:, ones(1,m2));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = s2.deriv.*s1.val + s2.val(:,:,ones(1,globp)).*tmp;
            else
                sout.deriv = zeros(n,globp);
                for i=1:globp
                    sout.deriv(:,i)=s1.deriv(:,i)'*s2.val+s1.val*s2.deriv(:,:,i);
                end
            end
        else                          % neither is a matrix

            if (length(s1.val)==1) && (length(s2.val)==1)   % both s1.val and s2.val
                                                            % are scalars
                sout.deriv = s2.val * s1.deriv + s1.val * s2.deriv;

            else
                if length(s1.val) == 1             % s1.val is a scalar and s2.val is a
                                                   % vector
                    if m2 == 1                     % s2.val is a row vector
                        p = s2.val(ones(globp,1),:)' .* s1.deriv(ones(n2,1), :);
                        q = s1.val .* s2.deriv;
                        sout.deriv = q + p;
                    else                           % s2.val is a column vector  
                        p = s2.val(:, ones(1,globp)) .* s1.deriv(ones(m2,1), :);
                        q = s1.val .* s2.deriv;
                        sout.deriv = q + p;
                    end
                else
                    if length(s2.val) == 1         % s2.val is a scalar and s1.val is a
                                                   % vector
                        if m1 == 1                 % s1.val is a row vector
                            p = s2.val .* s1.deriv;
                            q = s1.val(ones(globp,1),:)' .* s2.deriv(ones(n1,1), :);
                            sout.deriv = p + q;
                        else                       % s1.val is a column vector
                            p = s2.val .* s1.deriv;
                            q = s1.val(:, ones(1,globp)) .* s2.deriv(ones(m1,1), :);
                            sout.deriv = p + q;
                        end
                    elseif (m1 == 1)              % both s1.val and s2.val are vectors
                        %Inner product
                        sout.deriv = s2.val' * s1.deriv + s1.val * s2.deriv;
                        %      for i=1:globp
                        %          sout.deriv(:,i)=s2.val'*s1.deriv(:,i)+s1.val*s2.deriv(:,i);
                        %      end
                    else
                        %outer product
                        sout.deriv = zeros(m,n,globp);
                        for i=1:globp
                            sout.deriv(:,:,i)=s1.deriv(:,i)*s2.val+s1.val*s2.deriv(:,i)';
                        end
                    end
                end
            end
        end
    end

    sout=class(sout,'deriv');
else
    sout=[];
end