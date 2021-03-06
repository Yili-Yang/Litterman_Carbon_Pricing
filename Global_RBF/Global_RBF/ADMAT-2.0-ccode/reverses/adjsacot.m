function adjsacot(i)
%
%
%  04/2007 -- consider the case for row vectors
%  04/2007 -- correct the computation of derivative
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
[m,n] = size(tape(i).val);
tmp = -1./(1 + (tape(tape(i).arg1vc).val).^2);
if m == 1 || n == 1
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+tmp(:).*...
        tape(i).W;
else
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+tmp.*...
        tape(i).W;
end


