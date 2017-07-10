global currfun;
global warningon;
global globp;
global tape;
global varcounter;
global fdeps;
global ADhess;
global wparm;
global funtens;
global tape_begin;
% initial flags
global LUflag;
global backflag;
global QRflag;
global SVDflag;

LUflag = 0;
backflag = 0;
QRflag = 0;
SVDflag = 0;

%
% EULA check
try
    fidin = fopen('EULA.txt', 'r');
    tline = fgetl(fidin);
    if strcmp(tline, '0')
        while ~feof(fidin)
            text = fgetl(fidin);
            fprintf('%s\n\n', text);
        end
        fclose(fidin);
        t = 1;
        while t == 1
            a = input('Have you read and accepted the End-User License Agreement? [Y/N]', 's');
            if strcmp(a, 'Y') || strcmp(a,'y')
                fidin = fopen('EULA.txt', 'r+');
                fwrite(fidin, '1');
                fclose(fidin);
                t = 0;
            elseif strcmp(a, 'N') || strcmp(a,'n')
                fprintf('Installation of ADMAT-2.0 failed! Please contact Cayuga research for help!\n');
                t = 0;
                clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
                return;
            else
                fprintf('Illegal input. Please try agian.\n\n');
            end
        end
    elseif ~strcmp(tline, '1')
        fprintf('Errors on End-User License Agreement file. Please contact Cayuga Researh for the new agreement file!\n');
        fclose(fidin);
        return;
    else
        fclose(fidin);
    end  
    fprintf('ADMAT 2.0 installed successfully!\n');
catch
        fprintf('Errors on End-User License Agreement file. Please contact Cayuga Researh for the new agreement file!\n');
        clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
        return;
end

% try
%     [y, correct] = licence(12300321);
%     if y<=0 || correct ~= 10000
%         fprintf('The licence of ADMAT 2.0 expires. Please contact Cayuga Research for licence extension.\n');
%         clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%         clear
%         return;
%     end    
%     Lflag = 1;
%     fprintf('ADMAT 2.0 installed successfully!\n');
% catch
%     fprintf('ADMAT 2.0 licence is not found. Please contact Cayuga Research for licence file or remove ADMAT 2.0.\n');
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     return;
%     clear
% end

% initialize global variables
ADhess=0;
warningon=0;
fdeps=1e-6;
globp=1;
%tape = cell(1000);
tape_begin = 1;
varcounter=1;
currfun=ADfun;

clear 




