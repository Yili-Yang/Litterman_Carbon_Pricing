function err=plot2d_case(n,xmatrix,xst)

% [TABLE1,xmatrix,xst] = run_global_RBF_TRM(20,20,1,0);

nn=2*n;
err=1;

x0=xst(1:n);y0=xst(n+1:nn);
x1=xmatrix(1:n,2);y1=xmatrix(n+1:nn,2);
x2=xmatrix(1:n,2);y2=xmatrix(n+1:nn,2);
if n==2
    x= [2,5]; y =[3 -1];
    plot(x,y,'b-*',x0,y0,'b:o',x1,y1,'b--s',x2,y2,'b-.v');
    err(1)=(x(2)-x(1))^2+(y(2)-y(1))^2;
    err(1)=sqrt(err(1));
    err(2)=(x0(2)-x0(1))^2+(y0(2)-y0(1))^2;
    err(2)=sqrt(err(2));
    err(3)=(x1(2)-x1(1))^2+(y1(2)-y1(1))^2;
    err(3)=sqrt(err(3));
    err(4)=(x2(2)-x2(1))^2+(y2(2)-y2(1))^2;
    err(4)=sqrt(err(4));
    string1=strcat('gen DM, dist=',num2str(err(1)));
    string2=strcat('start ve, dist=',num2str(err(2)));
    string3=strcat('phase1, dist=',num2str(err(3)));
    string4=strcat('phase2, dist=',num2str(err(4)));
    legend(string1,string2,string3,string4);
    title('2-D molecule, dim=2');
elseif  n==3
    x=[1,3,2];
    y=[1,1,2];
     plot(x,y,'b*',x0,y0,'bo',x1,y1,'bs',x2,y2,'bv');
   
     DM = mole_2d_case (n);
     for i=1:n
         for j=1:i
             if DM(i,j)~=0
                 hold on 
                 plot([x(i),x(j)],[y(i),y(j)],'b-',[x0(i),x0(j)],[y0(i),y0(j)],'b:',...
                     [x1(i),x1(j)],[y1(i),y1(j)],'b--',[x2(i),x2(j)],[y2(i),y2(j)],'b-.');
             end
         end
     end
     %       legend('gen DM','start ve','phase1','phase2');
     title('2-D molecule, dim=3');
elseif  n==4
    x=[4,2,1,3];
    y=[3,3,1,1];
    plot(x,y,'b*',x0,y0,'bo',x1,y1,'bs',x2,y2,'bv');
    
    DM = mole_2d_case (n);
    for i=1:n
        for j=1:i
            if DM(i,j)~=0
                hold on
                plot([x(i),x(j)],[y(i),y(j)],'b-',[x0(i),x0(j)],[y0(i),y0(j)],'b:',...
                    [x1(i),x1(j)],[y1(i),y1(j)],'b--',[x2(i),x2(j)],[y2(i),y2(j)],'b-.');
            end
        end
    end
    %       legend('gen DM','start ve','phase1','phase2');
    title('2-D molecule, dim=4');
elseif  n==6
    x=[2.5,2,1,0.5,4,3];
    y=[2.8,2,1,0.6,-1,1];
    plot(x,y,'b*',x0,y0,'bo',x1,y1,'bs',x2,y2,'bv');
    
    DM = mole_2d_case (n);
    for i=1:n
        for j=1:i
            if DM(i,j)~=0
                hold on
                plot([x(i),x(j)],[y(i),y(j)],'b-',[x0(i),x0(j)],[y0(i),y0(j)],'b:',...
                    [x1(i),x1(j)],[y1(i),y1(j)],'b--',[x2(i),x2(j)],[y2(i),y2(j)],'b-.');
            end
        end
    end
    %       legend('gen DM','start ve','phase1','phase2');
    title('2-D molecule, dim=6');
elseif  n==8
%     x=[1,3,2,3,1,6,8,7];
%     y=[5,5,2,1,1,2,2,4];
    x=[-1,3,1,2,0,3,6,5];
    y=[4,5,3,1,0,1.5,2,3];
    plot(x,y,'b*',x0,y0,'bo',x1,y1,'bs',x2,y2,'bv');
    %     plot(x,y,'b*',x0,y0,'bo');
    
    DM = mole_2d_case (n);
    for i=1:n
        for j=1:i
            if DM(i,j)~=0
                hold on
                plot([x(i),x(j)],[y(i),y(j)],'b-',[x0(i),x0(j)],[y0(i),y0(j)],'b:',...
                    [x1(i),x1(j)],[y1(i),y1(j)],'b--',[x2(i),x2(j)],[y2(i),y2(j)],'b-.');
            end
        end
    end
    %       legend('gen DM','start ve','phase1','phase2');
    title('2-D molecule, dim=8');
     figure(2)
    plot(x,y,'b*',x2,y2,'bv');
    for i=1:n
        for j=1:i
            if DM(i,j)~=0
                hold on
                plot([x(i),x(j)],[y(i),y(j)],'b-',[x2(i),x2(j)],[y2(i),y2(j)],'b-.');
            end
        end
    end
    
elseif  n==16
    
    x=[-1,3,1,2,0,3,6,5,1,3,2,3,1,6,8,7];
    y=[4,5,3,1,0,1.5,2,3,5,5,2,1,1,2,2,4];
    plot(x,y,'b*',x0,y0,'bo',x1,y1,'bs',x2,y2,'bv');
    DM = mole_2d_case (n);
    for i=1:n
        for j=1:i
            if DM(i,j)~=0
                hold on
                plot([x(i),x(j)],[y(i),y(j)],'b-',[x0(i),x0(j)],[y0(i),y0(j)],'b:',...
                    [x1(i),x1(j)],[y1(i),y1(j)],'b--',[x2(i),x2(j)],[y2(i),y2(j)],'b-.');
            end
        end
    end
end
