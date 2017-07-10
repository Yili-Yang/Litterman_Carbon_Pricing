function soutj=updatespj3(s1,s2)
%
%
%  04/2007 -- rmoved unused variables
%  04/2007 -- preallocate vectors
%  04/2007 -- consider all the cases for s1 and s2
%
%           update for mtimes
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
soutj=[];

if ~isa(s1,'derivspj')

    [m1,n1] = size(s1);
    s2j = s2.derivspj;
    [m2,n2] = size(getval(s2));
    
    if m1 > 1 && n1 > 1              % s1 is a matrix
        if n2~=1                     % s2.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i} = s1*s2j{i};
            end
        else                    
            if m2 > 1               % s2.val is a column vector
                soutj = s1* s2j;
            else                   % s2.val is a scalar
                soutj = cell(globp,1);
                for i = 1 : globp
                    soutj{i} = s1 .* s2j(i);
                end
            end
        end
    else                           % s1 is a vector or a scalar
        if n1 >1                   % s1 is a row vector
            if n2 > 1              % s2.val is a matrix
                soutj = zeros(n2,globp);
                for i = 1 : globp
                    soutj(:,i) = (s1 * s2j{i})';
                end
            elseif m2 > 1         % s2.val is a column vector
                                  % inner product
                 soutj = s1 * s2j;
            else                 % s2.val is a scalar
                soutj = s1(:) * s2j;
            end
        elseif m1 > 1            % s1 is a coulmn vector
            if  n2 > 1           % s2.val is a row vector
                                 % outer product
                soutj = cell(globp,1);
                for i = 1 : globp
                    soutj{i} = s1 * s2j(:,i)';
                end
            else                 % s2.val is a scalar
                soutj = s1(:,ones(1,globp)) .* s2j(ones(length(s1),1),:);
            end
        else                     % s1 is a scalar
            if n2 > 1 && m2 > 2
                soutj = cell(globp,1);
                for i = 1 : globp
                    soutj{i} = s1 * s2j{i};
                end
            else
                soutj = s1 * s2j;
            end                
        end
%             
%          for i=1:globp
%             soutj(:,i) = s1 * s2j(:,i);
%         end
    end

elseif ~isa(s2,'derivspj')
    [m1,n1]=size(getval(s1));
    s1j=s1.derivspj;
    [m2,n2]=size(s2);

    if m1 > 1 && n1 > 1                   % s1.val is a matrix
        if n2 == 1            % s2 is a column vector
            soutj = zeros(m1,globp);
            for i = 1 : globp
                soutj(:,i) = s1j{i}*s2;
            end
        else
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=s1j{i}*s2;
            end
        end
    else                                  % s1.val is a vector or a scalar
        if m1==1 && n1 >1               % s1.val is a row vector    
            if m2 > 1 && n2 == 1        % s2 is a column vector
                soutj = s2' * s1j;
            else % if n2 > 1               % s2 is a matrix or a scalar
                soutj = s2 * s1j;
            end
%             for i=1:globp
%                 soutj(:,i)=s1j(:,i)'*getval(s2);
%             end
        else
            if m1 == 1 && n1 == 1        % s1.val is a scalar
                if (m2 > 1 && n2 == 1) || (m2 == 1 && n2 >1)
                                         % s2 is a column vector
                    soutj = s2(:) * s1j;
                elseif n2 >1             % s2 is a matrix
                    soutj = cell(globp,1);
                    for i = 1 : globp
                        soutj{i} = s1j(i) * s2;
                    end
                elseif m2 == 1 && n2 >1    % s2 is a row vector
                    soutj = s2' * s1j;
                else                      % s2 is a scalar
                    soutj = s2 * s1j;
                end
            else           % s1.val is a column vector
                if m2 == 1 && n2 == 1       % s2 is a scalar
                    soutj = s1j * s2;
                else            % outer product
                    soutj = cell(globp,1);
                    for i = 1 : globp
                        soutj{i} = s1j(:,i) * s2;
                    end
                end
            end
        end
    end

else                              % both s1.val and s2 are derivspj objects

    [m1,n1]=size(getval(s1));
    s2j=s2.derivspj;
    s1j=s1.derivspj;
    [m2,n2]=size(getval(s2));

    if m1 > 1 && n1 > 1            % s1.val is a matrix
        if n2 > 1                  % s2.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=s1j{i}*getval(s2)+getval(s1)*s2j{i};
            end
        else                       % s2.val is a column vector
            soutj = zeros(m1,globp);
            for i=1:globp
                soutj(:,i)=s1j{i}*getval(s2)+getval(s1)*s2j(:,i);
            end
        end
    else                         % s1.val is a vector or a scalar
        if m1==1  && n1 > 1               % s1.val is a row vector
            if n2 > 1            % s2.val is a matrix
                soutj = zeros(n2, globp);
                for i = 1 : globp
                    soutj(:,i) = (s1j(:,i)' * s2.val + s1.val * s2j{i})';
                end
            elseif m2 > 1         % s2.val is a column vector
                soutj = s2.val'*s1j + s1.val*s2j;
            else                  % s2.val is a scalar
                soutj = s2.val*s1j + s1.val(ones(globp,1),:)'.*s2j(ones(n1,1),:);
            end
%             for i=1:globp
%                 soutj(:,i)=s1j(:,i)'*getval(s2)+getval(s1)*s2j(:,i);
%             end
        elseif m1 == 1 && n1 == 1                %  s1.val is a scalar
            if m2 == 1  && n2 > 1                % s2.val is a row vector
                p = s2.val(ones(globp,1),:)' .* s1j(ones(n2,1), :);
                q = s1.val .* s2j;
                soutj = q + p;
            elseif n2 == 1  && m2 > 1            % s2.val is a column vector
                p = s2.val(:, ones(1,globp)) .* s1j(ones(m2,1), :);
                q = s1.val .* s2j;
                soutj = q + p;
            elseif m2 == 1 && n2 == 1            % s2.val is a scalar
                soutj = s1.val *s2j + s2.val *s1j;
            else                                 % s2.val is a matrix
                soutj = cell(globp,1);
                for i = 1 : globp
                    soutj{i} = s1.val*s2j{i} + s2.val*s1j(i);
                end
            end
        else                              % s1.val is a column vector
            if n2 == 1              % s2.val is a scalar
                soutj = s2.val*s1j + s1.val(:,ones(1,globp)).* s2j(ones(m1,1),:);
            else
                soutj = cell(globp,1);
                for i = 1 : globp
                    soutj{i} = s1j(:,i) * s2.val + s1.val * s2j(:,i)';
                end
            end
        end
    end

end

