function noisy_view = add_salt_pepper_noise(view, noise_density)
    % 创建原始视图副本
    noisy_view = view;
    [n_samples, n_features] = size(view);
    
    % 计算噪声点数
    num_noise = round(noise_density * n_samples * n_features);
    
    % 随机选择噪声位置
    idx = randperm(n_samples * n_features, num_noise);
    
    % 随机分配椒（最小值）和盐（最大值）
    min_val = min(view(:));
    max_val = max(view(:));
    
    % 添加椒噪声（50%位置）
    noisy_view(idx(1:floor(end/2))) = min_val;
    
    % 添加盐噪声（剩余50%位置）
    noisy_view(idx(floor(end/2)+1:end)) = max_val;
end