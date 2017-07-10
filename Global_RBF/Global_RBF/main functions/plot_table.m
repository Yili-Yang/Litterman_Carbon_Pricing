function [TABLE1,Error] =plot_table(a,b)

problem=a;
probstop=b;
[TABLE1,xmatrix,xst] = run_global_RBF_TRM(problem,probstop,1,0);

%xst=[f_init,f_ph1,f_ph2,f2_value];
Error=zeros(probstop-problem+1,3);
Error(:,1)=(xst(:,2)-xst(:,1))./xst(:,1);
Error(:,2)=(xst(:,3)-xst(:,2))./xst(:,2);
Error(:,3)=(xst(:,4)-xst(:,1))./xst(:,1);

dm=[a:b];

plot(dm,Error(:,1),'b-.*',dm,Error(:,2),'k:o',dm,Error(:,3),'r-s');
legend('phase1','phase2','only-phase2');
title('Relative change of each phase');
xlabel('Problem No.');
ylabel('percentage');