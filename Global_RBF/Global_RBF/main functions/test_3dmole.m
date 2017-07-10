%test_3dmole
%test special cases
n=8;
dim = 3*n;
m= 1;
lb=-10; ub=10;
xx=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
% xx=xmatrix(1:16,2);
% xx=[1:2*dim]*3;
perc_nnz=0.5;
 [ DM,xmole,ymole,zmole,xx1] = make_mole_3d (perc_nnz,n);

myfun=@molefd_1f3d;
  [f1,g1,H1] = molefd_1f3d(xx,DM);

 n=length(xx);
 [H2, f2, g2] = HtimesV(func2str(myfun),xx,eye(n),DM);

err1=f1-f2;
err2=g1-g2';
 err3=H1-H2;
% 
 [Y,Z,D] = nullH(H1,10^(-10));
[Y2,Z2,D2] = nullH(H2,10^(-10));
a1=diag(D);
a2=diag(D2);