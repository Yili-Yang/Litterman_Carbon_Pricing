clear all; clc; close all;
startup;

x1 = 0;
x2 = 10;

l1 = 0;
l2 = 1;

k1 = 5;
delta = 0.3;
esp = 0.2;

%% 1d =====================================================================

figure;
subplot(2,2,1);
x = linspace(x1, x2, 10000);
for i = 1:length(x)
    [y(i), g(i)] = fcostsmooth(x(i), k1, l1, l2, 0, 0);
end
plot(x, y, x, g);
axis([x1-1 x2+1 l1-1 l2+1]);
title('1d original cost function');

subplot(2,2,2);
x = linspace(x1, x2, 10000);
for i = 1:length(x)
    [y(i), g(i)] = fcostsmooth(x(i), k1, l1, l2, delta, 0);
end
plot(x, y, x, g);
axis([x1-1 x2+1 l1-1 l2+1]);
title('add slope');

subplot(2,2,3);
x = linspace(x1, x2, 10000);
for i = 1:length(x)
    [y(i), g(i)] = fcostsmooth(x(i), k1, l1, l2, delta, esp);
end
plot(x, y, x, g);
axis([x1-1 x2+1 l1-1 l2+1]);
title('add smooth');

% subplot(2,2,4);
% x = linspace(x1, x2, 10000);
% y = x;
% for i = 1:length(x)
%     [y(i), ~] = fcostgrad(x(i));
% end
% plot(x, y);
% title('vector function');

%% 2d =====================================================================

% figure;
% subplot(2,2,1);
% [x,y] = meshgrid(x1:0.1:x2, x1:0.1:x2);
% z = fcostsmooth(x, k1, l1, l2, 0, 0)+fcostsmooth(y, k1, l1, l2, 0, 0);
% size_z = size(z)
% mesh(x, y, z);
% title('2d original cost function');
% 
% subplot(2,2,2);
% [x,y] = meshgrid(x1:0.1:x2, x1:0.1:x2);
% z = fcostsmooth(x, k1, l1, l2, delta, 0)+fcostsmooth(y, k1, l1, l2, delta, 0);
% mesh(x, y, z);
% title('add slope');
% 
% subplot(2,2,3);
% [x,y] = meshgrid(x1:0.1:x2, x1:0.1:x2);
% z = fcostsmooth(x, k1, l1, l2, delta, esp)+fcostsmooth(y, k1, l1, l2, delta, esp);
% mesh(x, y, z);
% title('add smooth');