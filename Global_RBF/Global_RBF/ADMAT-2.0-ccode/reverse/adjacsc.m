function adjacsc(i)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
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

if m==1 && n==1               % tape(i).val is a scalar
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W -...
        (1./(x .* sqrt(x.^2 - 1))) .* tape(i).W;
else
    if m == 1 || n == 1             % tape(i).val is a vector
        tmp = 1./(x .* sqrt(x.^2 - 1));
        tmp = tmp(:);
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W - ...
            tmp(:,ones(1,globp)) .* tape(i).W;
    else                   % tape(i).val is a matrix
        tmp = 1./(x .* sqrt(x.^2 - 1));
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W -...
            tmp(:,:,ones(1,globp)) .* tape(i).W;
    end
end
