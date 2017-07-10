function adjacos(i)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

[m,n]=size(tape(i).val);

if m==1 && n==1               % tape(i).val is a scalar
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W -...
        (1./sqrt(1-(tape(tape(i).arg1vc).val).^2)) .* tape(i).W;
else
    if m == 1 || n == 1             % tape(i).val is a vector
        tmp = 1./sqrt(1-(tape(tape(i).arg1vc).val).^2);
        tmp = tmp(:);
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W - ...
            tmp(:,ones(1,globp)) .* tape(i).W;
    else                   % tape(i).val is a matrix
        tmp = 1./sqrt(1-(tape(tape(i).arg1vc).val).^2);
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W -...
            tmp(:,:,ones(1,globp)) .* tape(i).W;
    end

end


