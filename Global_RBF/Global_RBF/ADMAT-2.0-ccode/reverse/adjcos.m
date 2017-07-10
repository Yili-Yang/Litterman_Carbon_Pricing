function adjcos(i)
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

if m==1  && n == 1             % tape(i).val is a scalar
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W -...
        sin(tape(tape(i).arg1vc).val).*tape(i).W;
elseif m == 1 || n == 1
    tmp = sin(tape(tape(i).arg1vc).val);
    tmp = tmp(:);
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W - ...
        tmp(:,ones(1,globp)) .* tape(i).W;
else                  % tape(1).val is a matrix
    tmp = sin(tape(tape(i).arg1vc).val);
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W -...
        tmp(:,:, ones(1,globp)).*tape(i).W;
end


