%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#       Script responsible to process correlation metric for data       #
%#                 storage in all ".csv" analysis files.                 #
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
%# File: processCorrelation.m                                            #
%#                                                                       #
%# About: This file describe a script which calculates the mean value    #
%#        of each correlation metric and their standard deviation. These #
%#        values are showed in tables saved in ".csv" files.             #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ---------------------- CORRELATION ANALYSIS RGB ------------------------ 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all RGB images.
for i = 1:qtFilesRGB

    % Get the mean value of all execution sample for each dataset plain image.
    corr_rgbPlain_H{i}     = mean(tablesRGB_Trivium{i, 2}.corr_rgbPlain_H);
    corr_rgbPlain_V{i}     = mean(tablesRGB_Trivium{i, 2}.corr_rgbPlain_V);
    corr_rgbPlain_D{i}     = mean(tablesRGB_Trivium{i, 2}.corr_rgbPlain_D);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        corr_rgbCipher_H_Trivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.corr_rgbCipher_H);
        corr_rgbCipher_H_Trivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.corr_rgbCipher_H);

        corr_rgbCipher_V_Trivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.corr_rgbCipher_V);
        corr_rgbCipher_V_Trivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.corr_rgbCipher_V);

        corr_rgbCipher_D_Trivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.corr_rgbCipher_D);
        corr_rgbCipher_D_Trivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.corr_rgbCipher_D);


    % GRAIN

        corr_rgbCipher_H_Grain_mean{i}     = mean(tablesRGB_Grain{i, 2}.corr_rgbCipher_H);
        corr_rgbCipher_H_Grain_std{i}      =  std(tablesRGB_Grain{i, 2}.corr_rgbCipher_H);

        corr_rgbCipher_V_Grain_mean{i}     = mean(tablesRGB_Grain{i, 2}.corr_rgbCipher_V);
        corr_rgbCipher_V_Grain_std{i}      =  std(tablesRGB_Grain{i, 2}.corr_rgbCipher_V);

        corr_rgbCipher_D_Grain_mean{i}     = mean(tablesRGB_Grain{i, 2}.corr_rgbCipher_D);
        corr_rgbCipher_D_Grain_std{i}      =  std(tablesRGB_Grain{i, 2}.corr_rgbCipher_D);


    % MICKEY

        corr_rgbCipher_H_Mickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.corr_rgbCipher_H);
        corr_rgbCipher_H_Mickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.corr_rgbCipher_H);

        corr_rgbCipher_V_Mickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.corr_rgbCipher_V);
        corr_rgbCipher_V_Mickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.corr_rgbCipher_V);

        corr_rgbCipher_D_Mickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.corr_rgbCipher_D);
        corr_rgbCipher_D_Mickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.corr_rgbCipher_D);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM

T.H_Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_H_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_H_Trivium_std','UniformOutput',false)); 

T.V_Trivium  = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_V_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_V_Trivium_std','UniformOutput',false)); 

T.D_Trivium   = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_D_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_D_Trivium_std','UniformOutput',false)); 

% GRAIN

T.H_Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_H_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_H_Grain_std','UniformOutput',false)); 

T.V_Grain  = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_V_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_V_Grain_std','UniformOutput',false)); 

T.D_Grain   = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_D_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_D_Grain_std','UniformOutput',false));   

% MICKEY

T.H_Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_H_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_H_Mickey_std','UniformOutput',false)); 

T.V_Mickey  = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_V_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_V_Mickey_std','UniformOutput',false)); 

T.D_Mickey   = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_rgbCipher_D_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_rgbCipher_D_Mickey_std','UniformOutput',false));


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'correlationRGB_cipher.csv']);

% ----------------------------------------------------------------------------------------------------------------

% Table for plain image.

T = table;

T.File = fileNamesRGB';

