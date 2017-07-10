function val = mean_weighted(x, mu, n)     
%     
%      Compute the mean of the n vector x     
%           with the weight mu.     
%     
%     INPUT     
%        x -- vector x     
%       mu -- weight for mean computation    
%        n -- length of x    
%     
%     OUTPUT     
%        val -- weighted mean of x     
%     
val = 0;  
y = mu .* x;    
val = sum(y)/n;