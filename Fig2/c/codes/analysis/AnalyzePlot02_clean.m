clear; close all;

%% === USER INPUTS ===
ConfigIDVec = 1;  % Can be a vector of config IDs if needed
dVec = 18;        % Can also be a vector, e.g., [14, 16, 18]
TimeVec = [24, 36, 48, 72];  % Time points in hours
Cmin = 0.05;      % Threshold for binarization

%% === MAIN PROCESSING ===
for ConfigID = ConfigIDVec
    for d = dVec

        condition = sprintf("1Kp1Pa_d%imm", d);
        conditionTitle = condition;

        Output = zeros(length(TimeVec), 7);  % Initialize output array

        for i = 1:length(TimeVec)
            t = TimeVec(i);

            %% Load and flip
            Pa = flipud(readmatrix(sprintf("%s_Pa_t%ih.csv", condition, t)));
            Kp = flipud(readmatrix(sprintf("%s_Kp_t%ih.csv", condition, t)));

            Tot = Pa + Kp;

            %% Binarize
            Pa_bw = Pa > Cmin;
            Kp_bw = Kp > Cmin;
            Tot_bw = Tot > Cmin;

            %% Color overlay
            g = imfuse(imcomplement(Pa_bw), imcomplement(Kp_bw), 'ColorChannels', 'red-cyan');

            figure(1); clf;
            imshow(g)
            title(sprintf("Time = %ih", t), 'FontSize', 16);
            drawnow;
            % Optionally save overlay image:
            % saveas(gcf, sprintf("%s_CTX2p5_BWimage_t%ih.png", condition, t));

            %% Quantify
            Output(i, :) = [ ...
                t, ...
                sum(Tot(:)), ...
                sum(Tot_bw(:)), ...
                sum(Pa(:)), ...
                sum(Kp(:)), ...
                sum(Pa_bw(:)), ...
                sum(Kp_bw(:)) ...
            ];
        end

        %% Save analysis results
        variableNames = {'Time_h', 'TotalBiomass', 'TotalColonizedArea', ...
                         'PaBiomass', 'KpBiomass', 'PaColonizedArea', 'KpColonizedArea'};
        sTable = array2table(Output, 'VariableNames', variableNames);

        outputFileName = sprintf("%s_CTX2p5_BWimage_AnalyzedOutput.xlsx", condition);
        writetable(sTable, outputFileName);

        %% Plot time courses
        figure(2); clf;
        for j = 2:size(Output,2)
            plot(Output(:,1), Output(:,j), '-o', 'LineWidth', 3);
            hold on;
        end
        hold off;
        xlabel('Time (h)');
        ylabel('Value');
        legend(variableNames(2:end), 'Location', 'Northwest');
        title(conditionTitle, 'Interpreter', 'none');
        set(gca, 'FontSize', 14);
        drawnow;
        % Optionally save time course plot:
        % saveas(gcf, sprintf("%s_CTX2p5_TimeCourses.png", condition));

    end
end
