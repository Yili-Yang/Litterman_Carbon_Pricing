%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to comapre the results from sample1
%  and sample2 with or without the data type consistency.
%
%
%                
%               April 2009
%
%    Source code for Example 3.4.1 in Section 3.4 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Set problem size
n = 3;
%  Define a 'deriv' tape variable x, which is the forward mode type
%  please refer to Section 5.3 for details of the forward mode
x = deriv([1;2;3], eye(n));
%  call sample1 function
y1 = sample1(x,n)
% call sample2 function
y2 = sample2(x, n)

