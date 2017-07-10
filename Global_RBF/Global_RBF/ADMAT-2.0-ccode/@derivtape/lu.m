function [L,U]=lu(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;
[L.val,U.val]=lu(A.val);

L.varcount=varcounter;
L=class(L,'derivtape');
savetape('luu',L,L.varcount+1,A.varcount);


U.varcount=varcounter;
U=class(U,'derivtape');
savetape('lul',U,L.varcount,A.varcount);



