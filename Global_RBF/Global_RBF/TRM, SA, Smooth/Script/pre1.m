X =-5:0.1:5;
figure
myfun=@rast;
VAL = zeros(length(X),1);
for i=1:length(X)
    VAL(i) = myfun(X(i));
end
plot(X,VAL);
hold on

[f,g,H]=myfun(3.5);

X=3:0.05:4;
VAL = zeros(length(X),1);
for i=1:length(X)
    VAL(i) = f+g*(X(i)-3.5)+1/2*H*(X(i)-3.5)^2;
end
plot(X,VAL);

X =-5:0.1:5;
figure
myfun=@rast;
VAL = zeros(length(X),1);
for i=1:length(X)
    VAL(i) = myfun(X(i));
end
plot(X,VAL);
hold on

[f,g,H]=myfun(3);

X=2.5:0.05:3.5;
VAL = zeros(length(X),1);
for i=1:length(X)
    VAL(i) = f+g*(X(i)-3)+1/2*H*(X(i)-3)^2;
end
plot(X,VAL);