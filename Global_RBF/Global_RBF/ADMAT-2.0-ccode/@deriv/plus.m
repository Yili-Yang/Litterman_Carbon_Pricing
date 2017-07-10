%
%    overloading plus operation for deriv class
%   
%
%
%  03/2007 -- matrix operation is used to avoid "for" loops for
%             s1.val and s2.val are scalar or vector cases.
%  04/2007 -- consider the case for row vetors
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


function sout = plus(s1,s2)

% compute the value field of the deriv class
sout.val=getval(s1)+getval(s2);
% compute the deriv field of the deriv class
if ~isempty(sout.val)
    [m,n]=size(sout.val);

    if ~isa(s1,'deriv')           % s1 is NOT an instance of deriv class

        if (m==1) || (n==1)       % sout is a vector
            if length(s2.val)~=length(sout.val)         
                sout.deriv=repmat(s2.deriv,length(sout.val),1);
            else
                sout.deriv=s2.deriv;
            end
        else                       % sout is a matrix
            if length(s1)==1       % s1 is a scalar and s2.val is a matrix
                sout.deriv=s2.deriv;
            elseif length(s2.val)==1      % s2.val is a scalar and s1 is a matrix
                tmp = s2.deriv(ones(n,1), :);
                tmp = tmp(:,:, ones(1,m));
                sout.deriv = permute(tmp, [3,1,2]);
%                 for i=1:globp
%                     sout.deriv(:,:,i)= s2.deriv(i);
%                 end
            else                           % both s1 and s2.val are matrices
                sout.deriv=s2.deriv;
            end
        end

    elseif ~isa(s2,'deriv')          % s2 is NOT an instance of deriv class
        if (m==1) || (n==1)
            if length(s1.val)~=length(sout.val)
                sout.deriv=repmat(s1.deriv,length(sout.val),1);
            else
                sout.deriv=s1.deriv;
            end
        else
            if length(s2)==1
                sout.deriv=s1.deriv;
            elseif length(s1.val)==1
                tmp = s1.deriv(ones(n,1), :);
                tmp = tmp(:,:, ones(1,m));
                sout.deriv = permute(tmp, [3,1,2]);
                %sout.deriv = s1.deriv(:,:,ones(1,globp));
            else
                sout.deriv=s1.deriv;
            end
        end

    else                           % both s2 and s1 are instances of deriv class

        if (m==1) || (n==1)         % sout.val is a vector
            if ((length(s1.val)>1 && length(s2.val)>1)) || ...     % s1.val and s1.val have                          
                    (length(s1.val) == 1 && length(s2.val) == 1)   % same length.
                sout.deriv=s1.deriv+s2.deriv;
            else                                            % s1.val and s2.val have different
                                                            % length.
                if (length(s1.val) == 1 )                         
                    sout.deriv = s1.deriv(ones(length(sout.val),1), :) + s2.deriv;
                else
                    sout.deriv = s2.deriv(ones(length(sout.val),1), :) + s1.deriv;
                end
            end
        else                     % sout.val is a matix
            if length(s1.val)==1
                tmp = s1.deriv(ones(n,1), :);
                tmp = tmp(:,:, ones(1,m));
                tmp= permute(tmp, [3,1,2]);
                sout.deriv = tmp + s2.deriv;
%                 for i=1:globp
%                     sout.deriv(:,:,i)=s1.deriv(i)+sout.deriv(:,:,i);
%                 end
            elseif length(s2.val)==1
                tmp = s2.deriv(ones(n,1), :);
                tmp = tmp(:,:, ones(1,m));
                tmp = permute(tmp, [3,1,2]);
                sout.deriv = tmp + s1.deriv;                
%                 for i=1:globp
%                     sout.deriv(:,:,i)=sout.deriv(:,:,i)+s2.deriv(i);
%                 end
            else
                sout.deriv=s1.deriv+s2.deriv;
            end
        end

    end

    sout=class(sout,'deriv');
else

    sout=[];
end