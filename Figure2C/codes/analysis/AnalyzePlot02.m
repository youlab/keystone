clear
close all

ConfigIDVec = 1; %1:1:10;
dVec = 2 * [0, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8, 9, 12, 15, 18, 20]; % 4:2:24;

for ii=1:length(ConfigIDVec)
    
    ConfigID = ConfigIDVec(ii);

    for jj=1:length(dVec)

        d = dVec(jj);

        TimeVec = [24 36 48 72]; % 0:12:72;

        Output = zeros(length(TimeVec), 7);

        condition = ['1Kp1Pa' '_' 'd' num2str(d) 'mm'];
        conditionTitle = condition; %['4-by-4; 1to1; ConfigID = ' num2str(ConfigID) '; d_{min} = ' num2str(d)];

        for i=1:length(TimeVec)

            Time = TimeVec(i);

            Pa = readmatrix([condition '_Pa_t' num2str(Time) 'h.csv']);
            Kp = readmatrix([condition '_Kp_t' num2str(Time) 'h.csv']);

            Tot = Pa + Kp;

            Cmin = 0.05; %1e-9;

            Pa_bw = Pa > Cmin;
            Kp_bw = Kp > Cmin;
            Tot_bw = Tot > Cmin;

        %     Pa_bw = imbinarize(Pa);
        %     Kp_bw = imbinarize(Kp);
        %     Tot_bw = imbinarize(Tot);

        %     PaEdge = imcomplement(edge(Pa_bw)); 
        %     KpEdge = imcomplement(edge(Kp_bw));
        % 
        %     % g1= imshow(rgb2gray(g1, 3), 'ColorMap', [1 1 1; 0 0 1])
        %     % g2= imshow(KpEdge, 'ColorMap', [1 1 1; 255/255 192/255 203/255])
        % 
        %     imwrite(PaEdge, 'g1.tif'); imwrite(KpEdge, 'g2.tif')
        % 
        %     g1 = imread('g1.tif'); g2 = imread('g2.tif'); 
        % 
        %     delete('g1.tif');  delete('g2.tif');


            g = imfuse(imcomplement(Pa_bw), imcomplement(Kp_bw), 'ColorChannels', 'red-cyan');

            fig1= figure(1);
            imshow(g)
            title(['Time = ' num2str(Time) ' h'])
            set(gca, 'FontSize', 16)
            drawnow;
%             saveas(fig1, [condition '_CTX2p5_BWimage_t' num2str(Time) 'h.png'])
            % saveas(fig2, [pwd '/Bias_CTX2p5_BWimage_t48h.png'])

            P = double(Pa_bw);
            K = double(Kp_bw);
            S = double(Tot_bw);

            Output(i, 1) = Time;
            Output(i, 2) =  sum(Tot(:)); % total biomass
            Output(i, 3) =  sum(S(:)); % total colonized area
            Output(i, 4) =  sum(Pa(:)); % Pa biomass
            Output(i, 5) =  sum(Kp(:)); % Pa biomass
            Output(i, 6) =  sum(P(:)); % Pa colonized area
            Output(i, 7) =  sum(K(:)); % Kp colonized area

        end

            sTable = array2table(Output);
            variableNames = {'Time_h', 'TotalBiomass', 'TotalColonizedArea', 'PaBiomass', 'KpBiomass', 'PaColonizedArea', 'KpColonizedArea'};
            sTable.Properties.VariableNames = variableNames;

            writetable(sTable, [condition '_CTX2p5_BWimage_AnalyzedOutput.xlsx'])

            fig2 = figure(2);
            for j=1:size(Output,2)-1
                plot(Output(:, 1), Output(:, 1+j), '-o', 'LineWidth', 4)
                hold on
            end
            hold off
            xlabel('Time (h)')
            legend(variableNames(2:end), 'Location', 'Northwest')
            title(num2str(conditionTitle))
            set(gca, 'FontSize', 14)
            drawnow;
%             saveas(fig2, [condition '_CTX2p5_TimeCourses.png'])
%             saveas(fig2, [condition '_CTX2p5_TimeCourses.fig'])

    end
    
end