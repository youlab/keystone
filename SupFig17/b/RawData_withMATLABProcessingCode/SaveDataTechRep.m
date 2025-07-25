colNames = {'time_h', 'BR1_TR1', 'BR1_TR2', 'BR1_TR3', 'BR2_TR1', 'BR2_TR2', 'BR2_TR3'};

sTable1 = array2table([time', B2, B3, B4, B5, B6, B7], 'VariableNames', colNames);
writetable(sTable1, 'ProcessedTimeCourse_E55_inUncondition_NoCB_MovAvg04.xlsx')

sTable2 = array2table([time', C2, C3, C4, C5, C6, C7], 'VariableNames', colNames);
writetable(sTable2, 'ProcessedTimeCourse_E55_inE57supernatant_NoCB_MovAvg04.xlsx')


sTable3 = array2table([time', E2, E3, E4, E5, E6, E7], 'VariableNames', colNames);
writetable(sTable3, 'ProcessedTimeCourse_E57_inUncondition_NoCB_MovAvg04.xlsx')

sTable4 = array2table([time', F2, F3, F4, F5, F6, F7], 'VariableNames', colNames);
writetable(sTable4, 'ProcessedTimeCourse_E57_inE55supernatant_NoCB_MovAvg04.xlsx')


sTable5 = array2table([time', G2, G3, G4, G5, G6, G7], 'VariableNames', colNames);
writetable(sTable5, 'ProcessedTimeCourse_E57_inUncondition_CB10_MovAvg04.xlsx')

sTable6 = array2table([time', D2, D3, D4, D5, D6, D7], 'VariableNames', colNames);
writetable(sTable6, 'ProcessedTimeCourse_E57_inE55supernatant_CB10_MovAvg04.xlsx')


sTable7 = array2table([time', I2, I3, I4, I5, I6, I7], 'VariableNames', colNames);
writetable(sTable7, 'ProcessedTimeCourse_E55_inUncondition_CB10_MovAvg04.xlsx')

sTable8 = array2table([time', J2, J3, J4, J5, J6, J7], 'VariableNames', colNames);
writetable(sTable8, 'ProcessedTimeCourse_E55_inE57supernatant_CB10_MovAvg04.xlsx')