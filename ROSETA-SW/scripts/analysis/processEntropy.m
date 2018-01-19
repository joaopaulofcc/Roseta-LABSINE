%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#     Script responsible to process entropy metric for data storage     #
%#                      in all ".csv" analysis files.                    #
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
%# File: processEntropy.m                                                #
%#                                                                       #
%# About: This file describe a script which calculates the mean value    #
%#        of each entropy metric and their standard deviation. These     #
%#        values are showed in tables saved in ".csv" files.             #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ------------------------ ENTROPY ANALYSIS RGB -------------------------- 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all RGB images.
for i = 1:qtFilesRGB

    % Get the mean value of all execution sample for each dataset plain image.
    redEntropyPlain_mean{i}       = mean(tablesRGB_Trivium{i, 2}.entropyRedPlain);
    greenEntropyPlain_mean{i}     = mean(tablesRGB_Trivium{i, 2}.entropyGreenPlain);
    blueEntropyPlain_mean{i}      = mean(tablesRGB_Trivium{i, 2}.entropyBluePlain);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        redEntropyCipherTrivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.entropyRedCipher);
        redEntropyCipherTrivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.entropyRedCipher);

        greenEntropyCipherTrivium_mean{i}    = mean(tablesRGB_Trivium{i, 2}.entropyGreenCipher);
        greenEntropyCipherTrivium_std{i}     =  std(tablesRGB_Trivium{i, 2}.entropyGreenCipher);

        blueEntropyCipherTrivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.entropyBlueCipher);
        blueEntropyCipherTrivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.entropyBlueCipher);


    % GRAIN

        redEntropyCipherGrain_mean{i}      = mean(tablesRGB_Grain{i, 2}.entropyRedCipher);
        redEntropyCipherGrain_std{i}       =  std(tablesRGB_Grain{i, 2}.entropyRedCipher);

        greenEntropyCipherGrain_mean{i}    = mean(tablesRGB_Grain{i, 2}.entropyGreenCipher);
        greenEntropyCipherGrain_std{i}     =  std(tablesRGB_Grain{i, 2}.entropyGreenCipher);

        blueEntropyCipherGrain_mean{i}     = mean(tablesRGB_Grain{i, 2}.entropyBlueCipher);
        blueEntropyCipherGrain_std{i}      =  std(tablesRGB_Grain{i, 2}.entropyBlueCipher);


    % MICKEY

        redEntropyCipherMickey_mean{i}      = mean(tablesRGB_Mickey{i, 2}.entropyRedCipher);
        redEntropyCipherMickey_std{i}       =  std(tablesRGB_Mickey{i, 2}.entropyRedCipher);

        greenEntropyCipherMickey_mean{i}    = mean(tablesRGB_Mickey{i, 2}.entropyGreenCipher);
        greenEntropyCipherMickey_std{i}     =  std(tablesRGB_Mickey{i, 2}.entropyGreenCipher);

        blueEntropyCipherMickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.entropyBlueCipher);
        blueEntropyCipherMickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.entropyBlueCipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM

T.redTrivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),redEntropyCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),redEntropyCipherTrivium_std','UniformOutput',false)); 

