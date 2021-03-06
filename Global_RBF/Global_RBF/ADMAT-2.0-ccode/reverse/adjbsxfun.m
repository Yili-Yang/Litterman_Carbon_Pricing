function adjbsxfun(i)
%
% Parse tape for applying element-by-element binary operation to two arrays with singleton
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
global tape;
global globp;


if ~isempty(tape(i).arg4vc)                  % one of operands is not derivtape objects
    if tape(i).arg4vc == -1                  % tape(i).arg2vc is not a derivtape object
        A = tape(i).arg2vc;
        B = tape(tape(i).arg3vc).val;
        fun = tape(i).arg1vc;
        [mA, nA] = size(A);
        [mB, nB] = size(B);
        switch func2str(tape(i).arg1vc)
            case{'plus'}
                if mB >= mA && nB >= nA  % The size of B is no less than the size of A
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + tape(i).W;
                elseif (nB == 1 && mA==1) && (mB>1 && nA>1) % B is a column vector, A is a row vector
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,2));
                elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,1));
                elseif  (mA>1 && nA>1) && (nB>1 || mB>1)  %  B is a vector and A is a matrix
                    if (mB == 1 && nB>1) % B is a row vector
                       tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,1));
                    elseif (mB>1 && nB==1)  % B is a column vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,2));
                    end
                else  % B is a scalar
                    if (mA==1 && nA > 1) || (mA>1 && nA == 1)   % A is a vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(tape(i).W,1);
                    else   % A is a matrix
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(squeeze(sum(tape(i).W,2)));
                    end
                end
            case{'minus'}
                if mB >= mA && nB >= nA  % The size of B is no less than the size of A
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - tape(i).W;
                elseif (nB == 1 && mA==1) && (mB>1 && nA>1) % B is a column vector, A is a row vector
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,2));
                elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,1));
                elseif  (mA>1 && nA>1) && (nB>1 || mB>1)  %  B is a vector and A is a matrix
                    if (mB == 1 && nB>1) % B is a row vector
                       tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,1));
                    elseif (mB>1 && nB==1)  % B is a column vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,2));
                    end
                else  % B is a scalar
                    if (mA==1 && nA > 1) || (mA>1 && nA == 1)   % A is a vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - sum(tape(i).W,1);
                    else   % A is a matrix
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - sum(squeeze(sum(tape(i).W,2)));
                    end
                end
            case{'times'}
                if mB >= mA && nB >= nA  % The size of B is no less than the size of A
                    if nB == 1  % B is a row vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W')';
%                     elseif mB>1 && nB>1  % B is a matrix
%                         for i = 1 : globp
%                             tape(tape(i).arg3vc).W(:,:,i) = tape(tape(i).arg3vc).W(:,:,i) + bsxfun(fun, A, tape(i).W(:,:,i));
%                         end
                    else
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W);
                    end
                elseif (nB == 1 && mA==1) && (mB>1 && nA>1) % B is a column vector, A is a row vector
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A,tape(i).W),2));
                elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A,tape(i).W),1));
                elseif  (mA>1 && nA>1) && (nB>1 || mB>1)  %  B is a vector and A is a matrix
                    if (mB == 1 && nB>1) % B is a row vector
                       tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A, tape(i).W),1));
                    elseif (mB>1 && nB==1)  % B is a column vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A, tape(i).W),2));
                    end
                else  % B is a scalar
                    if (mA==1 && nA > 1) || (mA>1 && nA == 1)   % A is a vector
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(bsxfun(fun, A(:), tape(i).W),1);
                    else   % A is a matrix
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(squeeze(sum(bsxfun(fun, A, tape(i).W),2)));
                    end
                end
            case{'ldivide'}
            case{'rdivide'}
            case{'power'}
        end
    elseif tape(i).arg4vc == -2   % tape(i).arg3vc is not a derivtape object
        A = tape(tape(i).arg2vc).val;
        B = tape(i).arg3vc;
        fun = tape(i).arg1vc;
        [mA, nA] = size(A);
        [mB, nB] = size(B);
        switch func2str(tape(i).arg1vc)
            case{'plus', 'minus'}
                if mA >= mB && nA >= nB  % The size of A is no less than the size of B
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                elseif (nA == 1 && mB==1) && (mA>1 && nB>1) % A is a column vector, B is a row vector
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,2));
                elseif (mA==1 && nB==1) && (nA>1 && mB>1)   % A is a row vector, B is a column vector
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,1));
                elseif  (mB>1 && nB>1) && (nA>1 || mA>1)  %  A is a vector and B is a matrix
                    if (mA == 1 && nA>1) % A is a row vector
                       tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,1));
                    elseif (mA>1 && nA==1)  % A is a column vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,2));
                    end
                else  % A is a scalar
                    if (mB==1 && nB > 1) || (mB>1 && nB == 1)   % B is a vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(tape(i).W,1);
                    else   % B is a matrix
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(squeeze(sum(tape(i).W,2)));
                    end
                end
            case{'times'}
                if mA >= mB && nA >= nB  % The size of A is no less than the size of B
                    if nA == 1  % A is a row vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W')';
