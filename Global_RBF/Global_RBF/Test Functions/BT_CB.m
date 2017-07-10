function V0=BT_CB(S0,sigma,sigmar,T,F,K,ita,delta,N,P,Q,D,R,Rx)
% Convertible price by binomial tree method
% reference DONALD R. CHAMBERS AND QIN LU, 2007
%< A Tree Model for pricing Convertiable bonds with Equity, interest rate and Default Risk>
%
% input
%
% S0 - - initial stock price
% r0 - - initial interest rate
% S - - Stock price matrix,size m1*N
% r - - interest rate matrix,size m2*N
% T - - terminal date
% F - - Face value
% K - - Call price
% ita - - conversion ratio, 1 bond = ita stocks, conversion value=ita*S
%delta - - recovery rate, default value =delta*F or delta*S
% N - - time steps
% P - - transition probability, size ML*ML*(N-1), ML=m1*m2
% Q - - transition probability from time 0 to time 1,size ML*1
% D - - default probability
% R - -  riskless interest rate, vector, length is N
%Rx - - risky interest rate, vector, length is N
% output
%
% V0 - - convertible price

% 
dt=T/N;

% calibare to generate interest rate
pr=1/2;
r=zeros(N+1,N+1);
r(1,1)=R(1);
for i=2:N+1
    
end
    



u=exp(-sigma*sqrt(dt));
d=1/u;

p = (exp(r * dt) - d) / (u - d);
q = 1 - p;

% generate underlying prices
S = zeros(N + 1, N + 1);
S(1, 1) = S0;
for i = 1: n
    for j = 0: i - 1
        S(j + 1, i + 1) = S(j + 1, i) * u;
    end
    S(i + 1, i + 1) = S(i, i) * d;
end