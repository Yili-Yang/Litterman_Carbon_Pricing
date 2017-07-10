function adjsnorm(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape

tmp = (tape(tape(i).arg1vc).val./tape(i).val).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tmp(:);

