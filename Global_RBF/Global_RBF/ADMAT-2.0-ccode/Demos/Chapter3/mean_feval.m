function val = mean_feval(x, Extra) 
% 
%    Compute the mean of the n vector x  
%          with the weight mu.   
%  
%     Note that: this function is satisfied 
%          with the restriction for feval. 
%  
%    INPUT  
%      x -- vector x  
%      Extra -- stores other parameters, mu and n 
%  
%    OUTPUT  
%      val -- weighted mean of x  
%  
mu = Extra.mu; 
n = Extra.n;  
y = mu .* x;
val = sum(y)/n;
