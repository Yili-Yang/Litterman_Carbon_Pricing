function [ DM,xmole,ymole,zmole,xx] = make_mole_3d (perc_nnz,natoms)
%create a 3-D molecule problem
%
v = rand(natoms,1);
w = rand(natoms,1);
u= rand(natoms,1);
x = ones(natoms,1) +natoms*v;
y = ones(natoms,1) + natoms*w;
z= ones(natoms,1) + natoms*u;
%x(1) = 0; y(1) = 0;
%x(2) = 1; y(2) = 1;
xmole=x;ymole = y;zmole = z;
xx= [x;y;z];
DM=sparse(natoms,natoms);
for i=1:natoms
    %if i < natoms
    %DM(i,i+1)= sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2+(z(i) -z(i+1))^2);
    % DM(i+1,i) = DM(i,i+1);
    %end
    for j=i+2:natoms
        r = rand;
        if r <= perc_nnz
            DM(i,j) = sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2 +(z(i)-z(j))^2);
            DM(j,i) = DM(i,j);
        end
    end
end



end
