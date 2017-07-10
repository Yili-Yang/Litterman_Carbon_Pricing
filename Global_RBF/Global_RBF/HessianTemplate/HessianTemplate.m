function [z, grad, H, Extra] = HessianTemplate(functions, x, dependency, Extra)
%% required AD methods: feval, evalj, evalh

	%% initialization
	Extra = initialize(functions,x,dependency,Extra);	
	xDim = Extra.xDim; yDims = Extra.yDims; yDim = sum(yDims(1:end-1)); 
    N_functions = Extra.N_functions;
    JPIs = Extra.JPIs; HPIs = Extra.HPIs; idx_y = Extra.idx_y;
	
	Y   = cell(N_functions,1);	% to store output of each function
	Y_J = cell(N_functions,1);	% to store 1st partials of each function

	%% forward mode to evaluate partials
	for n = 1:(N_functions-1)
		[Y{n}, Y_J{n}] = evalj(functions{n}, input(x,Y,dependency(n,:)), Extra, yDims(n), JPIs{n});
    end
    [Y{end}, Y_J{end}, z_H] = evalh(functions{end}, input(x,Y,dependency(end,:)), Extra, HPIs{end});
    z = Y{end};

	%% reverse mode to compute differential factors w and the gradient grad
	grad = zeros(1,xDim);
	W = cell(1,N_functions);
	W{end} = 1;
	for n = N_functions:-1:1
		dYn = full(W{n}*Y_J{n}); % expand differential dy_n
		if dependency{n,1}	% update total derivatives dz/dx
			grad = grad + dYn(1:xDim);
		end
		
		head = 1 + dependency{n,1}*xDim;
		for k = dependency{n,2}
			tail = head + yDims(k) - 1;
			if isempty(W{k})  % update total derivatives dz/dy_k
				W{k} = dYn(head:tail);
			else
				W{k} = W{k} + dYn(head:tail);
			end
			head = tail + 1;
		end
	end
	w = cell2mat(W(1:(end-1)));  % total derivatives dz/dy
    
	%% 2nd partials of helper function g
    g_H = sparse(xDim+yDim,xDim+yDim);
    idx = [1:(xDim*dependency{end,1}), xDim+cell2mat(idx_y(dependency{end,2}))];
    g_H(idx,idx) = z_H;
    for n = 1:(N_functions-1)
        Mask.function = functions{n}; Mask.Extra = Extra;
		Mask.w = w(idx_y{n});
        [~,~, wy_H] = evalh(@maskFun, input(x,Y,dependency(n,:)), Mask, HPIs{n});
        idx = [1:(xDim*dependency{n,1}), xDim+cell2mat(idx_y(dependency{n,2}))];
        g_H(idx,idx) = g_H(idx,idx) + wy_H;
    end

	%% forward mode to compute U
    U = cell(N_functions,1);
    U{1} = Y_J{1};
    for n = 2:(N_functions)
        Yn_J = Y_J{n};  U{n} = 0;
        if dependency{n,1} % compute total derivatives dy_n/dx
            U{n} = Yn_J(:,1:xDim);
        end
        head = dependency{n,1}*xDim + 1;
        for k = dependency{n,2}
            U{n} = U{n} + Yn_J(:, head:(head+yDims(k)-1))*U{k};
            head = head + yDims(k);
        end
    end
    % assert(0 == norm(U{end}-grad), 'forward and reverse mode should generate consistent values of gradient');
	U = cell2mat(U(1:end-1));

	%% assemble the Hessian
	idx = 1:xDim; idy = (xDim+1):size(g_H,2);
	C = g_H(idx,idy)*U;
	R = U'*g_H(idy,idy)*U;
	H = g_H(idx,idx) - C - C' + R;
end

function Extra = initialize(functions, x, dependency, Extra)
%% check parameters and fill in the missing ones
	Extra.N_functions = size(functions,1);
	assert( 1 == size(functions,2), 'functions must be a column cell of strings');
	assert( Extra.N_functions == size(dependency,1), 'dependency must be specified for each function');

	[Extra.xDim, nrow] = size(x);
	assert( 1 == nrow, 'input x must be a column array');
	
	if ~isfield(Extra,'yDims') % if not given, get output dimensions of each function
		[Extra.yDims, Extra.idx_y] = getYDims(functions,x,dependency,Extra);
	end
	
	if ~isfield(Extra,'JPIs') % if not given, get sparsity information of each Jacobian
		Extra.JPIs = getJPIs(functions,Extra.xDim,Extra.yDims,dependency,Extra);
	end
	
	if ~isfield(Extra,'HPIs') % if not given, get sparsity information of each Hessian
		Extra.HPIs = getHPIs(functions,Extra.xDim,Extra.yDims,dependency,Extra);
    end
end

function [yDims, idx_y] = getYDims(functions, x, dependency, Extra)
%% get output dimensions of each function
	yDims = zeros(Extra.N_functions, 1); head = 1;
    idx_y = cell(1,Extra.N_functions);
	Y = cell(Extra.N_functions,1);
	for n = 1:Extra.N_functions
		Y{n} = feval(functions{n}, input(x,Y,dependency(n,:)), Extra);
		yDims(n) = size(Y{n},1);
        idx_y{n} = head:(head + yDims(n) - 1);
        head = head + yDims(n);
	end
end

function JPIs = getJPIs(functions, xDim, yDims, dependency, Extra)
%% get sparsity information of each Jacobian
	JPIs = cell(Extra.N_functions,1);
	for n = 1:Extra.N_functions
		[JPIs{n}, ~] = getjpi(functions{n}, yDims(n), xDim*dependency{n,1}+sum(yDims(dependency{n,2})), Extra);
	end
end

function HPIs = getHPIs(functions, xDim, yDims, dependency, Extra)
%% get sparsity information of each Hessian
	HPIs = cell(Extra.N_functions,1);
	for n = 1:Extra.N_functions
		Mask.function = functions{n}; Mask.Extra = Extra;
		Mask.w = ones(1,yDims(n));
		[HPIs{n}, ~] = gethpi(@maskFun, xDim*dependency{n,1}+sum(yDims(dependency{n,2})), Mask);
	end
end

function X = input(x,Y,dependency)
%% assemble needed input
    X = [];
    if dependency{1}
        X = x;
    end
    if ~isempty(dependency{2})
        X = [X; cell2mat(Y(dependency{2}))];
	end
end

function z = maskFun(x, Mask)
%% functional mask for vector function
	z = Mask.w*feval(Mask.function, x, Mask.Extra);
end