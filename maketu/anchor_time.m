clc; clear; close all;
addpath('ZoomPlot-MATLAB-main\');

% 1. 数据准备（严格匹配你的表格）
x = [1000, 2000, 3000, 4000, 5000];  % 横坐标（1k/2k/3k/4k/5k）
% 各数据集运行时间（秒）
time.MSRC     = [0.63, 0.86, 0.99, 1.22, 1.23];
time.Flower17 = [8.78, 10.91, 12.08, 13.95, 15.43];
time.Mfeat    = [7.94, 10.9, 12.58, 13.18, 14.45];
time.CCV      = [16.58, 19.59, 24.58, 30.42, 34.89];
time.Hdigit   = [21.80, 24.42, 26.62, 30.53, 33.44];
time.AIOL     = [62.84, 98.07, 120.79, 157.26, 197.72];
time.Reuters  = [165.44, 184.49, 187.27, 431.15, 520.93];

% 2. 初始化绘图（适配大数值跨度，设置合适画布）
figure('Color','w', 'Position',[100, 100, 900, 600]);
hold on; grid on;

% 3. 定义配色和线型（区分度高，适配7个数据集）
colors = [
    0.64 0.08 0.18;  % 蓝色（MSRC）
    0.93 0.69 0.13; % 橙色（Flower17）
    0.93 0.69 0.13;  % 黄色（Mfeat）
    0.64 0.08 0.18;  % 红色（CCV）
    0.47 0.67 0.19;  % 绿色（Hdigit）
    0.30 0.75 0.93;  % 浅蓝（AIOL）
    0.49 0.18 0.56;  % 紫色（Reuters）
];
markers = {'o', 's', '^', 'd', 'v', '<', '>'};  % 不同标记区分数据集
line_width = 1.5;
marker_size = 6;

% 4. 绘制各数据集折线
h1 = plot(x, time.MSRC, 'Color', colors(1,:), 'Marker', markers{1}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);
h2 = plot(x, time.Flower17, 'Color', colors(2,:), 'Marker', markers{2}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);
h3 = plot(x, time.Mfeat, 'Color', colors(3,:), 'Marker', markers{3}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);
h4 = plot(x, time.CCV, 'Color', colors(4,:), 'Marker', markers{4}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);
h5 = plot(x, time.Hdigit, 'Color', colors(5,:), 'Marker', markers{5}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);
h6 = plot(x, time.AIOL, 'Color', colors(6,:), 'Marker', markers{6}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);
h7 = plot(x, time.Reuters, 'Color', colors(7,:), 'Marker', markers{7}, ...
    'LineWidth', line_width, 'MarkerSize', marker_size);

% 5. 图表样式优化（移除不兼容的Alpha属性，保留核心美化效果）
% 坐标轴设置
xlabel('Anchor number', 'FontSize', 14, 'FontName', 'Arial');
ylabel('Running Time (seconds)', 'FontSize', 14, 'FontName', 'Arial');
xlim([800, 5200]);  % 横轴范围（留边距）
set(gca, 'XTick', x, 'XTickLabel', {'1k', '2k', '3k', '4k', '5k'});  % 横轴显示1k/2k等
set(gca, 'FontSize', 12, 'FontName', 'Arial', 'TickDir', 'out');

% 网格样式（仅保留兼容的设置，浅灰色网格已足够柔和）
set(gca, 'GridColor', [0.8 0.8 0.8]);  % 浅灰色网格，不刺眼
set(gca, 'Box', 'off');  % 去掉外边框

% 图例（清晰显示所有数据集）
legend([h1,h2,h3,h4,h5,h6,h7], ...
    'MSRC', 'Flower17', 'Mfeat', 'CCV', 'Hdigit', 'AIOL', 'Reuters', ...
    'Location', 'northwest', 'FontSize', 10, 'FontName', 'Arial', 'Box', 'off');

zp = BaseZoom();
zp.run();


% % 6. 导出高清图片（600DPI，适合论文/报告）
% print(gcf, '-dpng', '-r600', 'running_time_plot.png');

