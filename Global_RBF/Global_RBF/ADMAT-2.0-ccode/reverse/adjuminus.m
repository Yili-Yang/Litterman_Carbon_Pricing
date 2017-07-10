function adjuminus(i)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global tape;

tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W-tape(i).W;

