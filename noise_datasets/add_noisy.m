% ===================== 完整加噪+保存代码（保留原始数据集结构） =====================
% 1. 加载原始多视图数据（包含fea和gt）
addpath('./');
load('MSRC_v1.mat');  % 加载后工作区有 fea (1x5 cell) 和 gt (210x1 double)

% 2. 定义噪声配置（10%噪声=SNR=10dB，20%噪声=SNR≈7dB，可按需修改）
noise_config = [
    struct('view_idx',1, 'noise_type','gaussian', 'param',5);  % 视图1: 10%高斯噪声
    struct('view_idx',2, 'noise_type','gaussian', 'param',5);   % 视图2: 20%高斯噪声
    struct('view_idx',3, 'noise_type','gaussian', 'param',5);  % 视图3: 10%高斯噪声
    struct('view_idx',4, 'noise_type','gaussian', 'param',5);   % 视图4: 20%高斯噪声
    struct('view_idx',5, 'noise_type','gaussian', 'param',5)   % 视图5: 10%高斯噪声
    % struct('view_idx',6, 'noise_type','gaussian', 'param',5)   % 视图5: 10%高斯噪声
];


% 4. 批量加噪（仅修改fea副本，不影响原始数据和gt）
fea_noisy = fea;  % 复制原始fea，避免直接修改
for i = 1:length(noise_config)
    cfg = noise_config(i);
    switch cfg.noise_type
        case 'gaussian'
            fea_noisy{cfg.view_idx} = add_gaussian_noise(fea_noisy{cfg.view_idx}, cfg.param);
        case 's&p'
            % fea_noisy{cfg.view_idx} = add_salt_pepper_noise(fea_noisy{cfg.view_idx}, cfg.param);
    end
end

% 5. 保存带噪数据集（完全复刻原始结构：fea_noisy + gt）
save('MSRC_v1_noisy_30.mat', 'fea_noisy', 'gt');  % 新文件名，不覆盖原始MSRC_v1.mat

% 6. 验证保存结果（可选）
disp('========== 加噪完成 ==========');
disp(['原始视图数量：', num2str(length(fea))]);
disp(['带噪视图数量：', num2str(length(fea_noisy))]);
disp(['标签gt尺寸：', num2str(size(gt))]);
disp('带噪数据集已保存为：MSRC_v1_noisy.mat（结构：fea_noisy + gt）');