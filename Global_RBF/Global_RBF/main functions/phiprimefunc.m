function [Out] = phiprimefunc(method,gamma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the phi'(x)/x when x is equal to 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch method
    case 'cubic'
        Out = 0;
    case 'multiquadric1'
        Out = 3*gamma;
    case 'multiquadric2'
        Out = -1/gamma;
    case 'invmultiquadric'
        Out = -1/gamma^3;
    case 'Gaussian'
        Out = -2/(gamma^2);
    otherwise
        disp('Error: Unknown type.');
        return;
end