T.Horz = cellfun(@(x) num2str(x,'%.6f'),corr_rgbPlain_H','UniformOutput',false);
T.Vert = cellfun(@(x) num2str(x,'%.6f'),corr_rgbPlain_V','UniformOutput',false);
T.Diag = cellfun(@(x) num2str(x,'%.6f'),corr_rgbPlain_D','UniformOutput',false);

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'correlationRGB_plain.csv']);



%% -----------------------------------------------------------------------
% --------------------- CORRELATION ANALYSIS GRAY ------------------------ 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all grayscale images.
for i = 1:qtFilesGray

    % Get the mean value of all execution sample for each dataset plain image.
    corr_plain_H{i}     = mean(tablesGray_Trivium{i, 2}.corr_plain_H);
    corr_plain_V{i}     = mean(tablesGray_Trivium{i, 2}.corr_plain_V);
    corr_plain_D{i}     = mean(tablesGray_Trivium{i, 2}.corr_plain_D);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        corr_cipher_H_Trivium_mean{i}     = mean(tablesGray_Trivium{i, 2}.corr_cipher_H);
        corr_cipher_H_Trivium_std{i}      =  std(tablesGray_Trivium{i, 2}.corr_cipher_H);

        corr_cipher_V_Trivium_mean{i}     = mean(tablesGray_Trivium{i, 2}.corr_cipher_V);
        corr_cipher_V_Trivium_std{i}      =  std(tablesGray_Trivium{i, 2}.corr_cipher_V);

        corr_cipher_D_Trivium_mean{i}     = mean(tablesGray_Trivium{i, 2}.corr_cipher_D);
        corr_cipher_D_Trivium_std{i}      =  std(tablesGray_Trivium{i, 2}.corr_cipher_D);


    % GRAIN

        corr_cipher_H_Grain_mean{i}     = mean(tablesGray_Grain{i, 2}.corr_cipher_H);
        corr_cipher_H_Grain_std{i}      =  std(tablesGray_Grain{i, 2}.corr_cipher_H);

        corr_cipher_V_Grain_mean{i}     = mean(tablesGray_Grain{i, 2}.corr_cipher_V);
        corr_cipher_V_Grain_std{i}      =  std(tablesGray_Grain{i, 2}.corr_cipher_V);

        corr_cipher_D_Grain_mean{i}     = mean(tablesGray_Grain{i, 2}.corr_cipher_D);
        corr_cipher_D_Grain_std{i}      =  std(tablesGray_Grain{i, 2}.corr_cipher_D);


    % MICKEY

        corr_cipher_H_Mickey_mean{i}     = mean(tablesGray_Mickey{i, 2}.corr_cipher_H);
        corr_cipher_H_Mickey_std{i}      =  std(tablesGray_Mickey{i, 2}.corr_cipher_H);

        corr_cipher_V_Mickey_mean{i}     = mean(tablesGray_Mickey{i, 2}.corr_cipher_V);
        corr_cipher_V_Mickey_std{i}      =  std(tablesGray_Mickey{i, 2}.corr_cipher_V);

        corr_cipher_D_Mickey_mean{i}     = mean(tablesGray_Mickey{i, 2}.corr_cipher_D);
        corr_cipher_D_Mickey_std{i}      =  std(tablesGray_Mickey{i, 2}.corr_cipher_D);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% TRIVIUM

T.H_Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_H_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_H_Trivium_std','UniformOutput',false)); 

T.V_Trivium  = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_V_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_V_Trivium_std','UniformOutput',false)); 

T.D_Trivium   = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_D_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_D_Trivium_std','UniformOutput',false)); 

% GRAIN

T.H_Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_H_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_H_Grain_std','UniformOutput',false)); 

T.V_Grain  = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_V_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_V_Grain_std','UniformOutput',false)); 

T.D_Grain   = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_D_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_D_Grain_std','UniformOutput',false));   

% MICKEY

T.H_Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_H_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_H_Mickey_std','UniformOutput',false)); 

T.V_Mickey  = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_V_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_V_Mickey_std','UniformOutput',false)); 

T.D_Mickey   = strcat(cellfun(@(x) num2str(x,'%.6f'),corr_cipher_D_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),corr_cipher_D_Mickey_std','UniformOutput',false));


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'correlationGray_cipher.csv']);

% ----------------------------------------------------------------------------------------------------------------

% Table for plain image.

T = table;

T.File = fileNamesGray';

T.Horz = cellfun(@(x) num2str(x,'%.6f'),corr_plain_H','UniformOutput',false);
T.Vert = cellfun(@(x) num2str(x,'%.6f'),corr_plain_V','UniformOutput',false);
T.Diag = cellfun(@(x) num2str(x,'%.6f'),corr_plain_D','UniformOutput',false);

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'correlationGray_plain.csv']);