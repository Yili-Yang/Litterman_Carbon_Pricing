function demoBroydenIteration
    doProfile = true;  Tol = 1e-10;
    Extra.h = 0.02;
    Extra.xDim = 80;
    Extra.MaxIter = 1;
	Extra.BroydenMaxIter = 50;
    
    
    for MaxIter = 1 % [1,2,5,10,25,50]
        Extra.MaxIter = MaxIter;
        Extra.BroydenMaxIter = 50/MaxIter;
        [ztp,gtp,Htp] = demoBroydenIterationTemplate(Extra,doProfile);
    end
    [zsp,gsp,Hsp] = demoBroydenIterationSparseAD(Extra,doProfile);
    z = zsp
    
    assert( max(max(zsp-ztp))/norm(z) < Tol);
    assert( max(max(gsp-gtp))/norm(z) < Tol);
    assert( max(max(Hsp-Htp))/norm(z) < Tol);
end

function [z,grad,H] = demoBroydenIterationSparseAD(Extra, doProfile)
    rand('seed',7); x = rand(Extra.xDim,1);
    startup     % initialize ADMAT
    [HPI, ~] = gethpi(@DS_Sqe_Broyden, Extra.xDim, Extra);
    if doProfile
        profreport
        profile -memory on
    end
    [z,grad,H] = evalh(@DS_Sqe_Broyden, x, Extra, HPI);
    if doProfile
        profreport
        profsave(profile('info'),sprintf('broyden_sp\\dim_%d_N_%d_iter_%d',Extra.xDim,Extra.MaxIter,Extra.BroydenMaxIter))
    end
    clear global;
end

function [z,grad,H] = demoBroydenIterationTemplate(Extra, doProfile)
    rand('seed',7); x = rand(Extra.xDim,1);
    startup     % initialize ADMAT
    %% template AD
	functions = cell(Extra.MaxIter+1,1);
	functions(1:Extra.MaxIter) = {@broyden};
	functions{end} = @squaredError;
	
	dependency = cell(Extra.MaxIter+1,2);
	dependency(1,:) = {1, []};
	dependency(2:end,1) = {0};
	dependency(2:end,2) = num2cell((1:Extra.MaxIter)');
	
    Extra.N_functions = numel(functions);
	Extra.JPIs = getJPIs(functions, Extra.xDim, dependency, Extra);
	Extra.HPIs = getHPIs(functions, Extra.xDim, dependency, Extra);
	
	if doProfile
        profreport
        profile -memory on
    end
	[z,grad,H,Extra] = HessianTemplate(functions,x,dependency,Extra);
	if doProfile
        profreport
        profsave(profile('info'),sprintf('broyden_tp\\dim_%d_N_%d_iter_%d',Extra.xDim,Extra.MaxIter,Extra.BroydenMaxIter))
    end
    clear global;
end

function z = DS_Sqe_Broyden(x, Extra)
	h = Extra.h;
    xDim = numel(getval(x));
    y = x;
    for n = 1:(Extra.MaxIter*Extra.BroydenMaxIter)
        y(1) = (3-2*y(1))*y(1) - 2*y(2);
        for j = 2:(xDim-1)
            y(j) = (3-2*y(j))*y(j) - y(j-1) - 2*y(j+1);
        end
        y(xDim) = (3-2*y(xDim))*y(xDim) - y(xDim-1);
        y = h*y;
    end
    z = y'*y;
end

function y = broyden(x, Extra)
	h = Extra.h; xDim = Extra.xDim;
    y = x;
    for k = 1:Extra.BroydenMaxIter
        y(1) = (3-2*y(1))*y(1) - 2*y(2);
        for j = 2:(xDim-1)
            y(j) = (3-2*y(j))*y(j) - y(j-1) - 2*y(j+1);
        end
        y(xDim) = (3-2*y(xDim))*y(xDim) - y(xDim-1);
        y = h*y;
    end
end

function z = squaredError(x, Extra)
    z = x'*x;
end

function JPIs = getJPIs(functions, xDim, dependency, Extra)
%% get sparsity information of each Jacobian
	JPIs = cell(numel(functions));
	[JPIs{1}, ~] = getjpi(functions{1}, xDim, xDim, Extra);
	JPIs(2:end-1) = JPIs(1);
	[JPIs{end}, ~] = getjpi(functions{end}, 1, xDim, Extra);
end

function HPIs = getHPIs(functions, xDim, dependency, Extra)
%% get sparsity information of each Hessian
	HPIs = cell(numel(functions),1);
	
	Mask.function = functions{1}; Mask.Extra = Extra;
	Mask.w = ones(1,xDim);
	[HPIs{1}, ~] = gethpi(@maskFun, xDim, Mask);
	HPIs(2:end-1) = HPIs(1);
	
	[HPIs{end}, ~] = gethpi(functions{end}, xDim, Mask);
end

function z = maskFun(x, Mask)
%% functional mask for vector function
	z = Mask.w*feval(Mask.function, x, Mask.Extra);
end
