function adjsin(i)
%
%
%
%   04/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   04/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   04/2007 -- completed the programming of 'adjmpower.m'
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

[m,n]=size(tape(i).val);
x = tape(tape(i).arg1vc).val;

if m==1  && n == 1             % tape(i).val is a scalar
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + cos(x).*tape(i).W;
else
    if m == 1 || n == 1                 % tape(1).val is a row vector
        tmp = cos(x);
        tmp = tmp(:);
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W +  ...
            tmp(:,ones(1,globp)) .* tape(i).W;
    else                  % tape(1).val is a matrix
        tmp = cos(x);
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
            tmp(:,:, ones(1,globp)).*tape(i).W;
    end
end

