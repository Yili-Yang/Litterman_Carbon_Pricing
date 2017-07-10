function [f,gr,Hs]=TRcostfun(x,varargin)

% objective function of Transation Cost
%input 
%x --  row vector
%varargin -- cell 1*1, varargin{1} inclued H,g,epsilon,m_posi,k_posi,m_nega,k_nega
if size(x,2)~=1
    x=x';%keep x as column vector
end
if size(varargin,2)==1
    varargin=varargin{1}; %keep the length of varargin is 7;
end
% varargin=H,g,epsilon,m_posi,k_posi,m_nega,k_nega
 H=varargin{1};
 g=varargin{2};
 epsilon=varargin{3};
 m_posi=varargin{4};
 k_posi=varargin{5};
 m_nega=varargin{6};
 k_nega=varargin{7};
 
[a,b,c]=TR_COST(epsilon,m_posi,k_posi,x,m_nega,k_nega);
f = 0.5*x'*H*x+g'*x+a;     % Compute the objective function value at x
% Function called with two output arguments
if(nargout >= 2)
    gr = H*x+g+b;            % Gradient of the function evaluated at x
end
if(nargout == 3)
    % Function called with three output arguments
    Hs = H+c;               % Hessian evaluated at x
end







% to genearte varargin

% n=10;
% m=5;
% A=rand(n,m);
% 
% [Q,R]=qr(A);
% D=zeros(n);
% D(1,1)=1;
% condition=10000;
% D(n,n)=1/condition;
% for i=2:n-1
%     D(i,i)=(1-1/condition)*rand(1)+1/condition;
% end
% 
% H=Q'*D*Q;
% g=-ones(n,1)+2*rand(n,1);
% m_posi = zeros(n,m);
% k_posi = zeros(n,m);
% m_nega = zeros(n,m);
% k_nega = zeros(n,m);
% epsilon = 0.5;
% 
% m_up = 100; m_low = 1;
% for i=1:n
%     m_posi(i,:) = m_low + (m_up-m_low)/m*((rand(1,m)-0.5)/2+(m:-1:1));
%     k_posi(i,:) = [3,1*(1:m-1)];
%     m_nega(i,:) = -(m_low + (m_up-m_low)/m*((rand(1,m)-0.5)/2+(m:-1:1)));
%     k_nega(i,:) = [-3,-1*(1:m-1)];
% end