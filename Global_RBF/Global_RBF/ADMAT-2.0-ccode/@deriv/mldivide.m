function sout=mldivide(s1,s2)
%
%   sout = s1\s2;
%
%
%   03/2007 -- reorganized the program for readibility
%   04/2007 -- consider all cases for matrix division
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
% global backflag;
% global back_s1;
% global back_s2;
% global back_sout;
% 
% record = 0;

% if backflag == 0
%     backflag = 1;
% elseif backflag > 1
%     if isequal(s1, back_s1) && isequal(s2, back_s2) && length(s1) > 1 && length(s2)>1
%         sout = back_sout;
%         backflag = backflag + 1;
%         return;
%     else
%         backflag = 1;
%         back_s1 = [];
%         back_s2 = [];
%         back_sout = [];
%     end
% else
%     backflag = 2;
%     record = 1;
% end


sout.val=getval(s1)\getval(s2);
if ~isempty(sout.val)
    if ~isa(s1,'deriv')           % s1 does not belong to deriv class
        [m2,n2]=size(s2.val);
        [m, n] = size(sout.val);
        if (n2==1)                 % s2.val is a  column vector
            sout.deriv=s1\s2.deriv;
        else                      % s2.val is a matrix or row vector
            sout.deriv = zeros(m,n,globp);
            if m2 == 1
                for i=1:globp
                    if i > 1 && isequal(s2.deriv(:,i), s2.deriv(:,i-1))
                        sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                    else
                        sout.deriv(:,:,i)=s1\s2.deriv(:,i)';
                    end
                end
            else
                for i=1:globp
                    if i > 1 && isequal(s2.deriv(:,:,i), s2.deriv(:,:,i-1))
                        sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                    else
                        sout.deriv(:,:,i)=s1\s2.deriv(:,:,i);
                    end
                end
            end
            if size(sout.val,2) == 1 || size(sout.val, 1) == 1
                if globp == 1
                    sout.deriv = sout.deriv(:);
                else
                    sout.deriv = squeeze(sout.deriv);
                end
            end

        end

    elseif ~isa(s2,'deriv')      % s2.val is not a deriv object
        [m1,n1]=size(s1.val);
        [m, n] = size(sout.val);
        if m1 == 1 &&  n1 == 1
            [m2, n2] = size(s2);
            if m2 > 1    && n2 >1         %  s2 is a matrix
                sout.deriv = zeros(m2,n2,globp);
                for i = 1 : globp
                    if i > 1 && isequal(s1.deriv(i), s1.deriv(i-1))
                        sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                    else
                        sout.deriv(:,:,i) = -((s1.val)^2)\s2*s1.deriv(i);
                    end
                end
            else
                sout.deriv = zeros(m2, globp);
                for i = 1 : globp
                    if i > 1 && isequal(s1.deriv(i), s1.deriv(i-1))
                        sout.deriv(:,i) = sout.deriv(:,i-1);
                    else
                        tmp = s1.val\(-s1.deriv(i)*sout.val);
                        sout.deriv(:,i) = tmp';
                    end
                end
            end
        elseif (n1==1)               % s1 is a column vector
            sout.deriv = zeros(n,globp);
            for i = 1 : globp
                if i > 1 && isequal(s1.deriv(:,i), s1.deriv(:,i-1))
                    sout.deriv(:,i) = sout.deriv(:,i-1);
                else
                    tmp = s1.val\(-s1.deriv(:,i)*sout.val);
                    sout.deriv (:,i) = tmp';
                end
            end
        elseif m1 == 1               % s1.val is a row vector
            if n == 1                % s2 is a  scalar
                tmp = s1.deriv' * sout.val;
                sout.deriv = -s1.val\tmp';
                %                 for i = 1 : globp
                %                     sout.deriv(:,i) = s1.val\(-s1.deriv(:,i)'*sout.val);
                %                 end
            else                    % s2 is a row vector
                sout.deriv =zeros(m,n,globp);
                for i = 1 : globp
                    if i > 1 && isequal(s1.deriv(:,i), s1.deriv(:,i-1))
                        sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                    else
                        sout.deriv(:,:,i) = s1.val\(-s1.deriv(:,i)'*sout.val);
                    end
                end
            end
        else                        % s1.val is a matrix
            sout.deriv = zeros(m,n,globp);
            for i=1:globp
                if i > 1 && isequal(s1.deriv(:,:,i), s1.deriv(:,:,i-1))
                    sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                else
                    sout.deriv(:,:,i)=s1.val\(-s1.deriv(:,:,i)*sout.val);
                end
            end
            if size(sout.val,2) == 1 || size(sout.val, 1) == 1
                sout.deriv = squeeze(sout.deriv);
            end

        end

    else                       % both s1.val and s2.val are deriv object
        [m1, n1] = size(s1.val);
        [m2, n2] = size(s2.val);
        if (n2==1)               % s2.val is a column vector
            if globp==1
                sout.deriv = s1.val\(s2.deriv-s1.deriv*sout.val);
            else
                sout.deriv = s1.val\s2.deriv;
                if n1 == 1 && m1 == 1    % s1.val is a scalar
                    sout.deriv = sout.deriv - ...
                        s1.val\(sout.val*s1.deriv);
                else
                    if n1 == 1   && m1 ~= 1           % s1.val is a column vector
                        tmp = -s1.val\(s1.deriv*sout.val);
                        sout.deriv = sout.deriv + tmp;
                    else
                        if m1 == 1                  % s1.val is a row vector
                            sout.deriv = sout.deriv - ...
                                s1.val\(sout.val'*s1.deriv);
                        else                        % s1.val is a matrix
                            for i=1:globp
                                    sout.deriv(:,i)= sout.deriv(:,i) - ...
                                        s1.val\(s1.deriv(:,:,i)*sout.val);
                            end
                        end
                    end
                end
            end
        else                        % n2 ~= 1
            if m2==1                  % s2.val is a row vector
                if n1 == 1            % s1.val is a scalar
                    sout.deriv=s1.val\s2.deriv;

                    for i = 1 : globp
                        
                            tmp = s1.val\(-s1.deriv(i)*sout.val);
                            sout.deriv (:,i) = sout.deriv(:,i)+ tmp';

                    end
                else
                    for i=1:globp
                        if i > 1 && isequal(s1.deriv(:,i), s1.deriv(:,i-1)) ...
                                && isequal(s2.deriv(:,i), s2.deriv(:,i-1))
                            sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                        else
                            sout.deriv(:,:,i)=s1.val\(s2.deriv(:,i)'-...
                                s1.deriv(:,i)'*sout.val);
                        end
                    end
                end
            else                    % s2.val is a matrix
                if n1 == 1 && m1 > 1
                    for i = 1 : globp
                        if i > 1 && isequal(s1.deriv(:,i), s1.deriv(:,i-1)) ...
                                && isequal(s2.deriv(:,:,i), s2.deriv(:,:,i-1))
                            sout.deriv(:,i) = sout.deriv(:,i-1);
                        else
                            sout.deriv(:,i) = s1.val\(s2.deriv(:,:,i)-...
                                s1.deriv(:,i)*sout.val);
                        end
                    end
                elseif m1 == 1 && n1 == 1
                    sout.deriv = zeros(m2,n2,globp);
                    for i = 1 : globp
                        if i > 1 && isequal(s1.deriv(i), s1.deriv(i-1)) ...
                                && isequal(s2.deriv(:,:,i), s2.deriv(:,:,i-1))
                            sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                        else
                            sout.deriv(:,:,i) = s1.val\(s2.deriv(:,:,i)-...
                                s1.deriv(i)*sout.val);
                        end
                    end
                else
                    if globp == 1
                        sout.deriv=s1.val\(s2.deriv-...
                            s1.deriv*sout.val);
                    else
                        for i=1:globp
                            if i > 1 && isequal(s1.deriv(:,:,i), s1.deriv(:,:,i-1)) ...
                                    && isequal(s2.deriv(:,:,i), s2.deriv(:,:,i-1))
                                sout.deriv(:,:,i) = sout.deriv(:,:,i-1);
                            else
                                sout.deriv(:,:,i)=s1.val\(s2.deriv(:,:,i)-...
                                    s1.deriv(:,:,i)*sout.val);
                            end
                        end
                    end
                end
            end
        end

    end

    sout=class(sout,'deriv');

%     if record == 1
%         back_s1 = s1;
%         back_s2 = s2;
%         back_sout = sout;
%     end
else
    sout=[];
end
