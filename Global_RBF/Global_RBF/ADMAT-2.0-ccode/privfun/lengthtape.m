function len=lengthtape
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global tapecounter;
len=0;

for i=1:tapecounter-1
    if issparse(tape(i).val)
        len = len+nnz(tape(i).val);
    else
        len = len + numel(tape(i).val);
    end

end

