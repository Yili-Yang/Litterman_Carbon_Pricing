function [val,g,H] = TR_COST(epsilon,m_posi,k_posi,x,m_nega,k_nega)

n = length(x);
val = 0;
g = zeros(n,1);
H = zeros(n,n);

if(length(epsilon)==1)
    epsilon = epsilon*ones(n,1);
end

if nargin < 5
    for i=1:n
        [a,b,c] = tr_cost_smooth(epsilon(i),m_posi(i,:),k_posi(i,:),x(i));
        
        val = val + a;
        g(i) = b;
        H(i,i) = c;
    end
else
    for i=1:n
        [a,b,c] = tr_cost_smooth(epsilon(i),m_posi(i,:),k_posi(i,:),x(i),m_nega(i,:),k_nega(i,:));
        
        val = val + a;
        g(i) = b;
        H(i,i) = c;
    end    
end
end