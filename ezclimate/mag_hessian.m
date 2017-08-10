magnitude_m = [];
for i =1:8
    start_i = int16((i-1)*63)+1;
    end_i = int16(i*63);
    result_h = hessian_m(start_i:end_i,:);
    e = eig(result_h);
    re_e = e(e<0);
    magnitude_m = [magnitude_m;norm(re_e)];
end