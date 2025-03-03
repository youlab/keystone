clear
close all

L  = 90;
nx = 1001; ny = nx;
dx = L / (nx - 1); 
dy = dx;

setDistVec = [0, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8, 9, 12, 15, 18, 20];

TotColArea_t24 = zeros(size(setDistVec, 2), 2);
TotColArea_t36 = zeros(size(setDistVec, 2), 2);
TotColArea_t48 = zeros(size(setDistVec, 2), 2);
TotColArea_t72 = zeros(size(setDistVec, 2), 2);

for i = 1:size(setDistVec, 2)

    M = readmatrix (['1Kp1Pa_d' num2str(2*setDistVec(i)) 'mm_CTX2p5_BWimage_AnalyzedOutput.xlsx']);

    TotColArea_t24(i, 1) = 2*setDistVec(i); 
    TotColArea_t24(i, 2) = M(1, 3) * dx * dy;

    TotColArea_t36(i, 1) = 2*setDistVec(i); 
    TotColArea_t36(i, 2) = M(2, 3) * dx * dy;

    TotColArea_t48(i, 1) = 2*setDistVec(i); 
    TotColArea_t48(i, 2) = M(3, 3) * dx * dy; 

    TotColArea_t72(i, 1) = 2*setDistVec(i); 
    TotColArea_t72(i, 2) = M(4, 3) * dx * dy;
    
end

writematrix(TotColArea_t24, [pwd '/1Kp1Pa_d_vs_TotColAreaes_t24.xlsx'])
writematrix(TotColArea_t36, [pwd '/1Kp1Pa_d_vs_TotColAreaes_t36.xlsx'])
writematrix(TotColArea_t48, [pwd '/1Kp1Pa_d_vs_TotColAreaes_t48.xlsx'])
writematrix(TotColArea_t72, [pwd '/1Kp1Pa_d_vs_TotColAreaes_t72.xlsx'])