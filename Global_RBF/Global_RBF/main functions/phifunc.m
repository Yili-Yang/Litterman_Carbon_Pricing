function [ f , g , H ] = phifunc ( x , method , gamma )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phi function for the RBF model. Given the x, type, and gamma, return the
% value of f, first and second gradient of phi function. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch method
    case 'cubic'
        f = x^3;
    case 'multiquadric1'
        f = (gamma^2 + x^2)^1.5;
    case 'multiquadric2'
        f = -sqrt(x^2 + gamma^2);
    case 'invmultiquadric'
        f = 1/sqrt(x^2 + gamma^2);
    case 'Gaussian'
        f = exp(-(x/gamma)^2);
    otherwise
        disp('Error: Unknown type.');
        return;
end

if nargout>1
    switch method
        case 'cubic'
            g = 3*x^2;
        case 'multiquadric1'
            g = 3*x*sqrt(x^2 + gamma^2);
        case 'multiquadric2'
            g = -x/sqrt(x^2 + gamma^2);
        case 'invmultiquadric'
            g = -x/(gamma^2 + x^2)^1.5;
        case 'Gaussian'
            g = -(2*x/gamma^2)*exp(-(x/gamma)^2);
    end
end

if nargout>2
    switch method
        case 'cubic'
            H = 6*x;
        case 'multiquadric1'
            H = 3*sqrt(x^2 + gamma^2) + 3*x^2/sqrt(x^2 + gamma^2);
        case 'multiquadric2'
            H = -1/sqrt(x^2 + gamma^2) + x^2/((x^2 + gamma^2)^1.5);
        case 'invmultiquadric'
            H = -1/(gamma^2 + x^2)^1.5 + 3*x^2/(x^2 + gamma^2)^2.5;
        case 'Gaussian'
            H = (4*x^2*(gamma^-4) - 2/gamma^2)*exp(-(x/gamma)^2);
    end
end