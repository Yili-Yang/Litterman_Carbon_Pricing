function [f,g,H]=new2dmole(w,varargin)
%varargin={DM,x0,Y};
% remove rotations
% test function based on w not x


if size(varargin,2)==1
    varargin=varargin{1};
end
DM=varargin{1};
x0= varargin{2};
Y=varargin{3};
if size(w,2)==1
    w=w';
end
[f,g2,H2]=molefd_1f2d(x0+(Y*w')',DM);
 g=Y'*g2;
 H=Y'*H2*Y;