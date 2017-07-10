function f = plotfunction( myfun, x, delta, varargin )
% plot the smooth function. Inpute the function name, delta value and other
% input for myfun.
[f,~,H]=feval(myfun,x,varargin{:});
f=f+1/6*delta*delta*trace(H);

end

