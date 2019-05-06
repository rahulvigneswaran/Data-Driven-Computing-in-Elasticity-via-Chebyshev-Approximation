
clear;
close all;
%====================================================================================================
%  Loading the x(Strain) and f(stress) data into eps and sig and clearing it off the memory
%====================================================================================================
load('sample_data.mat');
samples.eps = list_of_noisy_x;
samples.sig = list_of_noisy_f;
num.sample  = length(list_of_noisy_x);
ns = num.sample;
clear list_of_noisy_x list_of_noisy_f
%====================================================================================================

trial_value = (10^6:10^6:10^8);

omit_num = 8;
%====================================================================================================
% Starting Stopwatch timer
%====================================================================================================
tic;
%====================================================================================================

his_error = cell(1, length(trial_value) );
for jj = 1:length(trial_value)
    params.alpha = trial_value(jj);
    for i = (omit_num+1):(num.sample-omit_num)
        target_x = samples.eps(i);
        cur_set.eps = setdiff(samples.eps, samples.eps(i));
        cur_set.sig = setdiff(samples.sig, samples.sig(i));
        denom = 0;
        numer = 0;
        for j=1:(ns-1)
            denom = denom +...
                exp( -params.alpha * ((target_x - cur_set.eps(j))^2) );
            numer = numer +...
                exp( -params.alpha * ((target_x - cur_set.eps(j))^2) ) * cur_set.sig(j);
        end
        regressed_stress = numer / denom;
        cur_error = (regressed_stress - samples.sig(i))^2;
        his_error{jj} = [his_error{jj}, cur_error];
    end
end
elapsed_time = toc;
fprintf(' Total time=%3.1f s\n',...
    elapsed_time);


for jj = 1:length(trial_value)
    total_error(jj) = sum(his_error{jj});
    max_error(jj)   = max(his_error{jj});
end

[~, idx.total_error] = sort(total_error);
[~, idx.max_error]   = sort(max_error);

delete cross_validation.dat.dat;
fid = fopen('cross_validation.dat', 'w');
fprintf(' ==== sum of error === \n');
fprintf(fid, ' ==== sum of error === \n');
for j=1:10
    fprintf(' alpha = %1.3e:  error = %1.6e \n',...
        trial_value(idx.total_error(j)), total_error(idx.total_error(j)));
    fprintf(fid, ' alpha = %1.3e:  error = %1.6e \n',...
        trial_value(idx.total_error(j)), total_error(idx.total_error(j)));
end
fprintf(' ==== max of error === \n');
fprintf(fid, ' ==== max of error === \n');
for j=1:10
    fprintf(' alpha = %1.3e:  error = %1.6e \n',...
        trial_value(idx.max_error(j)), max_error(idx.max_error(j)));
    fprintf(fid, ' alpha = %1.3e:  error = %1.6e \n',...
        trial_value(idx.max_error(j)), max_error(idx.max_error(j)));
end
fclose(fid);

best_alpha = trial_value(idx.max_error(1));
regress_eps = (min(samples.eps):(3*10^(-5)):max(samples.eps));
nss = length(regress_eps);
regress_sig = zeros(ns,1);
for i=1:nss
    numer = 0;
    denom = 0;
    for j=1:ns
        numer = numer +...
            exp( -best_alpha * ((regress_eps(i) - samples.eps(j))^2) ) * samples.sig(j);
        denom = denom +...
            exp( -best_alpha * ((regress_eps(i) - samples.eps(j))^2) );
    end
    regress_sig(i) = numer / denom;
end
plot(samples.eps, samples.sig, 'ko',...
    'MarkerFaceColor','w', 'MarkerSize',3)
hold on;
set(gca,'FontName','Times');
set(gca,'FontSize',14);
plot(regress_eps, regress_sig, 'b-')
xlabel('Strain (m/m)', 'Interpreter', 'latex');
ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
