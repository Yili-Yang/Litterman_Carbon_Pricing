function sout=squeeze(s1)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

[m,n]=size(s1);
[m1 , n1] = size(s1{1,1})
if m == 1 || n == 1   % cell structure is a vector
  if m1 == 1 && n1 >1 % each cell is a row vector
    sout = zeros(n1, globp);
    for i = 1 : globp
        sout(:,i) = s1{i}';
    end
    sout = sparse(sout);
  elseif n1==1 && m1>1  % each cell is a column vector
      sout = zeros(m1,globp);
      for i = 1 : globp
          sout(:,i) = s1{i};
      end
      sout = sparse(sout);
  else
      sout = s1;
  end
else
    sout = s1;
end

        