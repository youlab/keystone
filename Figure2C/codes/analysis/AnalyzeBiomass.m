clear
close all

setDistVec = [0, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8, 9, 12, 15, 18, 20];

Biomass_t24 = zeros(size(setDistVec, 2), 4);
Biomass_t36 = zeros(size(setDistVec, 2), 4);
Biomass_t48 = zeros(size(setDistVec, 2), 4);
Biomass_t72 = zeros(size(setDistVec, 2), 4);


for i = 1:size(setDistVec, 2)

    M = readmatrix (['1Kp1Pa_d' num2str(2*setDistVec(i)) 'mm_t_vs_Biomass.csv']);

    Biomass_t24(i, 1) = 2*setDistVec(i); 
    Biomass_t24(i, 2:end) = M(3, 2:end);

    Biomass_t36(i, 1) = 2*setDistVec(i); 
    Biomass_t36(i, 2:end) = M(4, 2:end);

    Biomass_t48(i, 1) = 2*setDistVec(i); 
    Biomass_t48(i, 2:end) = M(5, 2:end); 

    Biomass_t72(i, 1) = 2*setDistVec(i); 
    Biomass_t72(i, 2:end) = M(7, 2:end);
    
end

writematrix(Biomass_t24, [pwd '/1Kp1Pa_d_vs_Biomasses_t24.xlsx'])
writematrix(Biomass_t36, [pwd '/1Kp1Pa_d_vs_Biomasses_t36.xlsx'])
writematrix(Biomass_t48, [pwd '/1Kp1Pa_d_vs_Biomasses_t48.xlsx'])
writematrix(Biomass_t72, [pwd '/1Kp1Pa_d_vs_Biomasses_t72.xlsx'])