function south = updatesph4(s1,s2,sout)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

soutj=getspj(sout);
soutval=getval(sout);

south = cell(globp,globp);

if ~isa(s1,'derivsph')
    s1h=s2.derivsph;
    q2=length(getval(s2));

    % JUST ONE SPH

    if q2==1              % s2 is a scalar
        if length(s1) == 1   % s1 is a scalar
            south = s1h/s1;
        else
            for i=1:globp
                for j=1:globp
                    south{i,j}=spones(getval(s1))\(s1h(i,j))';
                end
            end
        end
    elseif length(soutval) == 1 
        south = zeros(globp);
        for i=1:globp
            for j=1:globp
                south(i,j) = getval(s1)\s1h{i,j};
            end
        end
    else
        for i=1:globp
            for j=1:globp
                south{i,j}=spones(getval(s1)\s1h{i,j});
            end
        end
    end


elseif ~isa(s2,'derivsph')
    s1h=s1.derivsph;
    s1j=getspj(s1);
    [m1,n1]=size(getval(s1));
    [m2,n2] = size(s2);

    % JUST ONE SPH

    if n1 == 1 && m1 == 1           % s1.val is a scalar
        if m2 == 1 && n2 == 1
            tmp = s1j(ones(globp,1),:) .* soutj(ones(globp,1),:);
            south = s1h*soutval + tmp;
        elseif m2 == 1
            for i=1:globp
                for j=1:globp
                    south{i,j} = s1h(i,j)*soutval+s1j(i)*soutj(:,i)';
                end
            end
        else                    % s2 is a matrix
            for i=1:globp
                for j=1:globp
                    south{i,j} = s1h(i,j)*soutval+s1j(i)*soutj{i};
                end
            end
        end
    elseif length(soutval) == 1
        south = zeros(globp);
        for i=1:globp
            for j=1:globp
                south(i,j) = getval(s1)\(s1h{i,j}*soutval+s1j(:,i)*soutj(i));
            end
        end
    elseif m1 == 1               % s1.val is a row vector
        if length(s2) == 1        % s2 is a scalar
            for i=1:globp
                for j=1:globp
                    south{i,j} = getval(s1)\(s1h{i,j}*soutval + ...
                        s1j(:,i)'*soutj(:,i));
                end
            end
        else                 % s2 is a row vector
            for i=1:globp
                for j=1:globp
                    south{i,j} = getval(s1)\(s1h{i,j}*soutval+s1j(:,i)'*soutj{i});
                end
            end
        end
    elseif n1 == 1              % s1.val is a column vector
        for i=1:globp
            for j=1:globp
                south{i,j} = getval(s1)\(s1h{i,j}*soutval+s1j(:,i)*soutj(:,i)');
            end
        end
    else                         % s1.val is a matrix
        if n2 == 1               % s2.val is a column vector
            for i=1:globp
                for j=1:globp
                    south{i,j} = getval(s1)\(s1h{i,j}*soutval+s1j{i}*soutj(:,i));
                end
            end
        else                     % s2.val is a matrix
            for i=1:globp
                for j=1:globp
                    south{i,j} = getval(s1)\(s1h{i,j}*soutval+s1j{i}*soutj{i});
                end
            end
        end
    end

else
    s1j=getspj(s1);
    s2j = getspj(s2);
    [m1,n1]=size(getval(s1));
    [m2,n2] = size(getval(s2));
    south = updatesph4(s1,getval(s2),sout)+updatesph4(getval(s1),s2,sout);
    if m1 == 1 && n1 == 1             % s1.val is a scalar
        if n2 > 1 && m2 == 1          % s2.val is a row vector
            tmp = full(s1j(ones(n2,1),:));
            tmp = tmp(:,:,ones(1,globp));
            south = south + tmp.*s2j(:,:,ones(1,globp));
        elseif m2 == 1 && n2 == 1
            south = south + s1j'*s2j;
        else                       % s2.val is a matrix
            for i = 1 : globp
                for j = 1 : globp
                    south{i,j} = south{i,j} + s2j{i}*s1j(i);
                end
            end
        end
    elseif n1 == 1 && m1 > 1
        if n2 == 1                  % s2.val is a column vector
            tmp = getval(s1)\s1j;
            south = south + tmp'*(getval(s2)\s2j);
        else                         % s2.val is a matrix
            for i = 1 : globp
                tmp = getval(s1)\s1j(:,i);
                tmp = tmp*(getval(s1)\s2j{i});
                for j = 1 : globp;
                    south{i,j} = south{i,j} + tmp;
                end
            end
        end
    elseif n1 > 1 && m1 == 1        % s1.val is a row vector
        if n2 == 1                  % s2.val is a scalar
            for i = 1 : globp
                tmp = getval(s1)\s1j(:,i)';
                tmp = tmp*(getval(s1)\s2j(i));
                for j = 1 : globp;
                    south{i,j} = south{i,j} + tmp;
                end
            end
        else                     % s2.val is a row vector
            for i = 1 : globp
                tmp = getval(s1)\s1j(:,i)';
                tmp = tmp*(getval(s1)\s2j(:,i)');
                for j = 1 : globp;
                    south{i,j} = south{i,j} + tmp;
                end
            end            
        end
    else            % s1.val is a matrix
        if n2 == 1                  % s2.val is a scalar
            for i = 1 : globp
                tmp = getval(s1)\s1j{i};
                tmp = tmp*(getval(s1)\s2j(:,i));
                for j = 1 : globp;
                    south{i,j} = south{i,j} + tmp;
                end
            end
        else                     % s2.val is a row vector
            for i = 1 : globp
                tmp = getval(s1)\s1j{i};
                tmp = tmp*(getval(s1)\s2j{i});
                for j = 1 : globp;
                    south{i,j} = south{i,j} + tmp;
                end
            end            
        end
    end              
end

