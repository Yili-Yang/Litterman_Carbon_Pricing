  function[group] = color(A,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [group] = color(A,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color the Adjacency(symmetric) graph of with
% the structure of A. group(i) = j means
% vertex i is colored j. ncol colors are used.
%
% All vertices belonging to a color can
% be estimated in a single finite difference.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [m,n] = size(A);
  if nargin < 2, p = 1:1:n; p = p'; end
  A = A(p,p);
  group = zeros(n,1);
  marked = zeros(n,1);
  	k=2;	
	group(1)=1;
	for j=2:n 
		adj=find(A(:,j));
		siz=length(adj);
		for l=1:siz
			if(group(adj(l))>0)
			marked(group(adj(l)))=1;
			end
		end
		[y,i]=min(marked(1:siz));
		if (siz==0)
			group(j)=1;
		else
		if (marked(i) > 0 )	
			group(j)=siz+1;
		else
			group(j)=i;
		end
		end
		for l=1:siz
			if(group(adj(l))>0)
			marked(group(adj(l)))=0;
			end
		end
	end
	group(p)=group;
