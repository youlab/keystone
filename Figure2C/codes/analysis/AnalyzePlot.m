clear
close all
% 
% MC = readmatrix("1Kp1Pa_d16mm_t_vs_MaxChanges.csv");
% 
% MaxVec = movmean(MC, 100, "Endpoints", "discard");
% 
% MaxVecNorm = zeros(size(MaxVec));
% 
% MaxVecNorm(:, 1) = MaxVec(:, 1);
% 
% for i=1:5
% 
%     MaxVecNorm(:, i+1) = MaxVec(:,i+1)/max(MaxVec(:,i+1));
% 
% end
% 
% fig1 = figure(1);
% semilogx(MaxVec(:,1), MaxVec(:,2)/max(MaxVec(:,2)), 'b-', LineWidth=3)
% hold on
% semilogx(MaxVec(:,1), MaxVec(:,3)/max(MaxVec(:,3)), 'k-', LineWidth=3)
% hold on
% semilogx(MaxVec(:,1), MaxVec(:,4)/max(MaxVec(:,4)), 'r-', LineWidth=3)
% hold on
% semilogx(MaxVec(:,1), MaxVec(:,5)/max(MaxVec(:,5)), 'g-.', LineWidth=3)
% hold on
% semilogx(MaxVec(:,1), MaxVec(:,6)/max(MaxVec(:,6)), 'm-', LineWidth=3)
% hold off
% legend('Pa', 'N', 'Kp', 'CTX', 'ESBL')


Pa48 = readmatrix("1Kp1Pa_d40mm_Pa_t48h.csv");
Kp48 = readmatrix("1Kp1Pa_d40mm_Kp_t48h.csv");

Cell48 = Pa48 + Kp48;

th = 0.05; % graythresh(Cell48); 

Cell48_bw = Cell48 > th; % imbinarize(Cell48);

imwrite(Cell48_bw, [pwd '/1Kp1Pa_d40mm_CTX2p5_BWimage_t48h.png'])

% fig2= figure(2);
% imshow(Cell48_bw)
% imagesc(Cell48_bw); colormap(gray); axis off;
% saveas(fig2, [pwd '/1Kp1Pa_d6mm_CTX2p5_BWimage_t48h.png'])
% saveas(fig2, [pwd '/Bias_CTX2p5_BWimage_t48h.png'])



dS = double(Cell48_bw);

sum(dS(:))
