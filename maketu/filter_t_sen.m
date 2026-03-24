 参数 k 对八个指标的影响（示例数据）
k = 1:5;   % 数据长度为5

% 数据输入为百分制（已转换）
%ACC
% MSRC_v1 =      [99.38 99.67 99.57 100 99.71]; 
% Flower17 =      [91.53 90.39 88.70 89.17 91.14]; 
% Mfeat =      [99.93 99.95 100 99.95 99.90]; 
% CCV =  [55.46 49.63 42.40 41.92 39.77]; 
% Hdigit =      [99.68 99.88 99.56 99.53 99.23]; 
% AIOL =       [74.91 72.16 72.37 71.73 72.69]; 
% Reuters = [98.08 97.65 98.23 97.97 98.50]; 

%NMI
MSRC_v1 =      [98.6 99.25 99.03 100 99.35]; 
Flower17 =      [93.34 92.79 93.17 92.94 92.56]; 
Mfeat =      [99.82 99.86 100 99.86 99.73]; 
CCV =  [55.74 48.73 40.52 39.49 37.50]; 
Hdigit =      [99.10 99.61 98.98 98.64 97.74]; 
AIOL =       [91.31 89.15 89.26 89.48 89.26]; 
Reuters = [94.29 93.80 95.04 94.39 95.43]; 


figure;
hold on;
grid on;

% 绘制各指标曲线
plot(k, MSRC_v1, '-s', 'Color', [168, 21, 21]/255, 'MarkerFaceColor', [168, 21, 21]/255, 'LineWidth', 1.5);
plot(k, Flower17, '-o', 'Color', [218, 165, 32]/255, 'MarkerFaceColor', [218, 165, 32]/255, 'LineWidth', 1.5);
plot(k, Mfeat, '-^', 'Color', [25, 25, 112]/255, 'MarkerFaceColor', [25, 25, 112]/255, 'LineWidth', 1.5);
plot(k, CCV, '-v', 'Color', [34, 139, 34]/255, 'MarkerFaceColor', [34, 139, 34]/255, 'LineWidth', 1.5);
plot(k, Hdigit, '-d', 'Color', [0, 139, 139]/255, 'MarkerFaceColor', [0, 139, 139]/255, 'LineWidth', 1.5);
plot(k, AIOL, '-h', 'Color', [138, 43, 226]/255, 'MarkerFaceColor', [138, 43, 226]/255, 'LineWidth', 1.5);
plot(k, Reuters, '-p', 'Color', [255, 105, 180]/255, 'MarkerFaceColor', [255, 105, 180]/255, 'LineWidth', 1.5);


% 坐标轴设置
% 坐标轴设置
xlim([0.5, 5.5]);
ylim([0, 100]);
xticks(1:5);
xticklabels({'$1k$', '$2k$', '$3k$', '$4k$', '$5k$'});
set(gca, 'TickLabelInterpreter', 'latex');

% 设置 Y 轴刻度和标签
yticks(0:10:100);  % 显示 0 到 100，每隔 10 一格
yticklabels(arrayfun(@(v) sprintf('%d', v), 0:10:100, 'UniformOutput', false));

ylabel('NMI (%)');

% 图例
legend({'MSRC\_v1','Flower17','Mfeat','CCV','Hdigit','AIOL','Reuters'}, ...
    'Location','southwest','FontSize',8);

% 坐标轴字体
set(gca,'FontSize',10);
box on;
hold off;
