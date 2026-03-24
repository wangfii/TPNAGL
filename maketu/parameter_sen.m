clc; clear;

% 准备数据
%%  ------ ACC  --------------------------
Z = [
    90.67	98.09	77.047	93.047	95.9	96.76;
    91.85	99.14	81.47	93.33	96.09	96.52;
    86.8	98.04	69.52	93.38	95.71	96.33;
    76.95	78.04	98.28	93.52	97.71	97.28;
    95.38	96.90 	77.14	95.33	93.23	94.61;
    92.85	92.85	96.66	97.80 	98.19	97.61
   ];  % MSRC



% 创建画布
figure;

% --- (1) 绘制 3D 柱状图（上）---
subplot(2,1,1); % 上面
h = bar3(Z, 0.8);
axis([-inf inf -inf inf 0 100]);

% 设置颜色
for n = 1:numel(h)
    cdata = get(h(n),'zdata');
    cdata = repmat(max(cdata, [], 2), 1, 4);
    set(h(n), 'cdata', cdata, 'facecolor', 'flat');
end
colorbar;

% 设置刻度和字体
set(gca, 'yticklabel', {'0.0001','0.001','0.01','0.1','1','10'}, 'Fontname', 'Times New Roman', 'FontSize', 11);
set(gca, 'xticklabel', {'0.0001','0.001','0.01','0.1','1','10'}, 'Fontname', 'Times New Roman', 'FontSize', 11);

% 轴标签
ylabel('\lambda', 'Fontname', '宋体', 'FontSize', 14);
xlabel('\gamma', 'Fontname', '宋体', 'FontSize', 14);
zlabel('ACC', 'Fontname', '宋体', 'FontSize', 14);

% --- (2) 绘制 2D 柱状图（下）---
subplot(2,1,2); % 下面
gamma = {'0.0001','0.001','0.01','0.1','1','10'};
ACC = [73.14	74.61	72.81	75.29	83.86	99.14]; % MSRC
% ACC = [83.23	83.85	84.33	88.55	96.78	99.6];  % Mfeat
% ACC = [52.07	51.66	52.57	54.14	79.42	97.34]; % Hdigit

% NMI = [63.42	65.11	62.89	68.17	78.94	98.07]; % MSRC
% NMI = [77.96	77.96	78.26	81.53	97.7	98.97]; % Mfeat
% NMI = [47.3	47.31	47.84	50.31	76.31	98.27]; % Hdigit

% Fscore = [61.1	63.06	60.28	65.64	75.99	98.27]; % MSRC
% Fscore = [73.8	73.97	74.54	79.78	96.73	99.2]; % Mfeat
% Fscore = [41.5	41.24	41.84	43.78	72.22	97.28]; % Hdigit

% PUR = [75.14	76.38	74.29	77.62	83.86	99.14]; % MSRC
% PUR = [83.65	83.86	84.33	88.55	97.48	99.6]; % Mfeat
% PUR = [54.21	53.69	54.4	55.74	80.74	97.68]; % Hdigit

% bar(gamma, ACC, 'b'); % 使用蓝色单一颜色柱子

bar(gamma, ACC, 'FaceColor', [253,211,159]/255); % 橙色

% 设置轴标签与范围
xlabel('\alpha', 'Fontname', '宋体', 'FontSize', 14);
ylabel('ACC', 'Fontname', '宋体', 'FontSize', 14);
ylim([0 100]);

% 添加网格线（小网格）
grid on;
grid minor;
