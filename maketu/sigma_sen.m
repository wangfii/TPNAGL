% 模拟数据（4组锚点数量：1c, 3c, 5c, 7c）
ACC = [ 
    62.85 75.16 80.86 88.49 91.53;   % Flower17
    24.73 25.93 33.65 44.17 55.46;   % CCV
    48.31 53.56 71.2 74.91 73.39;   % AIOL
    98.08 96.88 96.71 94.99 92.10 
    % Reuters ← 新增行
];

% ACC = [ 
%     76.22 84.05 84.57 90.94 93.34;   % Flower17
%     22.04 24.37 31.09 42.09 55.74;   % CCV
%     72.02 76.09 88.49 91.31 88.64;   % AIOL
%     94.29 92.29 91.9 89.07 84.94
%     % Reuters ← 新增行
% ];

% 自定义颜色
base_colors = [
    172, 224, 207;
    142, 188, 219;
    167, 159, 206;
    254, 159, 105;
    254, 192, 128;
] / 255;

figure;
hold on;

num_groups = size(ACC,1);  % 组数 = 4
num_bars = size(ACC,2);    % 每组柱子数量 = 7
group_width = min(0.8, num_bars / (num_bars + 1.5));

h = gobjects(num_bars,1);  % 存柱子句柄

for i = 1:num_bars
    x = (1:num_groups) - group_width/2 + (2*i-1) * group_width / (2*num_bars);
    color = base_colors(mod(i-1, size(base_colors,1)) + 1, :);
    h(i) = bar(x, ACC(:,i), group_width / num_bars, ...
        'FaceColor', color, 'EdgeColor', 'none');
end

% 坐标轴设置
set(gca, 'XTick', 1:num_groups, 'XTickLabel', {'Flower17', 'CCV', 'AIOL', 'Reuters'});
xlim([0.5, num_groups + 0.5]);
ylim([0 100]);
ylabel('ACC (%)');
set(gca, 'FontSize', 12);
box on;

% 图例
legend_lines = gobjects(5, 1);
for i = 1:5
    legend_lines(i) = plot(NaN, NaN, 's', 'MarkerFaceColor', base_colors(i,:), ...
                           'MarkerEdgeColor', base_colors(i,:), 'MarkerSize', 5);
end
lgd = legend(legend_lines, {'\sigma=0.8\delta','\sigma=1\delta','\sigma=1.2\delta','\sigma=1.5\delta','\sigma=1.8\delta'}, ...
             'FontSize', 8);

% 关闭默认 Location，改用绝对定位微调图例位置
lgd.Position = [0.15, 0.15, 0.15, 0.3];

% 缩小图例符号
legend_children = findobj(lgd, 'Type', 'Line');
for i = 1:length(legend_children)
    legend_children(i).MarkerSize = 2;
end


% 调整坐标轴避免图例遮挡
outerpos = get(gca, 'OuterPosition');
ti = get(gca, 'TightInset'); 
left = outerpos(1) + ti(1) + 0.02;
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.02;
ax_height = outerpos(4) - ti(2) - ti(4);
set(gca, 'Position', [left bottom ax_width ax_height]);

hold off;
