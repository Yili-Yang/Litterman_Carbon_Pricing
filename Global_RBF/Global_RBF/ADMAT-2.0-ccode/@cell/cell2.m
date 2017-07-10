function s= cell(a)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


%
% Derivative class for AD of M-files
%
if nargin==0
    s.val=cell(1);
    s.val=0;
    s=class(s,'cell');
elseif isa(a,'cell')
    s=a;
else
   s.val=a;
   s=class(s,'cell');
end
