function [ xbest , fbest ] = PureSA ( myfun, x0, Ts, kB, L,...
    srmin, lb, ub, tracking, varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traditional simulated annealing algorithm. Search region depends on the
% temperature and has a minimum value. 
% Can draw the picture of all attempted function value and accepted
% function value and fbest if tracking parameter is set for 1
%
% Input arguments:
% fun - function name
% x0 - starting point
% Ts(1:end) - temperatures from hottest to coldest (Ts(end) cannot be 0)
% kB - Boltzmann constant
% L - number of trials at one temperature
% srmin - minimum search range
% lb,ub - lower,upper bounds on x
% tracking - whether draw the picture of tracking
% varargin - additional arguments to function "fun"
%
% Returns:
% final result of f and x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Ts(1)<0)
    error('Wrong Temperature Sequence!');
end

x = x0;
xbest=x0;
fbest=feval(myfun,x0,varargin{:});
f_vec = zeros(length(Ts)*L,1);
f_vecold = zeros(length(Ts)*L,1);
ind = 0;

for i=1:length(Ts)
    T = Ts(i);
    sr = max((-lb+ub)*(T./max(Ts)),srmin);
    %sr =(-lb+ub)*(T./max(Ts));
    fold = feval(myfun,x,varargin{:});
    for j=1:L
        xnew = neighbor(x, sr, lb, ub);
        fnew = feval(myfun,xnew,varargin{:});
        ind=ind+1;
        f_vec(ind) = fnew;
        % accept new point if either function value is less or
        % accept a worse point with probability depending on T
        
        if (fnew <= fold)
            x = xnew;
            fold = fnew;
            
        elseif (exp(-(fnew-fold)/kB/T) > rand)
            x = xnew;
            fold = fnew;
        end
        if(fold<fbest)
            fbest=fold;
            xbest=x;
        end
        f_vecold(ind)=fold;
    end
end

if (tracking==1)
figure
plot(f_vec, 'blue');
hold on;
plot(f_vecold, 'green');
hold on;
minsofar = f_vec;
for i = 1:length(f_vec)
    minsofar(i) = min(f_vec(1:i));
end
plot(minsofar, 'red');
end

end