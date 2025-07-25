clear
clc
close all

gry = [0.7, 0.7, 0.7];
purple = [0.4940 0.1840 0.5560];
purple2 = [75 0 130]./255;
lpurple = [0.9940 0.1840 0.5560];

M1 = readmatrix('ProcessedTimeCourse_E23_MD_NoCTX_MovAvg04_.xlsx');
M2 = readmatrix('ProcessedTimeCourse_E23_MD_CTX2p5_MovAvg04_.xlsx');
figFileName = 'Kp_final_MD.pdf';

x1 = M1(:, 1)';
y1 = M1(:, 2:end)';

x2 = M2(:, 1)';
y2 = M2(:, 2:end)';

% Make the plot
clf
fig1 = figure(1);
s1 = shadedErrorBar(x1,y1,{@mean,@std},'lineprops','-k','patchSaturation',0.33);
% Set face and edge properties
set(s1.edge,'LineWidth', 0.1, 'LineStyle', '-', 'Color', gry)
s1.mainLine.LineWidth = 4;
s1.patch.FaceColor = [0.7, 0.7, 0.7]; %[0.5, 0.25, 0.25];

% Overlay data points post-hoc
hold on
plot(s1.mainLine.XData, s1.mainLine.YData, '.k', 'MarkerFaceColor', 'k')

% Overlay second line
hold on
s2 = shadedErrorBar(x2, y2, {@mean,@std},'lineprops',{'-', 'Color', purple2, 'MarkerFaceColor', purple2});
% Set face and edge properties
set(s2.edge,'LineWidth', 0.1, 'LineStyle', '-', 'Color', purple2)
s2.mainLine.LineWidth = 4;
s2.patch.FaceColor = purple2; %[0.5, 0.25, 0.25];

% Overlay data points post-hoc
hold on
plot(s2.mainLine.XData, s2.mainLine.YData, '-', 'MarkerFaceColor', purple2)

hold off
xlim([0 27])
ylim([0 1])
set(gca, 'FontSize', 28, 'XTick', [0:6:24], 'YTick', [0:0.25:1], 'TickDir', 'out')
xlabel('time (h)', 'FontSize', 36)
ylabel('OD_{600}', 'FontSize', 36)
% Remove the figure box lines
box off;
% % Set figure size and paper position
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);

%saveas(fig1, figFileName)