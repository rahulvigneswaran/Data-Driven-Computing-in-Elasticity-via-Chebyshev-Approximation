clc
clear all;
close all;
for nx =2:2
    for ny = 1:1
        clc
%         clear all;
        close all;
        %
        global params truss_data samples num f
        %
        num.iLoad = 12;
        params.alpha = 8.000e+06;
        Flag.entropy = 0;
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Some parameters
        % --->
        params.cs = 20;
%         nx = 5;
%         ny = 3;
        
        %
        load('sample_data.mat');
        samples.eps = list_of_noisy_x;
        samples.sig = list_of_noisy_f;
        num.samples  = length(list_of_noisy_x);
        
        % r = linspace(min(x),max(x),100);
        % y1 = f(r);
        % figure;plot(r,y1)
        x2 = samples.eps';
        y = samples.sig';
%         f1 = polyfit(x2,y,15,domain(min(x2),max(x2)));
%         f.s = f1;
        [xData, yData] = prepareCurveData( x2, y );
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANGE THE DEGREE OF POLYNOMIAL HERE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ft = fittype( 'poly5' );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [fitresult, gof] = fit( xData, yData, ft );
        f.s = fitresult ;
        clear list_of_noisy_x list_of_noisy_f
        
        ns = num.samples;
        params.c_value = mean(samples.sig ./ samples.eps);
        % <---
        % Some parameters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Data of the structure
        % --->
        [dll,matH,coord_x,ir,irr,ird] = member(nx,ny);
        %
        nd = size(matH,1);    num.degree = nd;
        nm = size(matH,2);    num.member = nm;
        %
        % dummy = draw_cs(coord_x,irr,ones(nm,1));
        % <---
        % Data of the structure
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Load vector
        % --->
        vec_fD = sparse(nd,1);
        vec_fR = sparse(nd,1);
        vec_fR(2*(nx-1)) = -4.0;
        vec_fR(2*nx)     = -4.0;
        %
        load_factor.cur = 0;
        load_factor.inc = 1.0;
        % <---
        % Load vector
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % B-matrix (strain--displacement)
        % G-matrix (force--stress)
        % --->
        matB = sparse( diag(1 ./ dll) ) * matH';
        matG = matH * diag(params.cs);
        vec_vol = params.cs * dll;
        %
        truss_data.matB = matB;
        truss_data.matG = matG;
        truss_data.vol  = vec_vol;
        % <---
        % B-matrix (strain--displacement)
        % G-matrix (force--stress)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Call equilibrium analysis
        % --->
        his.u   = cell(1, num.iLoad);
        his.eps = cell(1, num.iLoad);
        his.sig = cell(1, num.iLoad);
        his.load_factor = zeros(1, num.iLoad);
        x = zeros(nd+nm+nm,1);
        
        for iLoad = 1:num.iLoad
            vec_f = vec_fD + (load_factor.cur * vec_fR);
            truss_data.vec_f = vec_f;
            %%%% vec_x = [vec_u; vec_eps; vec_sig];
            options = optimoptions('fsolve','Display','off','MaxIter',200);
            %
            tic;
            [x,fval,exitflag,output] = fsolve(@comp_residual, x, options);
            elapsed_time = toc;
            time(iLoad)= elapsed_time ;
            iters(iLoad)= output.iterations ; 
            time = time';
            iters = iters' ;
            %
            fprintf(' iLoad %g: residual=%1.3e time=%3.1f s iter=%g exit=%g \n',...
                iLoad, norm(fval), elapsed_time, output.iterations, exitflag);
            vec_u   = x(1:nd);
            vec_eps = x((nd+1):(nd+nm));
            vec_sig = x((nd+nm+1):end);
            %%%% Save results
            his.u{iLoad}   = vec_u;
            his.eps{iLoad} = vec_eps;
            his.sig{iLoad} = vec_sig;
            his.load_factor(iLoad) = load_factor.cur;
            %
            load_factor.cur = load_factor.cur + load_factor.inc;
        end
        % <---
        % Call equilibrium analysis
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Figures
        % --->
        plot(samples.eps, samples.sig, 'ko',...
            'MarkerFaceColor','w', 'MarkerSize',3)
        hold on;
        set(gca,'FontName','Times');
        set(gca,'FontSize',14);
        xlabel('Strain (m/m)', 'Interpreter', 'latex');
        ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
        print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_data_set'), '-dpng')
        
        
        
        figure;
        idx.member_idx = 1;
        regress_eps = (min(samples.eps):(3*10^(-5)):max(samples.eps));
        nss = length(regress_eps);
        regress_sig = zeros(ns,1);
        
        for i=1:nss
