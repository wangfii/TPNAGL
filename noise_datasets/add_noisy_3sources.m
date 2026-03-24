% 1. 加载原始数据
addpath('./');
load('MSRC_v1.mat'); % 包含view1, view2, view3
view1 = fea{1};
view2 = fea{2};
view3 = fea{3};
view4 = fea{4};
view5 = fea{5};
% view4 = X{4};
% 2. 设置噪声参数
noise_config = [
    struct('view_idx',1, 'noise_type','gaussian', 'param',10); % 视图1: SNR=10dB
    struct('view_idx',2, 'noise_type','gaussian', 'param',10); % 视图1: SNR=10dB
    struct('view_idx',3, 'noise_type','gaussian', 'param',10)  % 视图3: SNR=5dB
    struct('view_idx',4, 'noise_type','gaussian', 'param',10); % 视图1: SNR=10dB
    struct('view_idx',5, 'noise_type','gaussian', 'param',10)  % 视图3: SNR=5dB
%     struct('view_idx',4, 'noise_type','gaussian', 'param',20)  % 视图3: SNR=5dB
%     struct('view_idx',1, 'noise_type','s&p',      'param',0.1);% 视图2: 30%椒盐
%     struct('view_idx',2, 'noise_type','s&p',      'param',0.2);% 视图2: 30%椒盐
%     struct('view_idx',3, 'noise_type','s&p',      'param',0.1);% 视图2: 30%椒盐
%     struct('view_idx',4, 'noise_type','s&p',      'param',0.3);% 视图2: 30%椒盐
%     struct('view_idx',1, 'noise_type','gaussian',      'param',20);% 视图2: 30%椒盐
%     struct('view_idx',2, 'noise_type','s&p',      'param',0.2);% 视图2: 30%椒盐
%     struct('view_idx',3, 'noise_type','gaussian',      'param',20);% 视图2: 30%椒盐
%     struct('view_idx',4, 'noise_type','s&p',      'param',0.3);% 视图2: 30%椒盐
];

% 3. 添加噪声
corrupted_views = {view1, view2, view3,view4,view5};
for i = 1:length(noise_config)
    cfg = noise_config(i);
    switch cfg.noise_type
        case 'gaussian'
            corrupted_views{cfg.view_idx} = ...
                add_gaussian_noise(corrupted_views{cfg.view_idx}, cfg.param);
        case 's&p'
            corrupted_views{cfg.view_idx} = ...
                add_salt_pepper_noise(corrupted_views{cfg.view_idx}, cfg.param);
    end
end

