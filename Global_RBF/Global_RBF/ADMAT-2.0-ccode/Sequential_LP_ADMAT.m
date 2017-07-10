ea = [1;1;1]; ea = 1/norm(ea)*ea; phi = [pi/4,pi/6,0]'; % Principal axis and angle of rotation
sig0 = ea.*tan(phi); % initial MRP
w0 = zeros(3,1);
x0 = [sig0;w0];

con_c = [0;0;0];

myfun = ADfun('state_con_Jac');
state_con = [x0(:);con_c(:)];

[f, df] = feval(myfun, state_con);
Amat = df(:,1:length(x0));
Bmat = df(:,length(x0)+1:end);

