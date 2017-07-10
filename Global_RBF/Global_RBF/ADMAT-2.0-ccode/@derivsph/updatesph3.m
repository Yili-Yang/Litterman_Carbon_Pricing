function south = updatesph3(s1,s2)
%
%
%  04/2007 -- rmoved unused variables
%  04/2007 -- preallocate vectors
%  05/2007 -- consider all the cases for s1 and s2
%
%           update for mtimes
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

south = cell(globp,globp);

if ~isa(s1,'derivsph')        % s1 is not a derivsph object
    s1h=s2.derivsph;
    % s1j=getspj(s2);
    %     q1=length(getval(s2));
    %     q2=length(s1);
    %     [m1,n1] = size(getval(s2));
    %     m2 = size(s1,1);
    [p1,q1] = size(s1);
    [m1,n1] = size(getval(s2));
    
    % JUST ONE SPH
    
        if p1 ==1 && q1 == 1 % s1 is a scalar
            south = s1h;
        elseif p1 == 1   % s1 is a row vector
            if m1 == 1 && n1 == 1 % s2 is a saclar
                for i=1:globp
                    for j=1:globp
                        south{i,j} = s1h(i,j)*spones(s1);
                    end
                end
            elseif n1 == 1  % inner product
                south=sum(s1h,2);
            else      % s2 is a matrix
                for i=1:globp
                    for j=1:globp
                        south{i,j} = sum(s1h{i,j});
                    end
                end
            end
        elseif q1 == 1 % s1 is a column vector
            if m1 == 1 && n1 == 1 % s2 is a scalar
                 for i=1:globp
                    for j=1:globp
                        south{i,j} = s1h(i,j)*spones(s1);
                    end
                 end
            elseif m1 ==1  % outer product
                tmp = zeros(p1,n1,globp);
                for i=1:globp
                    for j=1:globp
                        tmp1 = s1h{i,j};
                        for k = 1:globp
                            tmp(:,:,k) = spones(s1)*tmp1(:,k)';
                        end
                        south{i,j}= tmp;
                    end
                end
            end
        else   % s1 is a matrix
            if m1 == 1 && n1 == 1 % s2 is a scalar
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h(i,j)*spones(s1);
                    end
                end
            elseif n1 == 1  % s2 is a column vector
                for i=1:globp
                        for j=1:globp
                            south{i,j}=spones(s1)*s1h{i,j};
                        end
                end
            else    % s2 is a matrix
                tmp = zeros(p1,n1,globp);
                 for i=1:globp
                        for j=1:globp
                            tmp1 = south{i,j};
                            for k = 1 :globp
                                tmp(:,:,k) = spones(s1)*tmp1(:,:,k);
                            end
                            south{i,j}= spones(tmp);
                        end
                 end
            end
    
        end
    
elseif ~isa(s2,'derivsph')            % s2 is not a derivsph object
    s1h=s1.derivsph;
  
    [p1,q1] = size(getval(s1));
    [m1,n1] = size(s2);
    
    % JUST ONE SPH
    
        if m1 ==1 && n1 == 1 % s2 is a scalar
            south = s1h;
        elseif m1 == 1   % s2 is a row vector
            if p1 == 1 && q1 == 1 % s1 is a saclar
                for i=1:globp
                    for j=1:globp
                        south{i,j} = s1h(i,j)*spones(s2);
                    end
                end
            elseif q1 == 1  % outer product
                tmp = zeros(p1,n1,globp);
                for i=1:globp
                    for j=1:globp
                        for k = 1:glbop
                            tmp(:,:,k) = s1h{i,j};
                        end
                        south{i,j} = tmp;
                    end
                end
            end
        elseif n1 == 1 % s2 is a column vector
            if p1 == 1 && q1 == 1 % s1 is a scalar
                 for i=1:globp
                    for j=1:globp
                        south{i,j} = s1h(i,j)*spones(s2);
                    end
                 end
            elseif p1 ==1  % inner product
               south = sum(s1h);
            else   % s1 is a matrix
                tmp = zeros(p1, globp);
                for i = 1: globp
                    for j = 1:globp
                        tmp1 = s1h{i,j};
                        for k = 1 : globp
                            tmp(:,k) = tmp1(:,:,k)*s2;
                        end
                        south{i,j} = tmp;
                    end
                end                  
                      
            end
        else   % s2 is a matrix
            if p1 == 1 && q1 == 1 % s1 is a scalar
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h(i,j)*spones(s2);
                    end
                end
            elseif p1 == 1  % s1 is a row vector
                for i=1:globp
                        for j=1:globp
                            south{i,j}=s1h{i,j}*spones(s2);
                        end
                end
            else    % s1 is a matrix
                tmp = zeros(p1,n1,globp);
                 for i=1:globp
                        for j=1:globp
                            tmp1 = s1h{i,j};
                            for k = 1:globp
                                tmp(:,:,k) = tmp1(:,:,k)*spones(s2);
                            end
                            south{i,j}= tmp;
                        end
                 end
            end
    
        end
    
