%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#    Script responsible to process key sensitivity metric in decipher   #
%#          image for data storage in all ".csv" analysis files.         #
%#                                                                       #
%# STUDENT                                                               #
%#                                                                       #
%#     João Paulo Fernanades de Cerqueira César                          #
%#                                                                       #
%# ADVISOR                                                               #
%#                                                                       #
%#     Wilian Soares Lacerda                                             #
%#                                                                       #
%#-----------------------------------------------------------------------#
%#                                                                       #
%# File: processSensitivityCipher.m                                      #
%#                                                                       #
%# About: This file describe a script which calculates the mean value    #
%#        of each key sensitivity metric and their standard deviation.   #
%#        These values are showed in tables saved in ".csv" files.       #
%#                                                                       #
%# 21/03/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ---------------- KEY SENSITIVITY ANALYSIS DECIPHER RGB ----------------- 
% ------------------------------------------------------------------------

% Calculates the key sensitivity for all RGB decipher images.
for i = 1:qtFilesRGB

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset decipher image.

    % TRIVIUM

        % Get the mean value of each channel correlation.
        for j = 1:numel(tablesRGB_Trivium{i, 2}.corr_redKeySensDecipher)
    
            temp1(j) = mean([tablesRGB_Trivium{i, 2}.corr_redKeySensDecipher(j) ...
                             tablesRGB_Trivium{i, 2}.corr_greenKeySensDecipher(j) ...
                             tablesRGB_Trivium{i, 2}.corr_blueKeySensDecipher(j)]);
    
        end
            
        keySensDecipherRGB_Trivium_mean{i} = mean(temp1);
        keySensDecipherRGB_Trivium_std{i}  =  std(temp1);

        
    % GRAIN

        % Get the mean value of each channel correlation.
        for j = 1:numel(tablesRGB_Grain{i, 2}.corr_redKeySensDecipher)
    
            temp2(j) = mean([tablesRGB_Grain{i, 2}.corr_redKeySensDecipher(j) ...
                             tablesRGB_Grain{i, 2}.corr_greenKeySensDecipher(j) ...
                             tablesRGB_Grain{i, 2}.corr_blueKeySensDecipher(j)]);
    
        end
            
        keySensDecipherRGB_Grain_mean{i} = mean(temp2);
        keySensDecipherRGB_Grain_std{i}  =  std(temp2);


    % MICKEY

        % Get the mean value of each channel correlation.
        for j = 1:numel(tablesRGB_Mickey{i, 2}.corr_redKeySensDecipher)
    
            temp3(j) = mean([tablesRGB_Mickey{i, 2}.corr_redKeySensDecipher(j) ...
                             tablesRGB_Mickey{i, 2}.corr_greenKeySensDecipher(j) ...
                             tablesRGB_Mickey{i, 2}.corr_blueKeySensDecipher(j)]);
    
        end
            
        keySensDecipherRGB_Mickey_mean{i} = mean(temp3);
        keySensDecipherRGB_Mickey_std{i}  =  std(temp3);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensDecipherRGB_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensDecipherRGB_Trivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensDecipherRGB_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensDecipherRGB_Grain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensDecipherRGB_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensDecipherRGB_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'keySensDecipherRGB.csv']);



%% -----------------------------------------------------------------------
% ---------------- KEY SENSITIVITY ANALYSIS DECIPHER GRAY ---------------- 
% ------------------------------------------------------------------------

% Calculates the key sensitivity for all grayscale decipher images.
for i = 1:qtFilesGray

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset decipher image.

    % TRIVIUM
            
        keySensDecipherGray_Trivium_mean{i} = mean(tablesGray_Trivium{i, 2}.corr_keySensDecipher);
        keySensDecipherGray_Trivium_std{i}  =  std(tablesGray_Trivium{i, 2}.corr_keySensDecipher);

        
    % GRAIN

        keySensDecipherGray_Grain_mean{i} = mean(tablesGray_Grain{i, 2}.corr_keySensDecipher);
        keySensDecipherGray_Grain_std{i}  =  std(tablesGray_Grain{i, 2}.corr_keySensDecipher);


    % MICKEY

        keySensDecipherGray_Mickey_mean{i} = mean(tablesGray_Mickey{i, 2}.corr_keySensDecipher);
        keySensDecipherGray_Mickey_std{i}  =  std(tablesGray_Mickey{i, 2}.corr_keySensDecipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensDecipherGray_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensDecipherGray_Trivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensDecipherGray_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensDecipherGray_Grain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensDecipherGray_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensDecipherGray_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'keySensDecipherGray.csv']);