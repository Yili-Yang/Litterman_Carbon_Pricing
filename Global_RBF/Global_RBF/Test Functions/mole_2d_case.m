function DM = mole_2d_case (n)
% to generate DM for special cases
%nn=length(xx);
% x(1)=3;
% y(1)=3;
% x(2)=1;
% y(2)=3;
% x(3)=1;
% y(3)=1;
% x(4)=3;
% y(4)=1;
nn=2*n;
xx=[1:nn]*3;
x= xx(1:n); y = xx(n+1:nn);
% v = rand(n,1);
% w = rand(n,1);
% x = ones(n,1) +n*v;
% y = ones(n,1) + n*w;
% x(1) = 0; y(1) = 0;
% x(2) = 1; y(2) = 1;
DM=zeros(n);
if n==2
    x= [2,5]; y =[3 -1];
    DM(1,2)= sqrt((x(1)-x(2))^2 + (y(1)-y(2))^2);
    DM(2,1) = DM(1,2);
elseif n==3
    x=[1,3,2];
    y=[1,1,2];
    DM(1,2)=sqrt((x(1)-x(2))^2 + (y(1)-y(2))^2);
    DM(1,3)=sqrt((x(1)-x(3))^2 + (y(1)-y(3))^2);
    DM(2,3)=sqrt((x(2)-x(3))^2 + (y(2)-y(3))^2);
     DM(2,1)= DM(1,2);
     DM(3,1)= DM(1,3);
     DM(3,2)= DM(2,3);
elseif n==4
    x=[4,2,1,3];
    y=[3,3,1,1];
    for i=1:n
        if i < n
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
    end
    DM(4,1)=sqrt((x(1)-x(4))^2 + (y(1)-y(4))^2);
    DM(1,4)=DM(4,1);
elseif n==6
    x=[2.5,2,1,0.5,4,3];
    y=[2.8,2,1,0.6,-1,1];
    for i=1:3
        if i < n
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
    end
    DM(5,6)=sqrt((x(5)-x(6))^2 + (y(5)-y(6))^2);
    DM(2,6)=sqrt((x(2)-x(6))^2 + (y(2)-y(6))^2);
    DM(3,6)=sqrt((x(3)-x(6))^2 + (y(3)-y(6))^2);
    DM(6,5)= DM(5,6);
    DM(6,2)= DM(2,6);
    DM(6,3)= DM(3,6);
    elseif n==8
%        x=[1,3,2,3,1,6,8,7];
%        y=[5,5,2,1,1,2,2,4];
        x=[-1,3,1,2,0,3,6,5];
         y=[4,5,3,1,0,1.5,2,3];
        for i=1:2
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
        DM(1,3)=sqrt((x(1)-x(3))^2 + (y(1)-y(3))^2);
        DM(3,1)= DM(1,3);
        
        for i=3:4
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
        DM(5,3)=sqrt((x(5)-x(3))^2 + (y(5)-y(3))^2);
        DM(3,5)= DM(5,3);
        
       
       for i=6:7
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
       end
        DM(6,8)=sqrt((x(6)-x(8))^2 + (y(6)-y(8))^2);
        DM(8,6)= DM(6,8);
   elseif n==16
%        x=[1,3,2,3,1,6,8,7];
%        y=[5,5,2,1,1,2,2,4];
         x=[-1,3,1,2,0,3,6,5,1,3,2,3,1,6,8,7];
         y=[4,5,3,1,0,1.5,2,3,5,5,2,1,1,2,2,4];
        for i=1:2
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
        DM(1,3)=sqrt((x(1)-x(3))^2 + (y(1)-y(3))^2);
        DM(3,1)= DM(1,3);
        
        for i=3:4
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
        DM(5,3)=sqrt((x(5)-x(3))^2 + (y(5)-y(3))^2);
        DM(3,5)= DM(5,3);
       for i=6:7
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
       end
        DM(6,8)=sqrt((x(6)-x(8))^2 + (y(6)-y(8))^2);
        DM(8,6)= DM(6,8);
        %%%%%%%%%%%%%
        for i=9:10
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
        DM(9,11)=sqrt((x(9)-x(11))^2 + (y(9)-y(11))^2);
        DM(11,9)= DM(9,11);
        
        for i=11:12
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
        end
        DM(13,11)=sqrt((x(13)-x(11))^2 + (y(13)-y(11))^2);
        DM(11,13)= DM(13,11);
       for i=14:15
            DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
            DM(i+1,i) = DM(i,i+1);
       end
        DM(14,16)=sqrt((x(14)-x(16))^2 + (y(14)-y(16))^2);
        DM(16,14)= DM(14,16);
        
        
        
        
    
end