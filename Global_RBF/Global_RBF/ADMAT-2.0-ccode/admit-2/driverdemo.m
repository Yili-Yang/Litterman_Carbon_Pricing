N=10;
str = str2mat(' ',' ', ' ', ...
 '        First example function is a sample nonlinear vector function', ...
 '        examplefun.m. Here is the M-code for this function', ...
 '        ', ...
 '        First few steps in this demo deal with this function. ', ...
 '        Press next to continue ...');
ssdisp(figNumber,str);      
drawnow;
type examplefun;

% Delay a little more in the case of AutoPlay

if get(findobj(figNumber,'string','AutoPlay'),'value') pause(2) ; end ;

if sspause(figNumber), return; end;

str = str2mat (...
   '      1. forwprod : does J*V', ...
   ' ', ...
   '         V=ones(N,4); ', ...
   '         x=ones(N,1); ', ...
   '         [f,JV]=forwprod(''examplefun'',x,V); ', ...
   ' ', ...
   'Watch the Matlab command window for results', ...
   ' ');
   
ssdisp(figNumber,str);                                     
drawnow;

V=ones(N,4);
x=ones(N,1);
disp('Forward Mode Product :- JV=forwprod(x,V,N);');
V
[f,JV]=forwprod('examplefun',x,V);
JV

% Delay a little more in the case of AutoPlay
if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;

str = str2mat(' ', ...
   '      2. revprod : does W^T*J', ...
   ' ', ...
   '         W=ones(N,4); ', ...
   '         [f,WJ]=revprod(''examplefun'',x,W); ', ...
   ' ');
ssdisp(figNumber,str);      
drawnow;


W=ones(N,4);
disp('Reverse Mode Product :- WJ=revprod(x,W);');
W
[f,WJ]=revprod('examplefun',x,W);
WJ

% Delay a little more in the case of AutoPlay
if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;

str = str2mat(' ', ...
   '      3. jacsp : sparsity pattern of Jacobian', ...
   ' ', ...
   '         SPJ=jacsp(''examplefun'',N); ', ...
' ');
ssdisp(figNumber,str);
drawnow;


SPJ=jacsp('examplefun',N);
spy(SPJ);
title 'sparsity Pattern of J'
disp(' ');

if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;

str = str2mat(' ',' ', ' ', ...
 '        Second example function is the brown nonlinear scalar function', ...
 '        brown1.m. Here is the M-code for this function', ...
 '        ', ...
 '        Rest of the  demo deals with this function. ', ...
 '        Press next to continue ...');


 
ssdisp(figNumber,str);
drawnow ;

type brown1


 
% Delay a little more in the case of AutoPlay
if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;

str = str2mat(' ', ...
   '      4. hesssp : sparsity pattern of Hessian', ...
   ' ', ...
   '         SPH=hesssp(''brown1'',N); ', ...
' ');


ssdisp(figNumber,str);
drawnow ;

SPH=hesssp('brown1',N);
spy(SPH);
title 'sparsity Pattern of Hessian'
disp(' ');


% Delay a little more in the case of AutoPlay
if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;
str = str2mat(' ', ...
   '      5. funcval : gradient and function value:  ', ...
   ' ', ...
   '         [val,grad]=funcval(''brown1'',x); ', ...
   ' ');

ssdisp(figNumber,str);
drawnow ;

[val,grad]=funcval('brown1',x);
val
grad
disp(' ');

if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;


str = str2mat(' ', ...
   '      6. HtimesV :  Hessian Vector product  ', ...
   ' ', ...
   '         V=ones(N,4); ', ...
   '         HV=HtimesV(''brown1'',x,V); ', ...
    ' ');

ssdisp(figNumber,str);
drawnow ;

V
HV=HtimesV('brown1',x,V);
HV

if get(findobj(figNumber,'string','AutoPlay'),'value') pause(3) ; end ;
if sspause(figNumber), return; end;


