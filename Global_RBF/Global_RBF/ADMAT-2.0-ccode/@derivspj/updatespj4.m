function soutj=updatespj4(s1,s2,sout)
%
%
%  04/2007 -- rmoved unused variables
%  04/2007 -- preallocate vectors
%
%           update for mldivide
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
soutj=[];

if ~isa(s1,'derivspj')

    [m1,n1]=size(s1);
    s2j=s2.derivspj;
    [m2, n2]=size(getval(s2));

    if m1 > 1 && n1 > 1              % s1 is a matrix
        if m2 > 1 &&  n2>1              % s2.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i} = s1\s2j{i};
            end
        elseif m2 > 1               % s2.val is a column vector
            soutj = s1\s2j;
        end
    elseif m1 == 1 && n1 == 1     % s1 is a scalar
        if m2 == 1 || n2 == 1     % s2.val is a scalar or a vector
            soutj = s2j;
        else                      % s2.val is a matrix
            soutj = s2j;
            for i = 1 : globp
                soutj{i} = s1\s2j{i};
            end
        end
    else                    % s1 is a vector
        if n2 == 1
            soutj = s1\s2j;
        elseif m2 == 1           %s2 is a row vector;
            soutj = cell(globp,1);
            for i = 1 : globp
                soutj{i} = sparse(s1\(s2j(:,i)'));
            end
        else
            soutj = zeros(n2,globp);
            for i = 1 : globp
                soutj(:,i) = (s1\s2j{i})';
            end
        end
    end

elseif ~isa(s2,'derivspj')
    [m1,n1]=size(getval(s1));
    s1j=s1.derivspj;
    [m2,n2]=size(s2);

    if m1 > 1 && n1 > 1                     % s1.val is a matrix
        if n2 > 1
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=getval(s1)\(s1j{i}*sout);
            end
        else            % s2.val is a column vector
            soutj = zeros(n1,globp);
            for i=1:globp
                soutj(:,i)=getval(s1)\(s1j{i}*sout);
            end
        end
    elseif m1 == 1 && n1 == 1              % s1.val is a scalar
        if m2 == 1                         % s2.val is a scalar
            soutj = s1j(ones(n2,1),:) .* ...
                sout(ones(globp,1), :)';
        elseif m2 > 1                      % s2.val is a matrix
            soutj = cell(globp,1);
            for i = 1 : globp
                soutj{i} = s2 * s1j(i);
            end
        end
    elseif n1 == 1                % s1.val is a column vector
        soutj = zeros(n2, globp);
        for i = 1 : globp
            tmp = getval(s1)\(s1j(:,i)*sout);
            soutj(:,i) = tmp';
        end
        soutj = sparse(soutj);
    elseif m1 == 1
        if n2 == 1
            tmp = s1j'*sout;
            soutj = sparse(getval(s1)\(tmp'));
        else
            soutj = cell(globp,1);
            for i = 1 : globp
                soutj{i} = getval(s1)\(s1j(:,i)' * sout);
            end
        end
    end

else                        % both s1 and s2 are objects of derivspj

    [m1,n1]=size(getval(s1));
    s2j=s2.derivspj;
    s1j=s1.derivspj;
    [m2,n2]=size(getval(s2));

    if m1 > 1 && n1 > 1              % s1.val is a matrix
        if n2~=1                     % s2.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=getval(s1)\(s1j{i}*sout)+...
                    getval(s1)\s2j{i};
            end
        else                        % s2.val is a column vector
            soutj = zeros(n1, globp);
            for i=1:globp
                soutj(:,i)= getval(s1)\(s1j{i}*sout) + ...
                    getval(s1)\s2j(:,i);
            end
            soutj = sparse(soutj);
        end
    elseif m1 == 1 && n1 == 1       % s1.val is a scalar
        if m2 == 1 && n2 == 1
            soutj = s1j*sout + s2j;
        elseif m2 == 1 || n2 == 1
            len = length(sout);
            soutj = s1j(ones(len,1),:) .* ...
                sout(ones(globp,1), :)' + s2j;
        else
            soutj = cell(globp,1);
            for i = 1 : globp
                soutj{i} = s2j{i} - getval(s2)*s1j(i);
            end
        end
    elseif n1 == 1                % s1.val is a column vector
        if n2 == 1                % s2.val is a column vector
            soutj = getval(s1)\(s1j*sout) + getval(s1)\s2j;
            soutj = sparse(soutj);
        else                     % s2.val is a matrix
            soutj = zeros(n2, globp);
            for i = 1 : globp
                tmp = getval(s1)\(s1j(:,i)*sout);
                soutj(:,i) = tmp' + (getval(s1)\s2j{i})';
            end
            soutj = sparse(soutj);
        end
    elseif m1 == 1               % s1.val is a row vector
        if n2 == 1               % s2.val is a scalar
            tmp = s1j'*sout;
            soutj = sparse(getval(s1)\(tmp'+s2j));
        else                      % s2.val is a row vector
            soutj = cell(globp,1);
            for i = 1 : globp
                soutj{i} = getval(s1)\(s1j(:,i)'*sout + s2j(:,i)');
            end
        end
    end
end


