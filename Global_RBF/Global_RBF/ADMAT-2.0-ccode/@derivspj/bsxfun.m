function sout = bsxfun(fun, A, B)
%
% Apply element-by-element binary operation to two arrays with singleton
% expansion enabled. Currently, only support
%
% @plus   Plus
%
% @minus  Minus
%
% @times  Array multiply
%
% @ldivide  Left array divide
%
% @rdivide  Right array divide
%
% @power    Array power
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2012 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
%
%
global globp;

if isa(A, 'derivspj') && ~isa(B, 'derivspj')   % A belongs to derivspj class, but B doesn't
    sout.val = bsxfun(fun, A.val, B);
    [mA, nA] = size(A.val);
    [mB, nB] = size(B);
    switch func2str(fun)
        case {'plus', 'minus'}
            if mA >= mB && nA >= nB  % The size of A is no less than the size of B
                sout.derivspj = A.derivspj;
            elseif (nA == 1 && mB==1) && (mA>1 && nB>1) % A is a column vector, B is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = sparse(repmat(A.derivspj(:,i), 1, nB));
                end
            elseif (mA==1 && nB==1) && (nA>1 && mB>1)   % A is a row vector, B is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = sparse(repmat(A.derivspj(:,i)', mB, 1));
                end
            elseif  (mB>1 && nB>1) && (nA>1 || mA>1)  %  A is a vector and B is a matrix
                if (mA == 1 && nA>1) % A is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = sparse(repmat(A.derivspj(:,i)', mB, 1));
                    end
                elseif (mA>1 && nA==1)  % A is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = sparse(repmat(A.derivspj(:,i),1, nB));
                    end
                end
            else  % A is a scalar
                if (mB==1 && nB > 1) || (mB>1 && nB == 1)   % B is a vector
                    sout.derivspj = sparse(repmat(A.derivspj, max(nB,mB),1));
                else   % B is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = sparse(repmat(A.derivspj(i), mB, nB));
                    end
                end
            end
        case {'times'}% @rdivide, @power, @ldivide}
            if (mA>=mB) && (nA>=nB)   % The size of A is not smaller than B's
                if mA == 1   % A is a row vector
                    sout.derivspj = bsxfun(fun, A.derivspj', B)';
                elseif mA > 1 && nA > 1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun, A.derivspj{i}, B);
                    end
                else
                    sout.derivspj = bsxfun(fun, A.derivspj, B);
                end
            elseif (mA ==1 && nA>1) && (mB>1 && nB==1) % A is a row vector and B is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i)', B);
                end
            elseif (mA>1 && nA==1) && (mB==1 && nB>1)  % A is a column vector and B is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i),B);
                end
            elseif (mA>1  || nA>1)&&(mB>1 && nB>1)  % A is a vector and B is a matrix
                if (mA==1)  % A is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i}= bsxfun(fun, A.derivspj(:,i)', B);
                    end
                else    % A is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i), B);
                    end
                end
            else % A is a scalar
                if (mB == 1 && nB>1) || (mB>1 && nB==1)   % B is a vector
                    sout.derivspj = bsxfun(fun, A.derivspj, B(:)')';
                else  % B is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun, A.derivspj(i), B);
                    end
                end
                
            end
        case {'ldivide'}
            tmp = -A.val.*A.val;
            tmp1 = sparse(bsxfun(fun, tmp, B));
            if mA>=mB && nA>=nB    %  size of A is no smaller than B
                
                if mA == 1   % A is a row vector
                    sout.derivspj = bsxfun(@times, tmp1', A.derivspj);
                elseif mA>1 && nA>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp1, A.derivspj);
                end
            elseif (mA ==1 && nA>1) && (mB>1 && nB==1) % A is a row vector and B is a column vector
                sout.derivspj = cell(globp,1);
                
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i)');
                end
            elseif (mA>1 && nA==1) && (mB==1 && nB>1)  % A is a column vector and B is a row vector
                sout.derivspj = cell(globp,1);
                
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i));
                end
            elseif (mA>1  || nA>1)&&(mB>1 && nB>1)  % A is a vector and B is a matrix
                if (mA==1)  % A is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i)');
                    end
                else    % A is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i));
                    end
                end
            else % A is a scalar
                if (mB == 1 && nB>1) || (mB>1 && nB==1)   % B is a vector
                    sout.derivspj = bsxfun(@times, tmp1(:)', A.derivspj)';
                else  % B is a matrix
                    sout.derivspj = cell(globp,1);
                    tmp = -A.val.*A.val;
                    tmp1 = bsxfun(fun, tmp, B);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(i));
                    end
                end
                
            end
        case{'rdivide'}
            tmp = sparse(1./B);
            if mA >= mB && nA >= nB  % The size of A is no less than the size of B
                if mA == 1  % A is a row vector
                    sout.derivspj = bsxfun(@times,tmp', A.derivspj);
                elseif mA>1 && nA>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp, A.derivspj);
                end
            elseif (nA == 1 && mB==1) && (mA>1 && nB>1) % A is a column vector, B is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(:,i));
                end
            elseif (mA==1 && nB==1) && (nA>1 && mB>1)   % A is a row vector, B is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(:,i)');
                end
            elseif  (mB>1 && nB>1) && (nA>1 || mA>1)  %  A is a vector and B is a matrix
                if (mA == 1 && nA>1) % A is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i}= bsxfun(@times, tmp, A.derivspj(:,i)');
                    end
                elseif (mA>1 && nA==1)  % A is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(:,i));
                    end
                end
            else  % A is a scalar
                if (mB==1 && nB > 1) || (mB>1 && nB == 1)   % B is a vector
                    sout.derivspj = bsxfun(@times, tmp(:), A.derivspj');
                else   % B is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(i));
                    end
                end
            end
        case{'power'}
            tmp1 = sparse(bsxfun(fun, A.val, B-1));
            tmp = sparse(bsxfun(@times, tmp1, B));
            if mA >= mB && nA >= nB  % The size of A is no less than the size of B
                if mA == 1  % A is a row vector
                    sout.derivspj = bsxfun(@times,tmp', A.derivspj);
                elseif mA>1 && nA>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp, A.derivspj);
                end
            elseif (nA == 1 && mB==1) && (mA>1 && nB>1) % A is a column vector, B is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(:,i));
                end
            elseif (mA==1 && nB==1) && (nA>1 && mB>1)   % A is a row vector, B is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(:,i)');
                end
            elseif  (mB>1 && nB>1) && (nA>1 || mA>1)  %  A is a vector and B is a matrix
                if (mA == 1 && nA>1) % A is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i}= bsxfun(@times, tmp, A.derivspj(:,i)');
                    end
                elseif (mA>1 && nA==1)  % A is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(:,i));
                    end
                end
            else  % A is a scalar
                if (mB==1 && nB > 1) || (mB>1 && nB == 1)   % B is a vector
                    sout.derivspj = bsxfun(@times, tmp(:), A.derivspj');
                else   % B is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, A.derivspj(i));
                    end
                end
            end
    end
