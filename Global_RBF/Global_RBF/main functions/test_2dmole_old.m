%test_2dmole_old
%test special cases

dim = 8;
m= 1;
lb=-10; ub=10;
xx=(-lb+ub).*(2*rand(m,2*dim)-1)/2+(lb+ub)/2;
% xx=xmatrix(1:16,2);
% xx=[1:2*dim]*3;
 DM = mole_2d_case (dim);

myfun=@molefd_1f2d;
  [f1,g1,H1] = molefd_1f2d(xx,DM);

 n=length(xx);
 [H2, f2, g2] = HtimesV(func2str(myfun),xx,eye(n),DM);

err1=f1-f2;
err2=g1-g2';
err3=H1-H2;

 [Y,Z,D] = nullH(H1,10^(-10));
[Y2,Z2,D2] = nullH(H2,10^(-10));
a1=diag(D);
a2=diag(D2);