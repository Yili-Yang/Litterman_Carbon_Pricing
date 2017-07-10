function [ DM,xxmole] = make_mole_pd (p,perc_nnz,natoms)
%create a p-D molecule problem
%

% generate random matrix
% each column is the position of each dimension
w=zeros(natoms,p);
for k=1:p
    w(:,k)=ones(natoms,1) +natoms*rand(natoms,1);
end
xxmole=reshape(w,natoms*p,1);
% generate distance matrix based on random posiron matrix
DM=sparse(natoms,natoms);
for i=1:natoms
    %     if i < natoms
    %         dw=sum((w(i,:)-w(i+1,:)).^2);
    %         DM(i,i+1)= sqrt(dw);
    %         DM(i+1,i) = DM(i,i+1);
    %     end
    for j=i+2:natoms
        r = rand;
        if r <= perc_nnz
            dw=sum((w(i,:)-w(j,:)).^2);
            DM(i,j) = sqrt(dw);
            DM(j,i) = DM(i,j);
        end
    end
end



end
