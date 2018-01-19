%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#     Script responsible to process key sensitivity metric in cipher    #
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
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ----------------- KEY SENSITIVITY ANALYSIS CIPHER RGB ------------------ 
% ------------------------------------------------------------------------

% Calculates the key sensitivity for all RGB cipher images.
for i = 1:qtFilesRGB

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        % Get the mean value of each channel correlation.
        for j = 1:numel(tablesRGB_Trivium{i, 2}.corr_redKeySensCipher)
    
            temp1(j) = mean([tablesRGB_Trivium{i, 2}.corr_redKeySensCipher(j) ...
                             tablesRGB_Trivium{i, 2}.corr_greenKeySensCipher(j) ...
                             tablesRGB_Trivium{i, 2}.corr_blueKeySensCipher(j)]);
    
        end
            
        keySensCipherRGB_Trivium_mean{i} = mean(temp1);
        keySensCipherRGB_Trivium_std{i}  =  std(temp1);

        
    % GRAIN

        % Get the mean value of each channel correlation.
        for j = 1:numel(tablesRGB_Grain{i, 2}.corr_redKeySensCipher)
    
            temp2(j) = mean([tablesRGB_Grain{i, 2}.corr_redKeySensCipher(j) ...
                             tablesRGB_Grain{i, 2}.corr_greenKeySensCipher(j) ...
                             tablesRGB_Grain{i, 2}.corr_blueKeySensCipher(j)]);
    
        end
            
        keySensCipherRGB_Grain_mean{i} = mean(temp2);
        keySensCipherRGB_Grain_std{i}  =  std(temp2);


    % MICKEY

        % Get the mean value of each channel correlation.
        for j = 1:numel(tablesRGB_Mickey{i, 2}.corr_redKeySensCipher)
    
            temp3(j) = mean([tablesRGB_Mickey{i, 2}.corr_redKeySensCipher(j) ...
                             tablesRGB_Mickey{i, 2}.corr_greenKeySensCipher(j) ...
                             tablesRGB_Mickey{i, 2}.corr_blueKeySensCipher(j)]);
    
        end
            
        keySensCipherRGB_Mickey_mean{i} = mean(temp3);
        keySensCipherRGB_Mickey_std{i}  =  std(temp3);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensCipherRGB_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensCipherRGB_Trivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensCipherRGB_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensCipherRGB_Grain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensCipherRGB_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensCipherRGB_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'keySensCipherRGB.csv']);



%% -----------------------------------------------------------------------
% ----------------- KEY SENSITIVITY ANALYSIS CIPHER GRAY ----------------- 
% ------------------------------------------------------------------------

% Calculates the key sensitivity for all grayscale cipher images.
for i = 1:qtFilesGray

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM
            
        keySensCipherGray_Trivium_mean{i} = mean(tablesGray_Trivium{i, 2}.corr_keySensCipher);
        keySensCipherGray_Trivium_std{i}  =  std(tablesGray_Trivium{i, 2}.corr_keySensCipher);

        
    % GRAIN

        keySensCipherGray_Grain_mean{i} = mean(tablesGray_Grain{i, 2}.corr_keySensCipher);
        keySensCipherGray_Grain_std{i}  =  std(tablesGray_Grain{i, 2}.corr_keySensCipher);


    % MICKEY

        keySensCipherGray_Mickey_mean{i} = mean(tablesGray_Mickey{i, 2}.corr_keySensCipher);
        keySensCipherGray_Mickey_std{i}  =  std(tablesGray_Mickey{i, 2}.corr_keySensCipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensCipherGray_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensCipherGray_Trivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensCipherGray_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensCipherGray_Grain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),keySensCipherGray_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),keySensCipherGray_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'keySensCipherGray.csv']);