function out=isnan(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


out=reshape(isnan(x.val(:)) | any(isnan(x.deriv), 2), size(x.val));
