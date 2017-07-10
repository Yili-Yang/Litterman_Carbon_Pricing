tRvs1 = zeros(30,1);
tFun1 = zeros(30,1);
tFwd1 = zeros(30,1);
tSpr1 = zeros(30,1);
tBRvs1 = zeros(30,1);

load('data1.mat', 'tFun', 'tBRvs', 'tFwd', 'tSpr', 'tRvs');
n = length(tFun);
tFun1(1:n) = tFun;
tBRvs1(1:n) = tBRvs;
tFwd1(1:n) = tFwd;
tSpr1(1:n) = tSpr;
tRvs1(1:n) = tRvs;

load('data2.mat', 'tFun', 'tBRvs', 'tFwd', 'tSpr', 'tRvs');
m = length(tFun);
tFun1(n+1:n+m) = tFun;
tBRvs1(n+1:n+m) = tBRvs;
tFwd1(n+1:n+m) = tFwd;
tSpr1(n+1:n+m) = tSpr;
tRvs1(n+1:n+m) = tRvs;

load('data3.mat', 'tFun', 'tBRvs', 'tFwd', 'tSpr', 'tRvs');
k = length(tFun);
tFun1(n+m+1:n+m+k) = tFun;
tBRvs1(n+m+1:n+m+k) = tBRvs;
tFwd1(n+m+1:n+m+k) = tFwd;
tSpr1(n+m+1:n+m+k) = tSpr;
tRvs1(n+m+1:n+m+k) = tRvs;

tRvs = tRvs1./tFun1;
tFwd = tFwd1./tFun1;
tSpr = tSpr1./tFun1;
tBRvs = tBRvs1./tFun1;

hold on
plot(sort(tRvs));
plot(sort(tSpr), '+');
plot(sort(tBRvs), '*');
plot(sort(tFwd), 'o');

