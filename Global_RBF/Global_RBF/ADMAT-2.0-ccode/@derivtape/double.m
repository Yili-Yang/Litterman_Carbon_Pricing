function y=double(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global warningon;

if warningon
disp('Warning ... a Deriv object being converted to double');
disp('For statements of type u(I)=z, if u is a double before then u would not be a active variable');
disp('To make u active, make sure u is active before execution of this statement');
end

y=getval(x);