%               S = f.s(regress_eps(i));
%                 S = NN_5(regress_eps(i));
                S = f.s(regress_eps(i));
%             numer = 0;
%             denom = 0;
%             for j=1:ns
%                 numer = numer +...
%                     exp( -params.alpha * ((regress_eps(i) - samples.eps(j))^2) ) * samples.sig(j);
%                 denom = denom +...
%                     exp( -params.alpha * ((regress_eps(i) - samples.eps(j))^2) );
%             end
%             regress_sig(i) = numer / denom;
              regress_sig(i) = S;
        end
        plot(samples.eps, samples.sig, 'ko',...
            'MarkerFaceColor','w', 'MarkerSize',3);
        hold on;
        plot(regress_eps, regress_sig, 'g-');
        for iLoad=1:num.iLoad
            plot(his.eps{iLoad}(idx.member_idx), his.sig{iLoad}(idx.member_idx), 'b^', 'MarkerSize',10);
            %     plot(his.eps{iLoad}, his.sig{iLoad}, 'b^', 'MarkerSize',10);
        end
        set(gca,'FontName','Times');
        set(gca,'FontSize',14);
        xlabel('Strain (m/m)', 'Interpreter', 'latex');
        ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
        print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_strain_stress',num2str(idx.member_idx)), '-dpng')
        
        
        
        
        figure;
        idx.member_idx = 3;
        plot(samples.eps, samples.sig, 'ko',...
            'MarkerFaceColor','w', 'MarkerSize',3);
        hold on;
        plot(regress_eps, regress_sig, 'g-');
        for iLoad=1:num.iLoad
            plot(his.eps{iLoad}(idx.member_idx), his.sig{iLoad}(idx.member_idx), 'b^', 'MarkerSize',10);
        end
        set(gca,'FontName','Times');
        set(gca,'FontSize',14);
        xlabel('Strain (m/m)', 'Interpreter', 'latex');
        ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
        print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_strain_stress',num2str(idx.member_idx)), '-dpng')
        
        
        
        
        for iLoad = 1:num.iLoad
            opt_eps = his.eps{iLoad};
            opt_sig = his.sig{iLoad};
            figure;
            plot(samples.eps, samples.sig, 'ko',...
                'MarkerFaceColor','w', 'MarkerSize',3)
            hold on;
            plot(opt_eps, opt_sig, 'b^', 'MarkerSize',10)
            set(gca,'FontName','Times');
            set(gca,'FontSize',14);
            xlabel('Strain (m/m)', 'Interpreter', 'latex');
            ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
            print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_load_',num2str(iLoad)), '-dpng')
        end
        
        
        
        
        figure;
        for iLoad = 1:num.iLoad
            his_u(iLoad) = his.u{iLoad}(2*nx);
        end
        plot(10^(-2)*his_u, his.load_factor, 'bs-',...
            'LineWidth',2, 'MarkerSize',3);
        hold on
        set(gca,'FontName','Times');
        set(gca,'FontSize',14);
        xlabel('Displacement (m)', 'Interpreter', 'latex');
        ylabel('Load multiplier', 'Interpreter', 'latex');
        print(gcf,strcat(num2str(nx),'_',num2str(ny),'_ten_bar_equilibrium_path'), '-dpng')
        % <---
        % Figures
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Max-entropy in literature
        % --->
        if Flag.entropy == 1
            params.beta = 1*10^(1);
            
            load_factor.cur = 0.0;
            ent_his.u   = cell(1, num.iLoad);
            ent_his.eps = cell(1, num.iLoad);
            ent_his.sig = cell(1, num.iLoad);
            
            entropy_x0 = zeros(nd+nm+nm,1);
            for iLoad = 1:num.iLoad
                vec_f = vec_fD + (load_factor.cur * vec_fR);
                options = optimoptions('fmincon',...
                    'Display','iter', 'TolX', 10^(-20));
                
                Aeq = [10^(3)*matB, -speye(nm), 10^(3)*sparse(nm,nm);...
                    sparse(nd,nd), sparse(nd,nm), matG];
                beq = [sparse(nm,1); vec_f];
                
                entropy_x = entropy_x0;
                [entropy_x, entropy_f, entropy_exitflag, entropy_output] =...
                    fmincon(@obj_fun_entropy, entropy_x, [],[], Aeq,beq,...
                    [],[],[], options);
                
                ent_his.u{iLoad}   = entropy_x(1:nd);
                ent_his.eps{iLoad} = entropy_x((nd+1):(nd+nm));
                ent_his.sig{iLoad} = entropy_x((nd+nm+1):end);
                
                load_factor.cur = load_factor.cur + load_factor.inc;
                if iLoad == 1
                    entropy_x0 = entropy_x;
                end
            end
            
            figure;
            idx.member_idx = 1;
            plot(samples.eps, samples.sig, 'ko',...
                'MarkerFaceColor','w', 'MarkerSize',3);
            hold on;
            for iLoad=1:num.iLoad
                plot(ent_his.eps{iLoad}(idx.member_idx), ent_his.sig{iLoad}(idx.member_idx), 'rv', 'MarkerSize',10);
                %        plot(ent_his.eps{iLoad}, ent_his.sig{iLoad}, 'rv', 'MarkerSize',10);
            end
            set(gca,'FontName','Times');
            set(gca,'FontSize',14);
            xlabel('Strain (m/m)', 'Interpreter', 'latex');
            ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
            print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_entropy_strain_stress',num2str(idx.member_idx)), '-dpng')
            
            
            for iLoad = 1:num.iLoad
                opt_eps = ent_his.eps{iLoad};
                opt_sig = ent_his.sig{iLoad};
                figure;
                plot(samples.eps, samples.sig, 'ko',...
                    'MarkerFaceColor','w', 'MarkerSize',3)
                hold on;
                plot(opt_eps, opt_sig, 'b^', 'MarkerSize',10)
                set(gca,'FontName','Times');
                set(gca,'FontSize',14);
                xlabel('Strain (m/m)', 'Interpreter', 'latex');
                ylabel('Stress ($10^{6}$ Pa)', 'Interpreter', 'latex');
                print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_entropy_load_',num2str(iLoad)), '-dpng')
            end
            
            figure;
            for iLoad = 1:num.iLoad
                ent_his_u(iLoad) = ent_his.u{iLoad}(1);
            end
            plot(10^(-2) * ent_his_u, his.load_factor, 'bs-',...
                'LineWidth',2, 'MarkerSize',3);
            hold on
            set(gca,'FontName','Times');
            set(gca,'FontSize',14);
            xlabel('Displacement (m)', 'Interpreter', 'latex');
            ylabel('Load multiplier', 'Interpreter', 'latex');
            print(gcf, strcat(num2str(nx),'_',num2str(ny),'_ten_bar_entropy_equilibrium_path'), '-dpng')
        end
        % <---
        % Max-entropy in literature
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        result = [time iters];
        params
        num
        save('result','result');
    end
end
