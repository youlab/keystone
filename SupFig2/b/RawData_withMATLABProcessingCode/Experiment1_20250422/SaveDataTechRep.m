colNames = {'time_h', 'Tech Rep 1', 'Tech Rep 2', 'Tech Rep 3', 'Tech Rep 4', 'Tech Rep 5', 'Tech Rep 6'};

sTable1 = array2table([time', B2, B3, B4, B5, B6, B7], 'VariableNames', colNames);
writetable(sTable1, 'ProcessedTimeCourse_E22_inUncondition_NoCTX_MovAvg04.xlsx')

sTable2 = array2table([time', C2, C3, C4, C5, C6, C7], 'VariableNames', colNames);
writetable(sTable2, 'ProcessedTimeCourse_E22_inE23supernatant_NoCTX_MovAvg04.xlsx')


sTable3 = array2table([time', E2, E3, E4, E5, E6, E7], 'VariableNames', colNames);
writetable(sTable3, 'ProcessedTimeCourse_E23_inUncondition_NoCTX_MovAvg04.xlsx')

sTable4 = array2table([time', F2, F3, F4, F5, F6, F7], 'VariableNames', colNames);
writetable(sTable4, 'ProcessedTimeCourse_E23_inE22supernatant_NoCTX_MovAvg04.xlsx')


sTable5 = array2table([time', G2, G3, G4, G5, G6, G7], 'VariableNames', colNames);
writetable(sTable5, 'ProcessedTimeCourse_E23_inUncondition_CTX2p5_MovAvg04.xlsx')

sTable6 = array2table([time', D2, D3, D4, D5, D6, D7], 'VariableNames', colNames);
writetable(sTable6, 'ProcessedTimeCourse_E23_inE22supernatant_CTX2p5_MovAvg04.xlsx')


sTable7 = array2table([time', I2, I3, I4, I5, I6, I7], 'VariableNames', colNames);
writetable(sTable7, 'ProcessedTimeCourse_E22_inUncondition_CTX2p5_MovAvg04.xlsx')

sTable8 = array2table([time', J2, J3, J4, J5, J6, J7], 'VariableNames', colNames);
writetable(sTable8, 'ProcessedTimeCourse_E22_inE23supernatant_CTX2p5_MovAvg04.xlsx')