%                     elseif mB>1 && nB>1  % B is a matrix
%                         for i = 1 : globp
%                             tape(tape(i).arg3vc).W(:,:,i) = tape(tape(i).arg3vc).W(:,:,i) + bsxfun(fun, A, tape(i).W(:,:,i));
%                         end
                    else
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W);
                    end
                elseif (nA == 1 && mB==1) && (mA>1 && nB>1) % A is a column vector, B is a row vector
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B,tape(i).W),2));
                elseif (mA==1 && nB==1) && (nA>1 && mB>1)   % A is a row vector, B is a column vector
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B,tape(i).W),1));
                elseif  (mB>1 && nB>1) && (nA>1 || mA>1)  %  A is a vector and B is a matrix
                    if (mA == 1 && nA>1) % A is a row vector
                       tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B, tape(i).W),1));
                    elseif (mA>1 && nA==1)  % A is a column vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B, tape(i).W),2));
                    end
                else  % A is a scalar
                    if (mB==1 && nB > 1) || (mB>1 && nB == 1)   % B is a vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(bsxfun(fun, B(:), tape(i).W),1);
                    else   % B is a matrix
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(squeeze(sum(bsxfun(fun, B, tape(i).W),2)));
                    end
                end
            case{'ldivide'}
            case{'rdivide'}
            case{'power'}
        end
    end
else    %  % both tape(i).arg2vc and tape(i).arg3vc are derivtape objects
     A = tape(tape(i).arg2vc).val;
     B = tape(tape(i).arg3vc).val;
     fun = tape(i).arg1vc;
     [mA, nA] = size(A);
     [mB, nB] = size(B);
     switch func2str(fun)
         case{'plus'}
             if mB == mA && nB == nA  % The size of A is same as B
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + tape(i).W;
            elseif (nA> 1 && mA>1) || (mB>1 && nB>1) % one of A and B is a matrix, not both
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                       tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                       tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,2));
                    else  % B is a row vector or a scalar
                        if nB == 1   % B is a saclar
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(squeeze(sum(tape(i).W,2)));
                        else  % B is a row vector
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(squeeze(sum(tape(i).W,1)));
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,2));
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + tape(i).W;
                    else  % A is a row vector or a scalar
                        if nA == 1  % A is a scalar
                             tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(squeeze(sum(tape(i).W,2)));
                             tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + tape(i).W;
                        else
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,1));
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + tape(i).W;
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                 tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,2));
                 tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,1));
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                 tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,1));
                 tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(tape(i).W,2));
            else  % one of A and B is a scalar
                if mA == 1 && nA == 1   % A is a scalar
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(tape(i).W,1);
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + tape(i).W;
                else
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(tape(i).W,1);
                end
             end
            case{'minus'}
             if mB == mA && nB == nA  % The size of A is same as B
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - tape(i).W;
            elseif (nA> 1 && mA>1) || (mB>1 && nB>1) % one of A and B is a matrix, not both
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                       tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                       tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,2));
                    else  % B is a row vector or a scalar
                        if nB == 1   % B is a saclar
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - sum(squeeze(sum(tape(i).W,2)));
                        else  % B is a row vector
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,1));
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,2));
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - tape(i).W;
                    else  % A is a row vector or a scalar
                        if nA == 1  % A is a scalar
                             tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(squeeze(sum(tape(i).W,2)));
                             tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - tape(i).W;
                        else
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,1));
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - tape(i).W;
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                 tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,2));
                 tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,1));
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                 tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(tape(i).W,1));
                 tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - squeeze(sum(tape(i).W,2));
            else  % one of A and B is a scalar
                if mA == 1 && nA == 1   % A is a scalar
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(tape(i).W,1);
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - tape(i).W;
                else
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W - sum(tape(i).W,1);
                end
            end
         case{'times'}
             if mB == mA && nB == nA  % The size of A is same as B
                 if nB == 1 && mB >1   % B is a row vector
                     tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B(:), tape(i).W);
                     tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A(:), tape(i).W);
                 else
                     tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W);
                     tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W);
                 end
            elseif (nA> 1 && mA>1) || (mB>1 && nB>1) % one of A and B is a matrix, not both
                if (nA>1 && mA>1)  % A is a matrix
                    if mB > 1  % B is a column vector
                       tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W);
                       tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A, tape(i).W),2));
                    else  % B is a row vector or a scalar
                        if nB == 1   % B is a saclar
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W);
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(squeeze(sum(bsxfun(fun, A, tape(i).W),2)));
                        else  % B is a row vector
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W);
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, B, tape(i).W),1));
                        end
                    end
                else     % B is a matrix
                    if mA > 1 % A is a column vector
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B, tape(i).W),2));
                        tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W);
                    else  % A is a row vector or a scalar
                        if nA == 1  % A is a scalar
                             tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(squeeze(sum(bsxfun(fun, B, tape(i).W),2)));
                             tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W);
                        else
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B, tape(i).W),1));
                            tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W);
                        end
                    end
                end
            elseif (mB==1 && nA==1) && (nB>1 && mA>1)   % B is a row vector, A is a column vector
                 tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B, tape(i).W),2));
                 tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A, tape(i).W),1));
            elseif  (mB>1 && nB==1) && (nA>1 && mA==1)  %  B is a column vector and A is a row vector
                 tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + squeeze(sum(bsxfun(fun, B,tape(i).W),1));
                 tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + squeeze(sum(bsxfun(fun, A, tape(i).W),2));
            else  % one of A and B is a scalar
                if mA == 1 && nA == 1   % A is a scalar
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(bsxfun(fun, B(:),tape(i).W),1);
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + bsxfun(fun, A, tape(i).W);
                else
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + bsxfun(fun, B, tape(i).W);
                    tape(tape(i).arg3vc).W = tape(tape(i).arg3vc).W + sum(bsxfun(fun, A(:), tape(i).W),1);
                end
            end
         case{'ldivide'}
         case{'rdivide'}
         case{'power'}
     end
end