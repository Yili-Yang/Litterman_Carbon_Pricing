function [y, correct] = licence(x)

UY = 2016;
UM = 11;
UD = 1;

try
    if (x == 12300321)
        correct = 10000;
    else
        correct = randn(1);
    end

    [Y,M,D] = datevec(date);

    if (Y > UY)
        y = -1;
    elseif (Y == UY) && (M > UM)
        y = -1;
    elseif (Y ==UY) && (M==UM) && (D>UD)
        y = -1;
    elseif correct == 10000
        y = 1;
    elseif correct ~= 10000
        fprintf('Licence Errors, please contact Cayuga research\n');
    end
catch
    if nargin == 0
        fprintf('ADMAT expires at %d/%d/%d.\n', UY, UM,UD);
    else
        fprintf('Licence file cannot run properly! Please contact Cayuga Research for licence file or remove ADMAT 2.0.\n');
        clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag
    end
    return;
end