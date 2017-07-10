clear all; clc;

M = 100;
xs = [(M:-1:1)/M, (M:-1:1)/M, zeros(1,2*M)]';
%         xs=randn(4*M,1);
idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
b0 = sparse(idr,ones(4*M,1),xs);

d1 = -ones(M^2,1);
d2 = d1; d2(M:M:end) = 0;
d3 = 4*ones(M^2,1);
d4 = [-1;d2(1:(end-1))];

A = spdiags([d1, d2, d3, d4, d1],[-M,-1,0,1,M],M^2,M^2);
B=inv(A);
uT=B*b0;

clear DM;
DM.B=B;
DM.uT=uT;
varargin=DM;
m=2;
x=randn(2,4*M);
%         x=zeros(m,4*M);
%         xa = xs + (rand(4*M,1)-0.5)*max(xs);
%         x(1,:)=xa';
%         xc = xs + (rand(4*M,1)-0.5)*max(xs);
%         x(2,:)=xc';
dim=4*M;