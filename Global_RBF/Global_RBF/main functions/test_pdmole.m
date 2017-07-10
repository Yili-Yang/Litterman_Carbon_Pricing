%test_pdmole
%test ordinary cases
n=8;
p=3;
dim = p*n;
m= 1;
lb=-10; ub=10;
xx=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
% xx=xmatrix(1:16,2);
% xx=[1:2*dim]*3;
perc_nnz=0.5;
 [ DM, xxmole] = make_mole_pd (p,perc_nnz,n);

myfun=@mole_pd;
[f1,g1] = mole_pd(xx,DM);

% myfun=@molefd_1f3d;
[f11,g11] = molefd_1f3d(xx,DM);


  options = setgradopt('forwprod', dim);
  myfun1 = ADfun(func2str(myfun), 1);
  [f2,g2] = feval(myfun1, xx,DM,options);
  g2=g2';
  
  options1= setgradopt('revprod', dim);
  [f3,g3]= feval(myfun1,xx,DM,options1);
    g3=g3';
    
%  n=length(xx);
%  [H2, f2, g2] = HtimesV(func2str(myfun),xx,eye(n),DM);
% 
% err1=f1-f2;
% err2=g1-g2';
%  err3=H1-H2;
% % 
%  [Y,Z,D] = nullH(H1,10^(-10));
% [Y2,Z2,D2] = nullH(H2,10^(-10));
% a1=diag(D);
% a2=diag(D2);