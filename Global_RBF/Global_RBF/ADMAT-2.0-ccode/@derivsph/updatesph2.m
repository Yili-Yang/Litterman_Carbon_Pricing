function south = updatesph2(s1,s2)
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
    
else
    
    if ~isa(s1,'derivsph')
        s1h=s2.derivsph;
        % s1j=getspj(s2);
        q1=length(getval(s2));
        q2=length(s1);
        
        % JUST ONE SPH
        
        if q1==1 && q2~=1          % s1.val is a scalar
            south = cell(globp,globp);
            for i=1:globp
                for j=1:globp
                    south{i,j}=s1h(i,j)*spones(getval(s1));
                end
            end
        else
            south=s1h;
        end        
        
    elseif ~isa(s2,'derivsph')
        s1h=s1.derivsph;
        % s1j=getspj(s1);
        q1=length(getval(s1));
        q2=length(s2);
        
        % JUST ONE SPH
        
        if q1==1 && q2~=1       % s1.val is a scalar
            south = cell(globp,globp);
            for i=1:globp
                for j=1:globp
                    south{i,j}=s1h(i,j)*spones(getval(s2));
                end
            end
        else            
            south=s1h;
        end        
        
    else                   % both are derivsph objects
        
        s1h=s1.derivsph;
        s1j=getspj(s1);
        s2h=s2.derivsph;
        s2j=getspj(s2);
        q1=length(getval(s1));
        q2=length(getval(s2));        
        
        if ((q1==1)&&(q2~=1))             % s1.val is a scalar
            [m,n]=size(getval(s2));
            if (m==1)           % s2.val is a row vector
                south = cell(globp, globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j}=(s1h(i,j)+...
                            s1j(j)*s2j(:,i)+s2j(:,j)*s1j(i))';
                    end
                end
                south=south+s2h;
                
            elseif (n==1)        % s2.val is a column
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h(i,j)+...
                            s1j(j)*s2j(:,i)+s2j(:,j)*s1j(i);
                    end
                end
                south=south+s2h;                
            else               % s2.val is a matrix
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h(i,j)+...
                            s1j(j)*s2j{i}+s2j{j}*s1j(i);
                    end
                end
                south=south+s2h;
            end            
            
        elseif ((q2==1)&&(q1~=1))               % s2.val is a scalar
            [m,n]=size(getval(s1));
            
            if (m==1)                 % s1.val is a row vector
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j}=(s2h(i,j)+...
                            s2j(j)*s1j(:,i)'+s1j(:,j)'*s2j(i));
                    end
                end
                south=south+s1h;
                
            elseif (n==1)        % s1.val is a column vector
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s2h(i,j)+...
                            s2j(i)*s1j(:,i)+s1j(:,i)*s2j(j);
                    end
                end
                south=south+s1h;
                
            else              % s1.val is a matrix
                south = cell(globp,globp);                
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s2h(i,j)+...
                            s2j(j)*s1j{i}+s1j{j}*s2j(i);
                    end
                end
                south=south+s1h;
            end            
            
        else                    % neither is a scalar
            
            [m,n]=size(getval(s1));
            if m==1 && n==1
                
                south= s1j'*s2j+s2j'*s1j+s1h+s2h;
                
            elseif (m==1)               % s1.val is a row vector
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j} = (s1j(:,i).*s2j(:,j)+s2j(:,i).*s1j(:,j))';
                    end
                end
                south=south+s1h+s2h;
            elseif (n==1)           % s1.val is a column vector
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j} = s1j(:,i).*s2j(:,j)+s2j(:,i).*s1j(:,j);
                    end
                end
                south=south+s1h+s2h;
                
            else                     % s1.val is a matrix
                south = cell(globp,globp);
                for i=1:globp
                    for j=1:globp
                        south{i,j}= s1j{i}.*s2j{j}+s2j{i}.*s1j{j};
                    end
                end
                south=south+s1h+s2h;
            end
            
        end
    end
end
