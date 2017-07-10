function xdot = state_con_Jac(state_con, Extra);
xdot = zeros(6,1);

x = state_con(1:6);
tor = state_con(7:9);

sigma = x(1:3); sigma = sigma(:);
w = x(4:6); w = w(:);

sigt=[0 -sigma(3) sigma(2);...
      sigma(3) 0   -sigma(1);...
     -sigma(2) sigma(1) 0];

sigdot=0.25*((1-sigma'*sigma)*eye(3)+2*sigt+2*sigma*sigma')*w;
omegadot = tor;

xdot = [sigdot;omegadot];