T.greenTrivium  = strcat(cellfun(@(x) num2str(x,'%.6f'),greenEntropyCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),greenEntropyCipherTrivium_std','UniformOutput',false)); 

T.blueTrivium   = strcat(cellfun(@(x) num2str(x,'%.6f'),blueEntropyCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),blueEntropyCipherTrivium_std','UniformOutput',false)); 

% GRAIN

T.redGrain    = strcat(cellfun(@(x) num2str(x,'%.6f'),redEntropyCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),redEntropyCipherGrain_std','UniformOutput',false)); 

T.greenGrain  = strcat(cellfun(@(x) num2str(x,'%.6f'),greenEntropyCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),greenEntropyCipherGrain_std','UniformOutput',false)); 

T.blueGrain   = strcat(cellfun(@(x) num2str(x,'%.6f'),blueEntropyCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),blueEntropyCipherGrain_std','UniformOutput',false));   

% MICKEY

T.redMickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),redEntropyCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),redEntropyCipherMickey_std','UniformOutput',false)); 

T.greenMickey  = strcat(cellfun(@(x) num2str(x,'%.6f'),greenEntropyCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),greenEntropyCipherMickey_std','UniformOutput',false)); 

T.blueMickey   = strcat(cellfun(@(x) num2str(x,'%.6f'),blueEntropyCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),blueEntropyCipherMickey_std','UniformOutput',false));


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'entropyRGB_cipher.csv']);

% ----------------------------------------------------------------------------------------------------------------

% Table for plain image.

T = table;

T.File = fileNamesRGB';

T.red     = cellfun(@(x) num2str(x,'%.6f'),redEntropyPlain_mean','UniformOutput',false);
T.green   = cellfun(@(x) num2str(x,'%.6f'),greenEntropyPlain_mean','UniformOutput',false);
T.blue    = cellfun(@(x) num2str(x,'%.6f'),blueEntropyPlain_mean','UniformOutput',false);

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'entropyRGB_plain.csv']);



%% -----------------------------------------------------------------------
% -------------------- ENTROPY ANALYSIS ENTIRE RGB ----------------------- 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all RGB images.
for i = 1:qtFilesRGB

    % Get the mean value of all execution sample for each dataset plain image.
    entropyRGBPlain_mean{i}       = mean(tablesRGB_Trivium{i, 2}.entropyRGBPlain);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        entropyRGBCipherTrivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.entropyRGBCipher);
        entropyRGBCipherTrivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.entropyRGBCipher);


    % GRAIN

        entropyRGBCipherGrain_mean{i}      = mean(tablesRGB_Grain{i, 2}.entropyRGBCipher);
        entropyRGBCipherGrain_std{i}       =  std(tablesRGB_Grain{i, 2}.entropyRGBCipher);


    % MICKEY

        entropyRGBCipherMickey_mean{i}      = mean(tablesRGB_Mickey{i, 2}.entropyRGBCipher);
        entropyRGBCipherMickey_std{i}       =  std(tablesRGB_Mickey{i, 2}.entropyRGBCipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% PLAIN
T.Plain       = cellfun(@(x) num2str(x,'%.6f'),entropyRGBPlain_mean','UniformOutput',false);


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),entropyRGBCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),entropyRGBCipherTrivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),entropyRGBCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),entropyRGBCipherGrain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),entropyRGBCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),entropyRGBCipherMickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'entropyRGBEntire.csv']);



%% -----------------------------------------------------------------------
% ----------------------- ENTROPY ANALYSIS GRAY -------------------------- 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all grayscale images.
for i = 1:qtFilesGray

    % Get the mean value of all execution sample for each dataset plain image.
    entropyPlain_mean{i}       = mean(tablesGray_Trivium{i, 2}.entropyPlain);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        entropyCipherTrivium_mean{i}      = mean(tablesGray_Trivium{i, 2}.entropyCipher);
        entropyCipherTrivium_std{i}       =  std(tablesGray_Trivium{i, 2}.entropyCipher);


    % GRAIN

        entropyCipherGrain_mean{i}      = mean(tablesGray_Grain{i, 2}.entropyCipher);
        entropyCipherGrain_std{i}       =  std(tablesGray_Grain{i, 2}.entropyCipher);


    % MICKEY

        entropyCipherMickey_mean{i}      = mean(tablesGray_Mickey{i, 2}.entropyCipher);
        entropyCipherMickey_std{i}       =  std(tablesGray_Mickey{i, 2}.entropyCipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% PLAIN
T.Plain       = cellfun(@(x) num2str(x,'%.6f'),entropyPlain_mean','UniformOutput',false);


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),entropyCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),entropyCipherTrivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),entropyCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),entropyCipherGrain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),entropyCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),entropyCipherMickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'entropyGray.csv']);