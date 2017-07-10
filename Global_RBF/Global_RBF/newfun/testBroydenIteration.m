function testBroydenIteration()
    %runJacobianTest(20,10,1);
    runHessianNewtonTest(50,32,1);
end

function runJacobianTest(xDim, MaxIter, BroydenMaxIter)
    Extra.MaxIter = MaxIter;
	Extra.BroydenMaxIter = BroydenMaxIter;
	Extra.h = 0.05;
	
	rand('seed',7);
	x = rand(xDim,1);
	
	%% standard AD
    if xDim <= 20
        startup
        AD_fun = ADfun(@DS_Broyden,xDim);
        options = setopt('forwprod',speye(xDim));
        [zsd, Jsd] = feval(AD_fun, x, Extra, options);
        clear global;
    end
    
    %% template AD
	functions = cell(Extra.MaxIter,1);
	functions(1:Extra.MaxIter) = {@broyden};
	
	dependency = cell(Extra.MaxIter,2);
	dependency(1,:) = {1, []};
	dependency(2:end,1) = {0};
	dependency(2:end,2) = num2cell((1:(Extra.MaxIter-1))');

    Extra.N_functions = numel(functions); Extra.xDim = xDim;

    startup
	[ztm,Jtm] = jacobianst(functions,x,dependency,Extra);
    assert( 0 == max(zsd-ztm) )
    assert( 1e-8 > (max(max(Jsd-Jtm))/max(max(Jsd))) )
    
    W = rand(xDim, xDim - 1); Extra.W = W;
    [ztm,Mtm] = jacobianst(functions,x,dependency,Extra);
    assert( 0 == max(zsd-ztm) )
    assert( 1e-8 > (max(max(W'*Jsd-Mtm))/max(max(W'*Jsd))) )
    
    Extra = rmfield(Extra,'W');
    V = rand(xDim, xDim - 1); Extra.V = V;
    [ztm,Mtm] = jacobianst(functions,x,dependency,Extra);
    assert( 0 == max(zsd-ztm) )
    assert( 1e-8 > (max(max(Jsd*V-Mtm))/max(max(Jsd*V))) )
end

function runHessianNewtonTest(xDim,  MaxIter, BroydenMaxIter)
	Extra.MaxIter = MaxIter;
	Extra.BroydenMaxIter = BroydenMaxIter;
	Extra.h = 0.005;
	
	rand('seed',7);
	x = rand(xDim,1);
	
	%profreport
	%% standard AD
    if xDim <= 20
        startup
        [HPI, ~] = gethpi(@DS_Sqe_Broyden, xDim, Extra);
        %profile -memory on
        [zsd,gradsd,Hsd] = evalh(@DS_Sqe_Broyden, x, Extra, HPI);
        %profreport
        %profsave(profile('info'),sprintf('broyden_sd\\dim_%d_N_%d_iter_%d',xDim,MaxIter,BroydenMaxIter))
        clear global;
    end
	
	%% template AD
	functions = cell(Extra.MaxIter+1,1);
	functions(1:Extra.MaxIter) = {@broyden};
	functions{end} = @squaredError;
	
	dependency = cell(Extra.MaxIter+1,2);
	dependency(1,:) = {1, []};
	dependency(2:end,1) = {0};
	dependency(2:end,2) = num2cell((1:Extra.MaxIter));
	
    Extra.N_functions = numel(functions); Extra.xDim = xDim;
	Extra.JPIs = getJPIs(functions, xDim, dependency, Extra);
	Extra.HPIs = getHPIs(functions, xDim, dependency, Extra);
	
	profile -memory on
    tic
	[ztm,gradtm,Htm,Extra] = hessianst(functions,x,dependency,Extra);
    sF = -Htm\gradtm';
    toc1 = toc
	profreport
    profsave(profile('info'),sprintf('broyden_tm\\dim_%d_N_%d_iter_%d',xDim,MaxIter,BroydenMaxIter))
    clear global;
    if xDim <= 20
        assert( 0 == (zsd-ztm) )
        assert( 1e-8 > (max(gradsd-gradtm)/max(gradsd)) )
        assert( 1e-8 > max(max(Hsd-Htm))/max(max(Hsd)) )  
    end
    
    startup
    [zgtm,gradgtm] = gradientst(functions,x,dependency,Extra);
    if xDim <= 20
        assert( 0 == (zsd-ztm) )
        assert( 1e-8 > (max(gradsd-gradtm)/max(gradsd)) )
    else
%        assert( 0 == (zgtm - ztm) )
%        assert( 1e-8 > (max(abs(gradgtm-gradtm))/max(abs(gradtm))) )
    end
    
    
    clear global;
    startup
    profile -memory on
    [zN,gradN,sN,Extra] = newtonst(functions,x,dependency,Extra,0);
    profreport
    profsave(profile('info'),sprintf('broyden_newtonst\\dim_%d_N_%d_iter_%d',xDim,MaxIter,BroydenMaxIter))
    norm(sF-sN)
    assert(norm(sF-sN) < 1e-8);
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

function y = DS_Broyden(x, Extra)
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
