function sout=fft(X,N,DIM)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a 
%              column vector
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout.val=fft(X.val);
sout.deriv = fft(X.deriv);
% for i=1:globp 
%     sout.deriv(:,i)=fft(X.deriv(:,i));
% end
sout=class(sout,'deriv');
