function [] = savetape(op,sout,s1,s2,s3,s4,s5)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global varcounter;

if nargin < 4 s2=[]; end
if nargin < 5 s3=[]; end
if nargin < 6 s4=[]; end
if nargin < 7 s5=[]; end

tape(varcounter).op=op;
tape(varcounter).val=getval(sout);
tape(varcounter).arg1vc=s1;
tape(varcounter).arg2vc=s2;
tape(varcounter).arg3vc=s3;
tape(varcounter).arg4vc=s4;
tape(varcounter).arg5vc=s5;

varcounter=varcounter+1;
