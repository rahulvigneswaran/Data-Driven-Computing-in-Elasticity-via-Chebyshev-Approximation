% Copyright (C) Yoshihiro Kanno, 2018
function f = obj_fun_entropy(x)

global params truss_data samples

nm = size(truss_data.matB,1);
nd = size(truss_data.matB,2);
ns = length(samples.eps);
vec_vol = truss_data.vol;

%%%%% x = [vec_u; vec_e; vec_s];
vec_e = x((nd+1):(nd+nm));
vec_s = x((nd+nm+1):end);

power_num = zeros(ns,1);
for j=1:ns
    for i=1:nm
        power_num(j) = power_num(j) +...
            ( (params.c_value/2) * vec_vol'...
            * ( (vec_e - samples.eps(j)) .* (vec_e - samples.eps(j)) ) )...
            + ( (1/(2*params.c_value)) * vec_vol'...
            * ( (vec_s - samples.sig(j)) .* (vec_s - samples.sig(j)) ) );
    end
end

f = 0;
for j=1:ns
    f = f - exp(-(params.beta/2) * power_num(j));
end
