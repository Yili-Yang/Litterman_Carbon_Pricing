%test_1dmole_old

dim = 10;
m= 1;
lb=-10; ub=10;
x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
perc_nnz=.75;
[DM, xmole] = make_mole_1d (perc_nnz,dim);
myfun=@molefd;
 [f1,g1,H1] = molefd(x,DM);

 n=length(x);
 [H2, f2, g2] = HtimesV(func2str(myfun),x,eye(n),DM);
 
% options = setgradopt('forwprod', n);
% %  options = setgradopt('revprod', n);
% myfun1 = ADfun(func2str(myfun));
% [f,g2,H2] = feval(myfun1,x,DM);


err1=f1-f2;
err2=g1-g2';
err3=H1-H2;

[Y,Z,D] = nullH(H1,10^(-10));
[Y2,Z2,D2] = nullH(H2,10^(-10));