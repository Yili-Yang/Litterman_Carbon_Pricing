function [ xbest , fbest, evalf, evalH ] = SmoothTraceSA ( myfun, x0,...
    Ts, kB, L, delta, srmin, lb, ub, tracking, varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trace-Smooth technique with simulated annealing, delta sequence contains
% several entries and for each entry we run through all temperature
% sequence. 
% Can draw the picture of all attempted function value and accepted
% function value and fbest if tracking parameter is set for 1
%
% Need ADMAT to compute H if user doesn't supply it
%
% Input arguments:
% fun - function name
% x0 - starting point
% Ts(1:end) - temperatures from hottest to coldest (Ts(end) cannot be 0)
% kB - Boltzmann constant
% L - number of trials at one temperature
% delta(1:end) - delta sequence, last entry should be 0
% srmin - minimum search range
% lb,ub - lower,upper bounds on x
% tracking - whether draw the picture of tracking
% varargin - additional arguments to function "fun"
%
% Returns:
% the final result of f and x and the number of evaluation of function
% value and Hessian matrix
%
% "orig" refers to the user specified function
% non-"orig" refers to the modified function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Ts(1)<0)
    error('Wrong Temperature Sequence!');
end

if(delta(end)~=0)
    error('Last entry of Delta sequence must be 0!')
end

x = x0;
xbest=x0;
fbest=myfun(x0,varargin{:});
evalf=1;
evalH=0;
f_vec = zeros(length(Ts)*L*length(delta),1);
f_vecold = zeros(length(Ts)*L*length(delta),1);
ind = 0;
% n=length(x0);
% HPI=gethpi('rast',n);
for k=1:length(delta)
    Delta=delta(k);
    for i=1:length(Ts)
        T = Ts(i);
        sr = max((-lb+ub)*(T./max(Ts)),srmin);
        [fold_orig,~,H] = feval(myfun,x,varargin{:});
        evalf=evalf+1;
        evalH=evalH+1;
        fold = fold_orig + 1/6*Delta*Delta*trace(H);
        
        for j=1:L
            xnew = neighbor(x, sr, lb, ub);
            [fnew_orig,~,H] = feval(myfun,xnew,varargin{:});
            evalf=evalf+1;
            evalH=evalH+1;
            fnew = fnew_orig + 1/6*Delta*Delta*trace(H);
            ind=ind+1;
            f_vec(ind) = fnew;
            % accept new point if either function value is less or
            % accept a worse point with probability depending on T
            
            if (fnew <= fold)
                x = xnew;
                fold = fnew;
                fold_orig=fnew_orig;
            elseif (exp(-(fnew-fold)/kB/T) > rand)
                x = xnew;
                fold = fnew;
                fold_orig=fnew_orig;
            end
            
            if(fold_orig<fbest)
                fbest=fold_orig;
                xbest=x;
            end
            f_vecold(ind)=fold;
        end
    end
end

if(tracking==1)
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