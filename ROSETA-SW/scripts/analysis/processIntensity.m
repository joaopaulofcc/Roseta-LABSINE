%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#     Script responsible to process pixel intensity metric for data     #
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
%# File: processIntensity.m                                              #
%#                                                                       #
%# About: This file describe a script which calculates the mean value    #
%#        of each pixel intensity metric and their standard deviation.   #
%#        These values are showed in tables saved in ".csv" files.       #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ----------------------- AVERAGE INTENSITY RGB -------------------------- 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all RGB images.
for i = 1:qtFilesRGB

    fileNamesRGB{i}   = tablesRGB_Trivium{i, 1};

    % Get the file names from the first array column.
    %fileNames{i} = tablesRGB_Trivium{i, 1};

    % Get the mean value of all execution sample for each dataset plain image.
    redIntensityPlain_mean{i}       = mean(tablesRGB_Trivium{i, 2}.redIntensityPlain);
    greenIntensityPlain_mean{i}     = mean(tablesRGB_Trivium{i, 2}.greenIntensityPlain);
    blueIntensityPlain_mean{i}      = mean(tablesRGB_Trivium{i, 2}.blueIntensityPlain);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        redIntensityCipherTrivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.redIntensityCipher);
        redIntensityCipherTrivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.redIntensityCipher);

        greenIntensityCipherTrivium_mean{i}    = mean(tablesRGB_Trivium{i, 2}.greenIntensityCipher);
        greenIntensityCipherTrivium_std{i}     =  std(tablesRGB_Trivium{i, 2}.greenIntensityCipher);

        blueIntensityCipherTrivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.blueIntensityCipher);
        blueIntensityCipherTrivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.blueIntensityCipher);


    % GRAIN

        redIntensityCipherGrain_mean{i}      = mean(tablesRGB_Grain{i, 2}.redIntensityCipher);
        redIntensityCipherGrain_std{i}       =  std(tablesRGB_Grain{i, 2}.redIntensityCipher);

        greenIntensityCipherGrain_mean{i}    = mean(tablesRGB_Grain{i, 2}.greenIntensityCipher);
        greenIntensityCipherGrain_std{i}     =  std(tablesRGB_Grain{i, 2}.greenIntensityCipher);

        blueIntensityCipherGrain_mean{i}     = mean(tablesRGB_Grain{i, 2}.blueIntensityCipher);
        blueIntensityCipherGrain_std{i}      =  std(tablesRGB_Grain{i, 2}.blueIntensityCipher);


    % MICKEY

        redIntensityCipherMickey_mean{i}      = mean(tablesRGB_Mickey{i, 2}.redIntensityCipher);
        redIntensityCipherMickey_std{i}       =  std(tablesRGB_Mickey{i, 2}.redIntensityCipher);

        greenIntensityCipherMickey_mean{i}    = mean(tablesRGB_Mickey{i, 2}.greenIntensityCipher);
        greenIntensityCipherMickey_std{i}     =  std(tablesRGB_Mickey{i, 2}.greenIntensityCipher);

        blueIntensityCipherMickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.blueIntensityCipher);
        blueIntensityCipherMickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.blueIntensityCipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM

T.redTrivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),redIntensityCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),redIntensityCipherTrivium_std','UniformOutput',false)); 

T.greenTrivium  = strcat(cellfun(@(x) num2str(x,'%.6f'),greenIntensityCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),greenIntensityCipherTrivium_std','UniformOutput',false)); 

T.blueTrivium   = strcat(cellfun(@(x) num2str(x,'%.6f'),blueIntensityCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),blueIntensityCipherTrivium_std','UniformOutput',false)); 

% GRAIN

T.redGrain    = strcat(cellfun(@(x) num2str(x,'%.6f'),redIntensityCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),redIntensityCipherGrain_std','UniformOutput',false)); 

T.greenGrain  = strcat(cellfun(@(x) num2str(x,'%.6f'),greenIntensityCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),greenIntensityCipherGrain_std','UniformOutput',false)); 

T.blueGrain   = strcat(cellfun(@(x) num2str(x,'%.6f'),blueIntensityCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),blueIntensityCipherGrain_std','UniformOutput',false));   

% MICKEY

T.redMickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),redIntensityCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),redIntensityCipherMickey_std','UniformOutput',false)); 

T.greenMickey  = strcat(cellfun(@(x) num2str(x,'%.6f'),greenIntensityCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),greenIntensityCipherMickey_std','UniformOutput',false)); 

T.blueMickey   = strcat(cellfun(@(x) num2str(x,'%.6f'),blueIntensityCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),blueIntensityCipherMickey_std','UniformOutput',false));


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'intensityRGB_cipher.csv']);

% ----------------------------------------------------------------------------------------------------------------

% Table for plain imege.

T = table;

T.File = fileNamesRGB';

T.red     = cellfun(@(x) num2str(x,'%.6f'),redIntensityPlain_mean','UniformOutput',false);
T.green   = cellfun(@(x) num2str(x,'%.6f'),greenIntensityPlain_mean','UniformOutput',false);
T.blue    = cellfun(@(x) num2str(x,'%.6f'),blueIntensityPlain_mean','UniformOutput',false);

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'intensityRGB_plain.csv']);



%% -----------------------------------------------------------------------
% ---------------------- AVERAGE INTENSITY GRAY -------------------------- 
% ------------------------------------------------------------------------

% Calculates the average pixel intensity for all grayscale images.
for i = 1:qtFilesGray

    fileNamesGray{i}   = tablesGray_Trivium{i, 1};

    % Get the file names from the first array column.
    %fileNamesGray{i} = tablesGray_Trivium{i, 1};

    % Get the mean value of all execution sample for each dataset plain image.
    intensityPlain_mean{i}       = mean(tablesGray_Trivium{i, 2}.intensityPlain);


    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        intensityCipherTrivium_mean{i}      = mean(tablesGray_Trivium{i, 2}.intensityCipher);
        intensityCipherTrivium_std{i}       =  std(tablesGray_Trivium{i, 2}.intensityCipher);


    % GRAIN

        intensityCipherGrain_mean{i}      = mean(tablesGray_Grain{i, 2}.intensityCipher);
        intensityCipherGrain_std{i}       =  std(tablesGray_Grain{i, 2}.intensityCipher);


    % MICKEY

        intensityCipherMickey_mean{i}      = mean(tablesGray_Mickey{i, 2}.intensityCipher);
        intensityCipherMickey_std{i}       =  std(tablesGray_Mickey{i, 2}.intensityCipher);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% PLAIN
T.Plain       = cellfun(@(x) num2str(x,'%.6f'),intensityPlain_mean','UniformOutput',false);


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),intensityCipherTrivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),intensityCipherTrivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),intensityCipherGrain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),intensityCipherGrain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),intensityCipherMickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),intensityCipherMickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'intensityGray.csv']);