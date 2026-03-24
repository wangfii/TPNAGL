clear;
clc;
warning off;
% n*d
addpath('../../');
addpath('../../datasets');
addpath('../../funs/');
addpath('../../measure\');

%% dataset
Dataname = 'MSRC_v1';


load('MSRC_v1.mat');

X = fea;
Y = gt;





k = length(unique(Y));
n = length(Y);


MaxAcc = 0;
R = [];
para = [];
r = [];


lam = [0.0001 0.001 0.01 0.1 1 10];

gam = [0.0001 0.001 0.01 0.1 1 10];
alp = [0.0001 0.001 0.01 0.1 1 10];
par_c_values = [0.8,1,1.2,1.5,1.8];

anchor = 1*k;

iter = 1;

%%
allresult = [];
for ichor = anchor
    for par_c = par_c_values
    
        % 设置核参数
        for v = 1:length(X)
            ker{v}.type = 'rbf';
            ker{v}.par = [];
            ker{v}.par_c = par_c;  % 使用当前循环的par_c值
        end

        tic;
        for v = 1:length(X)
            if strcmp(ker{v}.type,'rbf') && isempty(ker{v}.par)
                Xs = X{v}';  % 当前视图的数据
                XX = sum(Xs.*Xs,1);
                dist = repmat(XX,size(Xs,2),1) + repmat(XX',1,size(Xs,2)) - 2*Xs'*Xs;
                
                if isempty(ker{v}.par_c)
                    ker{v}.par_c = 1;
                end
        
            ker{v}.par = (mean(real(dist(:).^0.5)) * ker{v}.par_c)^2; % sigma^2
            end
        end
        time2 = toc;


        for lambda = lam
            for gamma = gam
                for alpha = alp

                    runtime = [];
                    tic;
                    [U,k] = process(X,Y,ichor,lambda,gamma,alpha,ker);
                    runtime = [runtime,toc];

                    for iv = 1:10
                        labels=litekmeans(U, k, 'MaxIter', 100,'Replicates',10);                        
                        res(iv,:)=  Clustering8Measure(Y, labels);
                    end
                
                    resm = mean(res)*100;
                    stdm = std(res)*100;
                    retime = mean(runtime);
            
                    R = [R;resm,stdm];
                    para = [para;ichor,par_c,lambda,gamma,alpha,retime];

                    
                        S = U*U';
                        mappedX  = tsne(S,'Algorithm','barneshut','Distance','cosine');
                        gscatter(mappedX(:,1),mappedX(:,2), gt );
                        legend('off');
                        % 
                        figure(iter); 
                        
                        iter = iter+1;
                    
                    if (MaxAcc < resm(1))
                        MaxAcc = resm(1);
                    end
            
                    fprintf("anchor = %f par_c %.1f lambda = %f gamma = %f alpha = %f ACC = %f MaxACC = %f time = %f\n", ichor,par_c,lambda,gamma,alpha, resm(1),MaxAcc,retime);
            
                        
                    % r = [para,R];
                    % 
                    % 
                    % % 鍒涘缓涓?涓枃浠跺す鐢ㄤ簬瀛樺偍缁撴灉
                    % folder_path = '../res_test_opt1_11';
                    % if ~exist(folder_path, 'dir')
                    %     mkdir(folder_path);
                    % end
                    % 
                    % % 鍒涘缓浠atabname涓哄悕鐨勫瓙鏂囦欢澶?
                    % subfolder_name = Dataname; % 鍋囪databname鏄竴涓彉閲忥紝鍖呭惈浣犳兂瑕佸垱寤虹殑瀛愭枃浠跺す鐨勫悕绉?
                    % subfolder_path = fullfile(folder_path, subfolder_name);
                    % if ~exist(subfolder_path, 'dir')
                    %     mkdir(subfolder_path);
                    % end
                    % 
                    % % 鍒涘缓鏂囦欢鍚嶏紝淇濆瓨鏁扮粍
                    % file_name = sprintf('%s_%dk.mat', Dataname,ichor/k);
                    % file_path = fullfile(subfolder_path, file_name);
                    % % 淇濆瓨鏁扮粍鍒? .mat 鏂囦欢
                    % save(file_path, 'r');

            end
        end
    end
end
end