else               % both are derivsph objects
    
    s1h=s1.derivsph;
    s1j=getspj(s1);
    s2h=s2.derivsph;
    s2j=getspj(s2);
    q1=length(getval(s1));
    q2=length(getval(s2));
    
    if ((q1==1) && (q2~=1))           % s1.val is a scalar
        [m,n]=size(getval(s2));
        if (m==1)         % s2.val is a row vector or scalar
            for i=1:globp
                for j=1:globp
                    south{i,j} = getval(s2)*s1h(i,j) +...
                        s1j(j)*s2j(:,i)'+s2j(:,i)'*s1j(j);
                end
            end
            south=south+s2h;
        elseif n == 1            % s2.val is a column vector
            for i=1:globp
                for j=1:globp
                    south{i,j} = getval(s2)*s1h(i,j) +...
                        s1j(j)*s2j(:,i)+s2j(:,i)*s1j(j);
                end
            end
            south=south+s2h;
        else                    % s2.val is a matrix
            for i=1:globp
                for j=1:globp
                    south{i,j}=s1h(i,j)+...
                        s1j(j)*s2j{i}+s2j{j}*s1j(i);
                end
            end
            south=south+s2h;
        end
        
    elseif ((q2==1)&&(q1~=1))      % s2.val is a scalar
        [m,n]=size(getval(s1));
        if (m==1)              % s1.val is a row vector
            for i=1:globp
                for j=1:globp
                    south{i,j}= getval(s1)*s2h(i,j)+...
                        s2j(i)*s1j(:,i)'+s1j(:,i)'*s2j(i);
                end
            end
            south=south+s1h;
        elseif n == 1           % s1.val is a column vector
            for i=1:globp
                for j=1:globp
                    south{i,j}= getval(s1)*s2h(i,j)+...
                        s2j(i)*s1j(:,i)+s1j(:,i)*s2j(i);
                end
            end
            south=south+s1h;
        else                      % s1.val is a matrix
            for i=1:globp
                for j=1:globp
                    south{i,j}=s2h(i,j)+...
                        s2j(j)*s1j{i}+s1j{j}*s2j(i);
                end
            end
            south=south+s1h;
        end
    else                     % neither is a scalar
        [m,n]=size(getval(s1));
        if (m==1)               % s1.val is a row vector or a scalar
            if n==1       % s1.val is a scalar
                south=s1j'*s2j+s2j'*s1j+s1h+s2h;
            else          % s1.val is a row vector
                if size(getval(s2),2) == 1     % s2.val is a column vector
                    % inner product
                    south=s1j'*s2j+s2j'*s1j+sum(s1h)+sum(s2h);
                else                           % s2.val is a matrix
                    south = cell(globp,globp);
                    for i = 1 : globp
                        for j = 1 : globp
                            south{i,j} = s1j(:,i)'*s2j{i} + ...
                                s1j(:,i)'*s2j{i}' +  s1h{i,j} + ...
                                sum(s2h{i,j});
                        end
                    end
                end
                
            end
        elseif n==1              % s1.val is a column vector
            for i=1:globp
                for j=1:globp
                    south{i,j}= s1j(:,j)*s2j(:,i)'+s2j(:,j)*s1j(:,i)'+...
                        s1h{i,j}*ones(1,q2)+ones(q1,1)*s2h{i,j};
                end
            end
        else           % s1.val is a matrix
            [m2,n2]=size(getval(s2));
            if n2~=1               % s2.val is a matrix
                for i=1:globp
                    for j=1:globp
                        south{i,j}= s1j{i}*s2j{j}+s2j{i}*s1j{j};
                    end
                end
                south=south+s1h+s2h;
            else                 % s2.val is a column vector
                for i=1:globp
                    for j=1:globp
                        south{i,j}=s1h{i,j}*...
                            ones(m2,1)+s1j{i}*s2j(:,j)+s1j{j}*s2j(:,i);
                    end
                end
                south=south+s2h;
            end
        end
    end
end

