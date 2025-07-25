clear; close all;

%% === USER SETTINGS ===
d = 18;                          % Distance in mm (set this manually)
timePoints = [24, 36, 48, 72];  % Time points in hours
th = 0.05;                      % Threshold for binarization

%% === LOOP OVER TIME POINTS ===
for t = timePoints
    fprintf("Processing d = %imm, t = %ih...\n", d, t);

    %% Construct filenames
    PaFile = sprintf("1Kp1Pa_d%imm_Pa_t%ih.csv", d, t);
    KpFile = sprintf("1Kp1Pa_d%imm_Kp_t%ih.csv", d, t);

    %% Load and flip
    Pa = flipud(readmatrix(PaFile));
    Kp = flipud(readmatrix(KpFile));

    %% Composite image
    Cell = Pa + Kp;

    %% Binarization
    Cell_bw = Cell > th;

    %% Display (optional)
    figure;
    imshow(Cell); 
    title(sprintf('Raw Composite Image - d = %imm, t = %ih', d, t));

    %% Save binary image
    outFile = sprintf("1Kp1Pa_d%imm_CTX2p5_BWimage_t%ih.png", d, t);
    imwrite(Cell_bw, fullfile(pwd, outFile));

    %% Area calculation
    areaPixels = sum(Cell_bw(:));
    fprintf("Colonized area (pixels) at t = %ih: %d\n", t, areaPixels);

    %% Optional: pause between figures or close
    pause(0.5);  % optional pause to view images
    close all;   % optional: close figure windows to avoid clutter
end
