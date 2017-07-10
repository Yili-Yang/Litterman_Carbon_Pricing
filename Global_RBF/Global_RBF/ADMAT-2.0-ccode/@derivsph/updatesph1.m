function south = updatesph1(s1,s2)
%
%
%
%   04/2007 -- consider all scalar, row vector, column vector and matrix
%              cases for oprand
%
%   update for acos, acosh, ..., tan, tanh, mpower and power
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

if nargin==1
    s1h=s1.derivsph;
    s1j=getspj(s1);
    south=s1h+s1j'*s1j;
else                       % two inpurts for mpower and power operations
    south = cell(globp, globp);
    if ~isa(s1,'derivsph')                
        s1h=s2.derivsph;
        s1j=getspj(s2);
        q2=length(s1);
        q1=length(getval(s2));
        if q1==1 && q2~=1        % s2.val is a scalar
            tmp = spones(s1);
            if size(s1,1) ==  1  % s1 is a row vector
                for i=1:globp
                    for j=1:globp
                        south{i,j} = tmp*(s1h(i,j)+s1j*s1j');
                    end
                end
            else
                for i=1:globp
                    for j=1:globp
                        south{i,j} = (s1h(i,j)+s1j*s1j')* tmp;
                    end
                end
            end
        elseif q1==1            % both s1 and s2.val are scalars
            south=s1h+s1j'*s1j;
        else                    % s2.val is not a scalar
            [m1,n1] = size(s1);
            [m2,n2] = size(getval(s2));
            if (m1 > 1 && n1>1) || (m2>1 && n2 >1)
                for i=1:globp
                    for j=1:globp
                        south{i,j} = s1j{i}.*s1j{j};
                    end
                end
            else                % s2.val is a vector
                if m2 == 1      % row vector
                    for i=1:globp
                        for j=1:globp
                            south{i,j} = s1j(:,i)'.*s1j(:,j)';
                        end
                    end
                else
                    for i=1:globp
                        for j=1:globp
                            south{i,j} = s1j(:,i).*s1j(:,j);
                        end
                    end
                end
            end
            south=south+s1h;
        end

    elseif ~isa(s2,'derivsph')
        s1h=s1.derivsph;
        s1j=getspj(s1);
        q2=length(getval(s2));
        q1=length(getval(s1));

        if q1==1 && q2~=1                % s1.val is a scalar
             tmp = spones(s2);
             if size(s2,1) == 1        % s2 is a row vector
                 for i=1:globp
                     for j=1:globp
                         south{i,j}= tmp * (s1h(i,j)+s1j*s1j');
                     end
                 end
             else
                 for i=1:globp
                     for j=1:globp
                         south{i,j}= (s1h(i,j)+s1j*s1j') * tmp;
                     end
                 end
             end
        elseif q1==1            % both s1.val and s2 are scalars
            south=s1h+s1j'*s1j;
        else                     % s1.val is not a scalar
            [m1,n1] = size(getval(s1));
            [m2,n2] = size(s2);
            if (m1 > 1 && n1>1) || (m2>1 && n2 >1)  % s1.val is a matrix
                for i=1:globp
                    for j=1:globp
                        south{i,j} = s1j{i}.*s1j{j};
                    end
                end
            else                   % s1.val is a vector
                if m1 == 1         % row vector
                    for i=1:globp
                        for j=1:globp
                            south{i,j} = s1j(:,i)'.*s1j(:,j)';
                        end
                    end
                else             % column vector
                    for i=1:globp
                        for j=1:globp
                            south{i,j} = s1j(:,i).*s1j(:,j);
                        end
                    end
                end
            end
            south=south+s1h;
        end
    else                     % both s1 and s2 are derivsph objects
        s1h=s1.derivsph;
        s1j=getspj(s1);
        s2h=s2.derivsph;
        s2j=getspj(s2);
        q1=length(getval(s1));
        q2=length(getval(s2));


        if ((q1==1)&&(q2~=1))                % s1.val is a scalar
            [m,n]=size(getval(s2));
            if (m==1)                        % s2.val is a row vector
                for i=1:globp
                    for j=1:globp
                        south{i,j}=(s1h(i,j)+...
                            s1j(j)*s2j(:,i)+s2j(:,j)*s1j(i)+...
                            s2j(:,i).*s2j(:,j)+s1j(j).*s1j(i))';
                    end
                end
                south=south+s2h;
            elseif (n==1)                 % s2.val is a column vector
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h(i,j)+...
                            s1j(j)*s2j(:,i)+s2j(:,j)*s1j(i) + ...
                            s2j(:,i).*s2j(:,j)+s1j(j).*s1j(i);
                    end
                end
                south=south+s2h;
            else                      % s2.val is a matirx
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h(i,j)+...
                            s1j(j)*s2j{i}+s2j{j}*s1j(i)+ ...
                            s1j(j).*s1j(i)+s2j{j}*s2j{i};
                    end
                end
                south=south+s2h;
            end

        elseif ((q2==1)&&(q1~=1))            % s2.val is a scalar
            [m,n]=size(getval(s1));
            if (m==1)                        % s1.val is a row vector
                for i=1:globp
                    for j=1:globp
                        south{i,j}=(s2h(i,j)+...
                            s2j(j)*s1j(:,i)+s1j(:,j)*s2j(i)+...
                            s1j(:,i).*s1j(:,j)+s2j(j).*s2j(i))';
                    end
                end
                south=south+s1h;
            elseif (n==1)
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s2h(i,j)+...
                            s2j(j)*s1j(:,i)+s1j(:,j)*s2j(i) + ...
                            s1j(:,i).*s1j(:,j)+s2j(j).*s2j(i);
                    end
                end
                south=south+s1h;
            else                            % s1.val is a matrix 

                for i=1:globp
                    for j=1:globp
                        south{i,j}=s2h(i,j)+...
                            s2j(j)*s1j{i}+s1j{j}*s2j(i) + ...
                            s2j(j).*s2j(i)+s1j{j}*s1j{i};
                    end
                end
                south=south+s1h;
            end

        else                        % neither is a scalar
            [m,n]=size(getval(s1));        
            if m==1 && n==1               % s1.val is a scalar
                south=  s1j'*s2j+s2j'*s1j+s1j'*s1j+s2j'*s2j+s1h+s2h;
            elseif (m==1)                 % s1.val is a row vector
                for i=1:globp
                    for j=1:globp
                        south{i,j}= (s1j(:,i).*s2j(:,j) + ...
                            s2j(:,i).*s1j(:,j)+s1j(:,i).*s1j(:,j)+...
                            s2j(:,i).*s2j(:,j))';
                    end
                end
                south=south+s1h+s2h;
            elseif (n==1)              % s1.val is a column vector
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1j(:,i).*s1j(:,j)+...
                            s1j(:,i).*s2j(:,j)+s2j(:,i).*s1j(:,j) +...
                            s2j(:,i).*s2j(:,j);
                    end
                end
                south=south+s1h+s2h;
            else                      % s1.val is a matrix
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1j{i}'.*s1j{j}+...
                            s1j{i}.*s2j{j}+s2j{i}.*s1j{j}+s2j{i}.*s2j{j};
                    end
                end
                south=south+s1h+s2h;
            end

        end
    end

end
