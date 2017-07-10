function adjspdiags(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

if globp > 1
    for j=1:globp
        tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)+...
            spdiags(tape(i).W(:,:,j),tape(i).arg2vc);
    end
else
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
        spdiags(tape(i).W,tape(i).arg2vc);
end
