
function F = comp_residual(x)

global params truss_data samples f



matB = truss_data.matB;
matG = truss_data.matG;
vec_f = truss_data.vec_f;

nm = size(matB,1);
nd = size(matB,2);
ns = length(samples.eps);

%%%%% x = [vec_u; vec_e; vec_s];
vec_u = x(1:nd);
vec_e = x((nd+1):(nd+nm));
vec_s = x((nd+nm+1):end);

%%%%% Compatibility relation
res_compatibility = 10^(3) * ((matB * vec_u) - vec_e);

%%%%% Force-balance equation
res_force_balance = (matG * vec_s) - vec_f;

%%%%% Regression
res_regression = zeros(nm,1);
for i=1:nm
% S = f.s(vec_e(i));
%  S = NN_5(vec_e(i));
S = f.s(vec_e(i));

%     numer = 0;
%     denom = 0;
%     for j=1:ns
%         numer = numer +...
%             exp( -params.alpha * ((vec_e(i) - samples.eps(j))^2) ) * samples.sig(j);
%         denom = denom +...
%             exp( -params.alpha * ((vec_e(i) - samples.eps(j))^2) );
%     end
     res_regression(i) = S - vec_s(i);
%       res_regression(i) = (numer/denom) - vec_s(i);
end

%%%%% Assemblage
F = [res_compatibility; res_force_balance; 10^(1)*res_regression];



