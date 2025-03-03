%%% Emrah Simsek %%%
% "MD" represents the data presented in Figure 3A.

colNames = {'time_h', 'Tech Rep 1', 'Tech Rep 2', 'Tech Rep 3'};

sTable1 = array2table([time', B2, C2, D2], 'VariableNames', colNames);
writetable(sTable1, 'ProcessedTimeCourse_E55_HD_NoCB_MovAvg04.xlsx')

sTable2 = array2table([time', E2, F2, G2], 'VariableNames', colNames);
writetable(sTable2, 'ProcessedTimeCourse_Mix_HD_NoCB_MovAvg04.xlsx')

sTable3 = array2table([time', H2, I2, J2], 'VariableNames', colNames);
writetable(sTable3, 'ProcessedTimeCourse_E57_HD_NoCB_MovAvg04.xlsx')


sTable4 = array2table([time', B3, C3, D3], 'VariableNames', colNames);
writetable(sTable4, 'ProcessedTimeCourse_E55_MD_NoCB_MovAvg04.xlsx')

sTable5 = array2table([time', E3, F3, G3], 'VariableNames', colNames);
writetable(sTable5, 'ProcessedTimeCourse_Mix_MD_NoCB_MovAvg04.xlsx')

sTable6 = array2table([time', H3, I3, J3], 'VariableNames', colNames);
writetable(sTable6, 'ProcessedTimeCourse_E57_MD_NoCB_MovAvg04.xlsx')

sTable7 = array2table([time', B4, C4, D4], 'VariableNames', colNames);
writetable(sTable7, 'ProcessedTimeCourse_E55_LD_NoCB_MovAvg04.xlsx')

sTable8 = array2table([time', E4, F4, G4], 'VariableNames', colNames);
writetable(sTable8, 'ProcessedTimeCourse_Mix_LD_NoCB_MovAvg04.xlsx')

sTable9 = array2table([time', H4, I4, J4], 'VariableNames', colNames);
writetable(sTable9, 'ProcessedTimeCourse_E57_LD_NoCB_MovAvg04.xlsx')


sTable10 = array2table([time', B5, C5, D5], 'VariableNames', colNames);
writetable(sTable10, 'ProcessedTimeCourse_E55_HD_CB10_MovAvg04.xlsx')

sTable11 = array2table([time', E5, F5, G5], 'VariableNames', colNames);
writetable(sTable11, 'ProcessedTimeCourse_Mix_HD_CB10_MovAvg04.xlsx')

sTable12 = array2table([time', H5, I5, J5], 'VariableNames', colNames);
writetable(sTable12, 'ProcessedTimeCourse_E57_HD_CB10_MovAvg04.xlsx')


sTable13 = array2table([time', B6, C6, D6], 'VariableNames', colNames);
writetable(sTable13, 'ProcessedTimeCourse_E55_MD_CB10_MovAvg04.xlsx')

sTable14 = array2table([time', E6, F6, G6], 'VariableNames', colNames);
writetable(sTable14, 'ProcessedTimeCourse_Mix_MD_CB10_MovAvg04.xlsx')

sTable15 = array2table([time', H6, I6, J6], 'VariableNames', colNames);
writetable(sTable15, 'ProcessedTimeCourse_E57_MD_CB10_MovAvg04.xlsx')

sTable16 = array2table([time', B7, C7, D7], 'VariableNames', colNames);
writetable(sTable16, 'ProcessedTimeCourse_E55_LD_CB10_MovAvg04.xlsx')

sTable17 = array2table([time', E7, F7, G7], 'VariableNames', colNames);
writetable(sTable17, 'ProcessedTimeCourse_Mix_LD_CB10_MovAvg04.xlsx')

sTable18 = array2table([time', H7, I7, J7], 'VariableNames', colNames);
writetable(sTable18, 'ProcessedTimeCourse_E57_LD_CB10_MovAvg04.xlsx')