elseif ~isa(A, 'derivspj') && isa(B, 'derivspj')  % B belongs to derivspj class, but A doesn't
    sout.val = bsxfun(fun, A, B.val);
    [mA, nA] = size(A);
    [mB, nB] = size(B.val);
    switch func2str(fun)
        case {'plus'}
            if mB >= mA && nB >= nA  % The size of B is no less than the size of A
                sout.derivspj = B.derivspj;
            elseif (nB == 1 && mA==1) && (mB>1 && nA>1) % B is a column vector, A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = sparse(repmat(B.derivspj(:,i), 1, nA));
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = sparse(repmat(B.derivspj(:,i)', mA, 1));
                end
            elseif  (mA>1 && nA>1) && (nB>1 || mB>1)  %  B is a vector and A is a matrix
                if (mB == 1 && nB>1) % B is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = sparse(repmat(B.derivspj(:,i)', mA, 1));
                    end
                elseif (mB>1 && nB==1)  % B is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = sparse(repmat(B.derivspj(:,i),1, nA));
                    end
                end
            else  % B is a scalar
                if (mA==1 && nA > 1) || (mA>1 && nA == 1)   % A is a vector
                    sout.derivspj = sparse(repmat(B.derivspj, max(nA,mA),1));
                else   % A is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = repmat(B.derivspj(i), mA, nA);
                    end
                end
            end
        case {'minus'}
            if mB >= mA && nB >= nA  % The size of B is no less than the size of A
                sout.derivspj = B.derivspj;
            elseif (nB == 1 && mA==1) && (mB>1 && nA>1) % B is a column vector, A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = -sparse(repmat(B.derivspj(:,i), 1, nA));
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = -sparse(repmat(B.derivspj(:,i)', mA, 1));
                end
            elseif  (mA>1 && nA>1) && (nB>1 || mB>1)  %  B is a vector and A is a matrix
                if (mB == 1 && nB>1) % B is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = -sparse(repmat(B.derivspj(:,i)', mA, 1));
                    end
                elseif (mB>1 && nB==1)  % B is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = -sparse(repmat(B.derivspj(:,i),1, nA));
                    end
                end
            else  % B is a scalar
                if (mA==1 && nA > 1) || (mA>1 && nA == 1)   % A is a vector
                    sout.derivspj = -sparse(repmat(B.derivspj, max(nA,mA),1));
                else   % A is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = -sparse(repmat(B.derivspj(i), mA, nA));
                    end
                end
            end
        case {'times'}% @rdivide, @power, @ldivide}
            if (mB>=mA) && (nB>=nA)   % The size of B is not smaller than A's
                if mB == 1   % B is a row vector
                    sout.derivspj = bsxfun(fun, A, B.derivspj')';
                elseif mB>1 && nB >1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun, A, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(fun, A, B.derivspj);
                end
            elseif (mB ==1 && nB>1) && (mA>1 && nA==1) % B is a row vector and A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun, A, B.derivspj(:,i)');
                end
            elseif (mB>1 && nB==1) && (mA==1 && nA>1)  % B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun, A, B.derivspj(:,i));
                end
            elseif (mB > 1 || nB>1)&&(mA>1 && nA>1)  % B is a vector and A is a matrix
                if (mB==1)  % B is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun,A, B.derivspj(:,i)');
                    end
                else    % B is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun,A, B.derivspj(:,i));
                    end
                end
            else % B is a scalar
                if (mA == 1 && nA>1) || (mA>1 && nA==1)   % A is a vector
                    sout.derivspj = bsxfun(fun, A(:)', B.derivspj)';
                else  % A is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i}= bsxfun(fun, A, B.derivspj(i));
                    end
                end
                
            end
        case {'ldivide'}
            tmp = sparse(1./A);
            if mB >= mA && nB >= nA  % The size of B is no less than the size of A
                if mB == 1  % B is a row vector
                    sout.derivspj = bsxfun(@times,tmp', B.derivspj);
                elseif mB>1 && nB>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp, B.derivspj);
                end
            elseif (nB == 1 && mA==1) && (mB>1 && nA>1) % B is a column vector, A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp, B.derivspj(:,i));
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp, B.derivspj(:,i)');
                end
            elseif  (mA>1 && nA>1) && (nB>1 || mB>1)  %  B is a vector and A is a matrix
                if (mB == 1 && nB>1) % B is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i}= bsxfun(@times, tmp, B.derivspj(:,i)');
                    end
                elseif (mB>1 && nB==1)  % B is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, B.derivspj(:,i));
                    end
                end
            else  % B is a scalar
                if (mA==1 && nA > 1) || (mA>1 && nA == 1)   % A is a vector
                    sout.derivspj = bsxfun(@times, tmp(:), B.derivspj');
                else   % A is a matrix
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp, B.derivspj(i));
                    end
                end
            end
        case{'rdivide'}
            tmp = -B.val.*B.val;
            tmp1 = sparse(bsxfun(fun, tmp, A));
            if mB>=mA && nB>=nA    %  size of B is no smaller than A
                
                if mB == 1   % B is a row vector
                    sout.derivspj = bsxfun(@times, tmp1', B.derivspj);
                elseif mB>1 && nB>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp1, B.derivspj);
                end
            elseif (mB ==1 && nB>1) && (mA>1 && nA==1) % B is a row vector and A is a column vector
                sout.derivspj = cell(globp,1);
                
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i)');
                end
            elseif (mB>1 && nB==1) && (mA==1 && nA>1)  % B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i));
                end
            elseif (mB>1  || nB>1)&&(mA>1 && nA>1)  % B is a vector and A is a matrix
                if (mB==1)  % B is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i)');
                    end
                else    % B is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i));
                    end
                end
            else % B is a scalar
                if (mA == 1 && nA>1) || (mA>1 && nA==1)   % A is a vector
                    sout.derivspj = bsxfun(@times, tmp1(:)', B.derivspj)';
                else  % A is a matrix
                    sout.derivspj = cell(globp,1);
                    tmp = -B.val.*B.val;
                    tmp1 = bsxfun(fun, tmp, A);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(i));
                    end
                end
            end
        case{'power'}
            tmp = sparse(bsxfun(fun, A, B.val));
            tmp1 = sparse(bsxfun(@times, tmp, log(A)));
            if mB>=mA && nB>=nA    %  size of B is no smaller than A
                
                if mB == 1   % B is a row vector
                    sout.derivspj = bsxfun(@times, tmp1', B.derivspj);
                elseif mB>1 && nB>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp1, B.derivspj);
                end
            elseif (mB ==1 && nB>1) && (mA>1 && nA==1) % B is a row vector and A is a column vector
                sout.derivspj = cell(globp,1);
                
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i)');
                end
            elseif (mB>1 && nB==1) && (mA==1 && nA>1)  % B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i));
                end
            elseif (mB>1  || nB>1)&&(mA>1 && nA>1)  % B is a vector and A is a matrix
                if (mB==1)  % B is a row vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i)');
                    end
                else    % B is a column vector
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i));
                    end
                end
            else % B is a scalar
                if (mA == 1 && nA>1) || (mA>1 && nA==1)   % A is a vector
                    sout.derivspj = bsxfun(@times, tmp1(:)', B.derivspj)';
                else  % A is a matrix
                    sout.derivspj = cell(globp,1);
                    tmp = -B.val.*B.val;
                    tmp1 = bsxfun(fun, tmp, A);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(i));
                    end
                end
            end
    end
