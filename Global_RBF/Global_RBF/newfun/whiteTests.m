function whiteTests()
    clear global
    startup
	testPowerSum();
	testTrignomitry();
end

function testPowerSum()
    %% compute: z = 0.5*sum([x1.^4; x2.^4])
    functions = cell(3,1);
	functions(1:2) = {@dotSquare};
	functions{3} = @squareSum;
	
	dependency = cell(3,2);
	dependency(1,:) = {1, []};
    dependency(2,:) = {1, []};
	dependency(3,:) = {0, [1 2]};
	
	[z,grad,H] = hessianst(functions, ones(3,1), dependency, []);
    assert(z == 3);
    assert(0 == max(grad-4*ones(1,3)));
    assert(0 == max(max(H - 12*speye(3))));
    
    [zN,gradN,sN] = newtonst(functions, ones(3,1), dependency, [], 0);
    
    [z,M] = jacobianst(functions, ones(3,1), dependency, []);
    assert(z == 3);
    assert(0 == max(M-4*ones(1,3)));
    
    Extra.W = [1;2]';
    [z,M] = jacobianst(functions, ones(3,1), dependency, Extra);
    assert(z == 3);
    assert(0 == max(max(M-[4*ones(1,3); 8*ones(1,3)])));
    
    Extra = rmfield(Extra,'W');
    Extra.V = [1 1 0; 0 0 1]';
    [z,M] = jacobianst(functions, ones(3,1), dependency, Extra);
    assert(z == 3);
    assert(0 == max(M-[8, 4]));
end

function z = dotSquare(x, Extra)
	z = x.^2;
end

function z = squareSum(x, Extra)
	z = 0.5*sum(x.^2);
end

function testTrignomitry()
	%% compute sin(a)sin(b)+cos(a)cos(b) = cos(a-b)
    x = [pi/3;pi/6];
	
	functions = cell(3,1);
	functions{1} = @sineProd;
	functions{2} = @cosineProd;
	functions{3} = @sum_e;
	
	dependency = cell(3,2);
	dependency(1:2,1) = {1};
	dependency(3,:) = {0, [1 2]};
	
	[z,grad,H] = hessianst(functions, x, dependency, []);
	phi = x(1) - x(2);
	assert(z == cos(phi));
	assert(1e-10 > max([-sin(phi) sin(phi)] - grad));
	assert(0 == max(max([-cos(phi) cos(phi); cos(phi) -cos(phi)] - H )));
    
    [z,M] = jacobianst(functions, x, dependency, []);
    assert(z == cos(phi));
	assert(1e-10 > max([-sin(phi) sin(phi)] - M));
end

function z = sineProd(x,Extra)
    y = sin(x);
    z = y(1)*y(2);
end

function z = cosineProd(x,Extra)
    y = cos(x);
    z = y(1)*y(2);
end

function z = sum_e(x, Extra)
    z = sum(x);
end