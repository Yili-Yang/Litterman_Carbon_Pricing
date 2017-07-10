function i = end(x,k,n)
%END          Overloaded functions end, specifies last index
%

% developed  05/2009 
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ***************************************************************



  if n==1           % call as one-dimensional array
    i = length(getval(x(:)));
  else
    i = size(getval(x),k);
  end