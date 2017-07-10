function adjdet(i)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   03/2007 -- correct the computation of derivatives of asech(x).
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global tape;
global globp;

x = tape(tape(i).arg1vc).val;

[m,n]=size(x);

if m==1 && n==1               % tape(i).val is a scalar
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W - ...
        1./x .* tape(i).W;
else                          % tape(i).val is a matrix
    iA=inv(tape(tape(i).arg1vc).val);
    for j=1:globp
        tape(tape(i).arg1vc).W(:,j)=tape(i).val * trace(iA*tape(i).W(:,:,j));
    end
end

% iA=inv(tape(tape(i).arg1vc).val);
% 
% for i=1:globp
%     tape(tape(i).arg1vc).W(:,i)=tape(i).val*trace(iA*tape.deriv(:,:,i));
% end