else    % Both A and B belong to deriv class
    sout.val = bsxfun(fun, A.val, B.val);
    [mA, nA] = size(A.val);
    [mB, nB] = size(B.val);
    switch func2str(fun)
        case {'plus', 'minus'}
            if mB == mA && nB == nA  % The size of A is same as B
                if mB > 1 && nB > 1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun, A.derivspj{i}, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(fun, A.derivspj, B.derivspj);
                end
            elseif (nA> 1 && mA>1) || (mB>1 && nB>1) % one of A and B is a matrix, not both
                sout.derivspj = cell(globp,1);
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(fun, A.derivspj{i}, B.derivspj(:,i));
                        end
                    else  % B is a row vector or a scalar
                        if nB == 1   % B is a saclar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.derivspj{i}, B.derivspj(i));
                            end
                        else  % B is a row vector
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.derivspj{i}, B.derivspj(:,i)');
                            end
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i), B.derivspj{i});
                        end
                    else  % A is a row vector or a scalar
                        if nA == 1  % A is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.derivspj(i), B.derivspj{i});
                            end
                        else
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i)', B.derivspj{i});
                            end
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i), B.derivspj(:,i)');
                end
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun, A.derivspj(:,i)', B.derivspj(:,i));
                end
            else  % one of A and B is a scalar
                if mA == 1 && nA == 1   % A is a scalar
                    sout.derivspj = bsxfun(fun, A.derivspj', B.derivspj);
                else
                    sout.derivspj = bsxfun(fun, A.derivspj, B.derivspj');
                end
            end
        case {'times'}% @rdivide, @power, @ldivide}
            if (mB==mA) && (nB==nA)   % The size of B is same as A's
                if mB == 1   % A and B are row vectors
                    sout.derivspj = bsxfun(fun, A.derivspj', B.val)' + bsxfun(fun, A.val, B.derivspj')';
                elseif mA>1 && nA > 1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj{i}) + bsxfun(fun, A.derivspj{i}, B.val);
                    end
                else
                    sout.derivspj = bsxfun(fun, A.val, B.derivspj) + bsxfun(fun, A.derivspj, B.val);
                end
            elseif (mB >1 && nB>1) || (mA>1 && nA>1) % One of A and B is a matrix, not both
                sout.derivspj = cell(globp,1);
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj(:,i))+bsxfun(fun, A.derivspj{i}, B.val);
                        end
                    else  % B is a row vector or a scalar
                        if nB ==1 % B is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj(i))+bsxfun(fun, A.derivspj{i}, B.val);
                            end
                        else
                            
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj(:,i)')+bsxfun(fun, A.derivspj{i}, B.val);
                            end
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj{i})+ bsxfun(fun, A.derivspj(:,i), B.val);
                        end
                    else  % A is a row vector or a scalar
                        if nA == 1 % A is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj{i})+ bsxfun(fun, A.derivspj(i), B.val);
                            end
                        else
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(fun, A.val, B.derivspj{i})+ bsxfun(fun, A.derivspj(:,i)', B.val);
                            end
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun,A.val,B.derivspj(:,i)') + bsxfun(fun, A.derivspj(:,i), B.val);
                end
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(fun,A.val,B.derivspj(:,i))+ bsxfun(fun, A.derivspj(:,i)', B.val);
                end
            else  % one of A and B is a scalar
                if mA ==1 && nA ==1   % A is a scalar
                    sout.derivspj = bsxfun(fun, A.val, B.derivspj) + bsxfun(fun, A.derivspj', B.val(:));
                else % B is a scalar
                    sout.derivspj = bsxfun(fun, A.val(:), B.derivspj') + bsxfun(fun, A.derivspj, B.val);
                end
            end
        case {'ldivide'}
            tmp2 = sparse(1./A.val);
            tmp = -tmp2.*tmp2;
            tmp1 = sparse(bsxfun(@times, tmp, B.val));
            if (mB==mA) && (nB==nA)   % The size of B is same as A's
                if mB == 1   % A and B are row vectors
                    sout.derivspj = bsxfun(@times, tmp1', A.derivspj) + bsxfun(@times, tmp2', B.derivspj);
                elseif mA>1 && nA>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i}) + bsxfun(@times, tmp2, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp1, A.derivspj) + bsxfun(@times, tmp2, B.derivspj);
                end
            elseif (mB >1 && nB>1) || (mA>1 && nA>1) % One of A and B is a matrix, not both
                sout.derivspj = cell(globp,1);
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i})+bsxfun(@times, tmp2, B.derivspj(:,i));
                        end
                    else  % B is a row vector or a scalar
                        if nB ==1 % B is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i})+bsxfun(@times, tmp2, B.derivspj(i));
                            end
                        else    % B is a row vector
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i})+bsxfun(@times, tmp2, B.derivspj(:,i)');
                            end
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i))+ bsxfun(@times, tmp2, B.derivspj{i});
                        end
                    else  % A is a row vector or a scalar
                        if nA == 1 % A is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(i))+ bsxfun(@times, tmp2, B.derivspj{i});
                            end
                        else
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i)')+ bsxfun(@times, tmp2, B.derivspj{i});
                            end
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times,tmp1,A.derivspj(:,i)) + bsxfun(@times,tmp2, B.derivspj(:,i)');
                end
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times,tmp1,A.derivspj(:,i)')+ bsxfun(@times, tmp2, B.derivspj(:,i));
                end
            else  % one of A and B is a scalar
                if mA ==1 && nA ==1   % A is a scalar
                    sout.derivspj = bsxfun(@times, tmp1(:), A.derivspj') + bsxfun(@times, tmp2, B.derivspj);
                else % B is a scalar
                    sout.derivspj = bsxfun(@times, tmp1(:), A.derivspj) + bsxfun(@times, tmp2(:), B.derivspj');
                end
            end
        case{'rdivide'}
            tmp2 = sparse(1./B.val);
            tmp = -tmp2.*tmp2;
            tmp1 = sparse(bsxfun(@times, tmp, A.val));
            if (mA==mB) && (nA==nB)   % The size of A is same as B's
                if mA == 1   % A and B are row vectors
                    sout.derivspj = bsxfun(@times, tmp1', B.derivspj) + bsxfun(@times, tmp2', A.derivspj);
                elseif mB>1 && nB>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj{i}) + bsxfun(@times, tmp2, A.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp1, B.derivspj) + bsxfun(@times, tmp2, A.derivspj);
                end
            elseif (mA >1 && nA>1) || (mB>1 && nB>1) % One of A and B is a matrix, not both
                sout.derivspj = cell(globp,1);
                if (nB>1 && mB>1)  % B is a matrix
                    if mA > 1  % A is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj{i})+bsxfun(@times, tmp2, A.derivspj(:,i));
                        end
                    else  % A is a row vector or a scalar
                        if nA ==1 % A is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj{i})+bsxfun(@times, tmp2, A.derivspj(i));
                            end
                        else    % A is a row vector
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj{i})+bsxfun(@times, tmp2, A.derivspj(:,i)');
                            end
                        end
                    end
                else     % A is a matrix
                    if mB > 1 % B is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i))+ bsxfun(@times, tmp2, A.derivspj{i});
                        end
                    else  % B is a row vector or a scalar
                        if nB == 1 % B is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(i))+ bsxfun(@times, tmp2, A.derivspj{i});
                            end
                        else
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, B.derivspj(:,i)')+ bsxfun(@times, tmp2, A.derivspj{i});
                            end
                        end
                    end
                end
            elseif (mA==1 && nB==1) && (nA>1 && mB>1)   % A is a row vector, B is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times,tmp1,B.derivspj(:,i)) + bsxfun(@times,tmp2, A.derivspj(:,i)');
                end
            elseif  (mA>1 && nA==1) && (nB>1 && mB==1)  %  A is a column vector and B is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times,tmp1,B.derivspj(:,i)')+ bsxfun(@times, tmp2, A.derivspj(:,i));
                end
            else  % one of A and B is a scalar
                if mB ==1 && nB ==1   % B is a scalar
                    sout.derivspj = bsxfun(@times, tmp1(:), B.derivspj') + bsxfun(@times, tmp2(:), A.derivspj);
                else % A is a scalar
                    sout.derivspj = bsxfun(@times, tmp1(:), B.derivspj) + bsxfun(@times, tmp2(:), A.derivspj');
                end
            end
        case{'power'}
            tmp = bsxfun(fun, A.val, B.val-1);
            tmp1 = sparse(bsxfun(@times, tmp, B.val));
            tmp = bsxfun(fun, A.val, B.val);
            tmp2 = sparse(bsxfun(@times, tmp, log(B.val)));
            if (mB==mA) && (nB==nA)   % The size of B is same as A's
                if mB == 1   % A and B are row vectors
                    sout.derivspj = bsxfun(@times, tmp1', A.derivspj) + bsxfun(@times, tmp2', B.derivspj);
                elseif mA>1 && nA>1
                    sout.derivspj = cell(globp,1);
                    for i = 1 : globp
                        sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i}) + bsxfun(@times, tmp2, B.derivspj{i});
                    end
                else
                    sout.derivspj = bsxfun(@times, tmp1, A.derivspj) + bsxfun(@times, tmp2, B.derivspj);
                end
            elseif (mB >1 && nB>1) || (mA>1 && nA>1) % One of A and B is a matrix, not both
                sout.derivspj = cell(globp,1);
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i})+bsxfun(@times, tmp2, B.derivspj(:,i));
                        end
                    else  % B is a row vector or a scalar
                        if nB ==1 % B is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i})+bsxfun(@times, tmp2, B.derivspj(i));
                            end
                        else    % B is a row vector
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj{i})+bsxfun(@times, tmp2, B.derivspj(:,i)');
                            end
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        for i = 1 : globp
                            sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i))+ bsxfun(@times, tmp2, B.derivspj{i});
                        end
                    else  % A is a row vector or a scalar
                        if nA == 1 % A is a scalar
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(i))+ bsxfun(@times, tmp2, B.derivspj{i});
                            end
                        else
                            for i = 1 : globp
                                sout.derivspj{i} = bsxfun(@times, tmp1, A.derivspj(:,i)')+ bsxfun(@times, tmp2, B.derivspj{i});
                            end
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times,tmp1,A.derivspj(:,i)) + bsxfun(@times,tmp2, B.derivspj(:,i)');
                end
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                sout.derivspj = cell(globp,1);
                for i = 1 : globp
                    sout.derivspj{i} = bsxfun(@times,tmp1,A.derivspj(:,i)')+ bsxfun(@times, tmp2, B.derivspj(:,i));
                end
            else  % one of A and B is a scalar
                if mA ==1 && nA ==1   % A is a scalar
                    sout.derivspj = bsxfun(@times, tmp1(:), A.derivspj') + bsxfun(@times, tmp2(:), B.derivspj);
                else % B is a scalar
                    sout.derivspj = bsxfun(@times, tmp1(:), A.derivspj) + bsxfun(@times, tmp2(:), B.derivspj');
                end
            end
    end
    
end
sout = class(sout, 'derivspj');

