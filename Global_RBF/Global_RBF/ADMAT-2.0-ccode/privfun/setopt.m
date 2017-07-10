function options = setopt(entry, entryval)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

options.JPI=[]; 
options.HPI=[]; 
options.func=[]; 
options.V=[]; 
options.W=[];

options.func=entry;
if isequal(entry,'forwprod')
    options.V=entryval;
elseif isequal(entry,'revprod')
    options.W=entryval;
elseif isequal(entry,'htimesv')
    options.V=entryval;
elseif isequal(entry,'vhtimesv')
    options.V=entryval;
elseif isequal(entry,'jacsp')
else
end
