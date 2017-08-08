%multiprocessing_setup()
varargin = py.Matlabmod.matlabmode(-1);
myfun = @matlab_utility;
hessian = NumHessian(myfun,xmin2,varargin);
save('hessian')
% mod_h = zeros(63,63);
% for row = 1:63
%     for col = 1:63
%         if abs(hessian(row,col)) > 1e-3
%             mod_h(row,col) = hessian(row,col);
%         end
%     end
% end

            