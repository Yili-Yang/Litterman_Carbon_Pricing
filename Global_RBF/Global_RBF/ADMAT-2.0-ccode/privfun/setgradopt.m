function options = setgradopt(entry, siz)
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
switch entry
    case 'forwprod'
        options.V = eye(siz);
    case 'revprod'
        options.W = 1;
    otherwise
        error('undefine AD modes');
end
% if isequal(entry,'forwprod')
%     options.V=eye(siz);
% elseif isequal(entry,'revprod')
%     options.W=1;
% elseif isequal(entry,'htimesv')
%     options.V=entryval;
% elseif isequal(entry,'vhtimesv')
%     options.V=entryval;
% elseif isequal(entry,'jacsp')
% else
% end
