function soutj=updatespj(s1,s2)
%
%
%  04/2007 -- rmoved unused variables
%  04/2007 -- preallocate vectors
%
%        update spj for ldivide, mpower, power, minus
%            power, times, plus
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

if ~isa(s1,'derivspj')
    q1=size(s1);
    s2j=s2.derivspj;
    q2=length(getval(s2));
    if q2==1                      % s2.val is a scalar
        if (q1(1) > 1) && (q1(2) > 1)      % s1 is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=s2j(i)*spones(s1);
            end
        elseif (q1(1) > 1) || (q1(2) > 1)  % s1 is a vector
                soutj = s2j(ones(length(s1),1),:);
        else                            % s1 is a scalar
            soutj=s2j;
        end
    else                        % s2.val is not a scalar
        soutj=s2j;
    end
elseif ~isa(s2,'derivspj')
    q2=size(s2);
    s1j=s1.derivspj;
    q1=length(getval(s1));
    if q1==1                   % s1.val is a scalar
        if (q2(1) > 1) && (q2(2) > 1)      % s1.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=s1j(i)*spones(s2);
            end
        elseif (q2(1) > 1) || (q2(2) > 1)     % s1.val is a vector
            soutj = s1j(ones(length(s2),1),:);
%             for i=1:globp
%                 soutj(:,i)=s1j(i);
%             end
        else                             % s1.val is a scalar
            soutj=s1j;
        end

    else                       % s1.val is not a scalar
        soutj=s1j;
    end

else               % both are derivspj objects

    s1j=s1.derivspj;
    s2j=s2.derivspj;
    q1=size(getval(s1));
    q2=size(getval(s2));

    if  length(getval(s1))==1                % s1.val is a scalar
        if (q2(1) > 1) && (q2(2) > 1)        % s2.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=s1j(i)+s2j{i};
            end
        elseif (q2(1) > 1) || (q2(2) > 1)    % s2.val is a vector
            soutj = s1j(ones(length(getval(s2)),1), :) + s2j;
%             for i=1:globp
%                 soutj(:,i)=s1j(i)+s2j(:,i);
%             end
        else                       % s2.val is a scalar
            soutj=s1j+s2j;
        end

    elseif length(getval(s2))==1               % s2.val is a scalar
        if (q1(1) > 1) && (q1(2) > 1)          % s1.val is a matrix
            soutj = cell(globp,1);
            for i=1:globp
                soutj{i}=s2j(i)+s1j{i};
            end
        else
            soutj = s2j(ones(length(getval(s1)),1),:) + s1j;
%             for i=1:globp
%                 soutj(:,i)=s2j(i)+s1j(:,i);
%             end
        end
    else                    % neither is a scalar
        soutj=s1j+s2j;
    end

end

