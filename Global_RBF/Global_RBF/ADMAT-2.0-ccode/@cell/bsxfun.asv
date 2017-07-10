function sout = bsxfun(fun, s1, s2)
%
%Apply element-by-element binary operation to two arrays with singleton
% expansion enabled for cell structure. Currently, only support
%
% @plus   Plus
%
% @minus  Minus
%
% @times  Array multiply
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
%
[m1,n1] = size(s1);
[m2,n2] = size(s2);
if iscell(s1) && ~iscell(s2)
    sout = cell(m1,n1);
    for i = 1 : m1
        sout{i} = bsxfun(fun, s1{i}, s2);
    end        
elseif ~iscell(s1) && iscell(s2)
    sout = cell(m2, n2);
    for i = 1 : m2
        sout{i} = bsxfun(fun, s1, s2{i});
    end
else
    sout = cell(m1,n1);
    for i = 1 : m1
        sout{i} = bsxfun(fun, s1{i}, s2{i});
    end
end