function noisy_view = add_gaussian_noise(view, SNR_dB)
    % 计算原始视图的信号功率
    signal_power = mean(view(:).^2);
    
    % 根据SNR计算噪声功率
    noise_power = signal_power / (10^(SNR_dB/10));
    
    % 生成高斯噪声
    noise = sqrt(noise_power) * randn(size(view));
    
    % 添加噪声
    noisy_view = view + noise;
end