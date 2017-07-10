%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        Storage of deriv class object with different
%        value of the golbal variable, globp,
%
%                  
%                  July, 2008
%
%    Source code for Example 5.4.1 in Section 5.4 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%          Part I: globp = 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set the global varible globp to 1
globp = 1;
% input value is a scalar
x = deriv(1)
% input value is a vector
x = deriv(ones(3,1))
% input value is a matrix
x = deriv(ones(3))
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Part II: globp > 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set the global variable globp to 2, larger than 1
globp = 2;
% input value is a scalar
x = deriv(1)
% input value is a vector
x = deriv(ones(3,1))
% input value is a matrix
x = deriv(ones(3))
