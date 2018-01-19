%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#    Script responsible to process differential UACI metric for data    #
%#                  storage in all ".csv" analysis files.                #
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
%# File: processUACI.m                                                   #
%#                                                                       #
%# About: This file describe a script which calculates the mean value of #
%#        each UACI metric and their standard deviation. These values    #
%#        are showed in tables saved in ".csv" files. For all mettrics,  #
%#        the three cryptosystems are analyzed to verify if they respec  #
%#        ts each p-value described in <https://goo.gl/zwNPfw> Wu2011 -  #
%#        NPCR and UACI Randomness Testsfor Image Encryption             #
%#                                                                       #
%# 09/03/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ------------------------- UACI P-VALUES LIMITS -------------------------
% ------------------------------------------------------------------------

% 256 px

pvalueUACI_256_005_down    = 0.332824; 
pvalueUACI_256_005_up      = 0.336447; 

pvalueUACI_256_001_down    = 0.332255;
pvalueUACI_256_001_up      = 0.337016;

pvalueUACI_256_0001_down   = 0.331594;
pvalueUACI_256_0001_up     = 0.337677;

% 512 px

pvalueUACI_512_005_down    = 0.333730; 
pvalueUACI_512_005_up      = 0.335541; 

pvalueUACI_512_001_down    = 0.333445;
pvalueUACI_512_001_up      = 0.335826;

pvalueUACI_512_0001_down   = 0.333115;
pvalueUACI_512_0001_up     = 0.336156;

% 1024 px

pvalueUACI_1024_005_down    = 0.334183; 
pvalueUACI_1024_005_up      = 0.335088; 

pvalueUACI_1024_001_down    = 0.334040;
pvalueUACI_1024_001_up      = 0.335231;

pvalueUACI_1024_0001_down   = 0.333875;
pvalueUACI_1024_0001_up     = 0.335396;



%% -----------------------------------------------------------------------
% -------------------------- UACI ANALYSIS RGB ---------------------------
% ------------------------------------------------------------------------

% Calculates the differential UACI for all RGB images.
for i = 1:qtFilesRGB

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        diff_Red_UACIscore_Trivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.diff_Red_UACIscore);
        diff_Red_UACIscore_Trivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.diff_Red_UACIscore);

        diff_Green_UACIscore_Trivium_mean{i}    = mean(tablesRGB_Trivium{i, 2}.diff_Green_UACIscore);
        diff_Green_UACIscore_Trivium_std{i}     =  std(tablesRGB_Trivium{i, 2}.diff_Green_UACIscore);

        diff_Blue_UACIscore_Trivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.diff_Blue_UACIscore);
        diff_Blue_UACIscore_Trivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.diff_Blue_UACIscore);


    % GRAIN

        diff_Red_UACIscore_Grain_mean{i}        = mean(tablesRGB_Grain{i, 2}.diff_Red_UACIscore);
        diff_Red_UACIscore_Grain_std{i}         =  std(tablesRGB_Grain{i, 2}.diff_Red_UACIscore);

        diff_Green_UACIscore_Grain_mean{i}      = mean(tablesRGB_Grain{i, 2}.diff_Green_UACIscore);
        diff_Green_UACIscore_Grain_std{i}       =  std(tablesRGB_Grain{i, 2}.diff_Green_UACIscore);

        diff_Blue_UACIscore_Grain_mean{i}       = mean(tablesRGB_Grain{i, 2}.diff_Blue_UACIscore);
        diff_Blue_UACIscore_Grain_std{i}        =  std(tablesRGB_Grain{i, 2}.diff_Blue_UACIscore);

    % MICKEY

        diff_Red_UACIscore_Mickey_mean{i}       = mean(tablesRGB_Mickey{i, 2}.diff_Red_UACIscore);
        diff_Red_UACIscore_Mickey_std{i}        =  std(tablesRGB_Mickey{i, 2}.diff_Red_UACIscore);

        diff_Green_UACIscore_Mickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.diff_Green_UACIscore);
        diff_Green_UACIscore_Mickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.diff_Green_UACIscore);

        diff_Blue_UACIscore_Mickey_mean{i}      = mean(tablesRGB_Mickey{i, 2}.diff_Blue_UACIscore);
        diff_Blue_UACIscore_Mickey_std{i}       =  std(tablesRGB_Mickey{i, 2}.diff_Blue_UACIscore);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM

T.redTrivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Red_UACIscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Red_UACIscore_Trivium_std','UniformOutput',false)); 

T.greenTrivium  = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Green_UACIscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Green_UACIscore_Trivium_std','UniformOutput',false)); 

T.blueTrivium   = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Blue_UACIscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Blue_UACIscore_Trivium_std','UniformOutput',false)); 

% GRAIN

T.redGrain    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Red_UACIscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Red_UACIscore_Grain_std','UniformOutput',false)); 

T.greenGrain  = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Green_UACIscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Green_UACIscore_Grain_std','UniformOutput',false)); 

T.blueGrain   = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Blue_UACIscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Blue_UACIscore_Grain_std','UniformOutput',false));   

% MICKEY

T.redMickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Red_UACIscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Red_UACIscore_Mickey_std','UniformOutput',false)); 

T.greenMickey  = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Green_UACIscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Green_UACIscore_Mickey_std','UniformOutput',false)); 

T.blueMickey   = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Blue_UACIscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Blue_UACIscore_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'UACIRGB.csv']);



%% -----------------------------------------------------------------------
% ---------------------- UACI ANALYSIS ENTIRE RGB ------------------------
% ------------------------------------------------------------------------

% Calculates the differential UACI for all RGB images.
for i = 1:qtFilesRGB

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        diff_RGB_UACIscore_Trivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.diff_RGB_UACIscore);
        diff_RGB_UACIscore_Trivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.diff_RGB_UACIscore);

    % GRAIN

        diff_RGB_UACIscore_Grain_mean{i}        = mean(tablesRGB_Grain{i, 2}.diff_RGB_UACIscore);
        diff_RGB_UACIscore_Grain_std{i}         =  std(tablesRGB_Grain{i, 2}.diff_RGB_UACIscore);

    % MICKEY

        diff_RGB_UACIscore_Mickey_mean{i}       = mean(tablesRGB_Mickey{i, 2}.diff_RGB_UACIscore);
        diff_RGB_UACIscore_Mickey_std{i}        =  std(tablesRGB_Mickey{i, 2}.diff_RGB_UACIscore);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_RGB_UACIscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_RGB_UACIscore_Trivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_RGB_UACIscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_RGB_UACIscore_Grain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_RGB_UACIscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_RGB_UACIscore_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'UACIRGBEntire.csv']);



%% -----------------------------------------------------------------------
% -------------------------- UACI ANALYSIS GRAY ---------------------------
% ------------------------------------------------------------------------

% Calculates the differential UACI for all grayscale images.
for i = 1:qtFilesGray

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        diff_UACIscore_Trivium_mean{i}      = mean(tablesGray_Trivium{i, 2}.diff_UACIscore);
        diff_UACIscore_Trivium_std{i}       =  std(tablesGray_Trivium{i, 2}.diff_UACIscore);

    % GRAIN

        diff_UACIscore_Grain_mean{i}      = mean(tablesGray_Grain{i, 2}.diff_UACIscore);
        diff_UACIscore_Grain_std{i}       =  std(tablesGray_Grain{i, 2}.diff_UACIscore);

    % MICKEY

        diff_UACIscore_Mickey_mean{i}      = mean(tablesGray_Mickey{i, 2}.diff_UACIscore);
        diff_UACIscore_Mickey_std{i}       =  std(tablesGray_Mickey{i, 2}.diff_UACIscore);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% TRIVIUM

T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_UACIscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_UACIscore_Trivium_std','UniformOutput',false)); 

% GRAIN

T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_UACIscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_UACIscore_Grain_std','UniformOutput',false)); 

% MICKEY

T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_UACIscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_UACIscore_Mickey_std','UniformOutput',false)); 

             
% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'UACIGray.csv']);



%% -----------------------------------------------------------------------
% ------------------------ UACI P-VALUES ANALYSIS ------------------------
% ------------------------------------------------------------------------

% Runs the test for all RGB images.
for i = 1:qtFilesRGB
    
    % Gets the min and max value founded in all executions of all imagens for
    % each cryptosystem. This minimum value is calculated by subtracting the
    % mean value to the standard deviation, the maximum value is calculated by
    % adding the mean value to the standard deviation.
    
    % TRIVIUM
    
    minRed_Trivium      = mean(tablesRGB_Trivium{i, 2}.diff_Red_UACIscore) - std(tablesRGB_Trivium{i, 2}.diff_Red_UACIscore);
    maxRed_Trivium      = mean(tablesRGB_Trivium{i, 2}.diff_Red_UACIscore) + std(tablesRGB_Trivium{i, 2}.diff_Red_UACIscore);

    minGreen_Trivium    = mean(tablesRGB_Trivium{i, 2}.diff_Green_UACIscore) - std(tablesRGB_Trivium{i, 2}.diff_Green_UACIscore);
    maxGreen_Trivium    = mean(tablesRGB_Trivium{i, 2}.diff_Green_UACIscore) + std(tablesRGB_Trivium{i, 2}.diff_Green_UACIscore);

    minBlue_Trivium     = mean(tablesRGB_Trivium{i, 2}.diff_Blue_UACIscore) - std(tablesRGB_Trivium{i, 2}.diff_Blue_UACIscore);
    maxBlue_Trivium     = mean(tablesRGB_Trivium{i, 2}.diff_Blue_UACIscore) + std(tablesRGB_Trivium{i, 2}.diff_Blue_UACIscore);
    
    
    % GRAIN
    
    minRed_Grain      = mean(tablesRGB_Grain{i, 2}.diff_Red_UACIscore) - std(tablesRGB_Grain{i, 2}.diff_Red_UACIscore);
    maxRed_Grain      = mean(tablesRGB_Grain{i, 2}.diff_Red_UACIscore) + std(tablesRGB_Grain{i, 2}.diff_Red_UACIscore);

    minGreen_Grain    = mean(tablesRGB_Grain{i, 2}.diff_Green_UACIscore) - std(tablesRGB_Grain{i, 2}.diff_Green_UACIscore);
    maxGreen_Grain    = mean(tablesRGB_Grain{i, 2}.diff_Green_UACIscore) + std(tablesRGB_Grain{i, 2}.diff_Green_UACIscore);

    minBlue_Grain     = mean(tablesRGB_Grain{i, 2}.diff_Blue_UACIscore) - std(tablesRGB_Grain{i, 2}.diff_Blue_UACIscore);
    maxBlue_Grain     = mean(tablesRGB_Grain{i, 2}.diff_Blue_UACIscore) + std(tablesRGB_Grain{i, 2}.diff_Blue_UACIscore);
    
    
    % MICKEY
    
    minRed_Mickey      = mean(tablesRGB_Mickey{i, 2}.diff_Red_UACIscore) - std(tablesRGB_Mickey{i, 2}.diff_Red_UACIscore);
    maxRed_Mickey      = mean(tablesRGB_Mickey{i, 2}.diff_Red_UACIscore) + std(tablesRGB_Mickey{i, 2}.diff_Red_UACIscore);

    minGreen_Mickey    = mean(tablesRGB_Mickey{i, 2}.diff_Green_UACIscore) - std(tablesRGB_Mickey{i, 2}.diff_Green_UACIscore);
    maxGreen_Mickey    = mean(tablesRGB_Mickey{i, 2}.diff_Green_UACIscore) + std(tablesRGB_Mickey{i, 2}.diff_Green_UACIscore);

    minBlue_Mickey     = mean(tablesRGB_Mickey{i, 2}.diff_Blue_UACIscore) - std(tablesRGB_Mickey{i, 2}.diff_Blue_UACIscore);
    maxBlue_Mickey     = mean(tablesRGB_Mickey{i, 2}.diff_Blue_UACIscore) + std(tablesRGB_Mickey{i, 2}.diff_Blue_UACIscore);
    
    
    % Verifies if the minimum values are greather or equal then all low p-values limits
    % and if the maximum value is less then or equal to all high p-values limits, in this 
    % case the comparation returns "TRUE" or logical "1" value.
     
    % TRIVIUM

        if tablesRGB_Trivium{i, 2}.imW(1) == 256
           
            pvalue_Red_Trivium_005(i)   = (minRed_Trivium   >= pvalueUACI_256_005_down) & (maxRed_Trivium   <= pvalueUACI_256_005_up);
            pvalue_Green_Trivium_005(i) = (minGreen_Trivium >= pvalueUACI_256_005_down) & (maxGreen_Trivium <= pvalueUACI_256_005_up);
            pvalue_Blue_Trivium_005(i)  = (minBlue_Trivium  >= pvalueUACI_256_005_down) & (maxBlue_Trivium  <= pvalueUACI_256_005_up);
            
            pvalue_Red_Trivium_001(i)   = (minRed_Trivium   >= pvalueUACI_256_001_down) & (maxRed_Trivium   <= pvalueUACI_256_001_up);
            pvalue_Green_Trivium_001(i) = (minGreen_Trivium >= pvalueUACI_256_001_down) & (maxGreen_Trivium <= pvalueUACI_256_001_up);
            pvalue_Blue_Trivium_001(i)  = (minBlue_Trivium  >= pvalueUACI_256_001_down) & (maxBlue_Trivium  <= pvalueUACI_256_001_up);
            
            pvalue_Red_Trivium_0001(i)   = (minRed_Trivium   >= pvalueUACI_256_0001_down) & (maxRed_Trivium   <= pvalueUACI_256_0001_up);
            pvalue_Green_Trivium_0001(i) = (minGreen_Trivium >= pvalueUACI_256_0001_down) & (maxGreen_Trivium <= pvalueUACI_256_0001_up);
            pvalue_Blue_Trivium_0001(i)  = (minBlue_Trivium  >= pvalueUACI_256_0001_down) & (maxBlue_Trivium  <= pvalueUACI_256_0001_up);
            
        elseif tablesRGB_Trivium{i, 2}.imW(i) == 512
            
            pvalue_Red_Trivium_005(i)   = (minRed_Trivium   >= pvalueUACI_512_005_down) & (maxRed_Trivium   <= pvalueUACI_512_005_up);
            pvalue_Green_Trivium_005(i) = (minGreen_Trivium >= pvalueUACI_512_005_down) & (maxGreen_Trivium <= pvalueUACI_512_005_up);
            pvalue_Blue_Trivium_005(i)  = (minBlue_Trivium  >= pvalueUACI_512_005_down) & (maxBlue_Trivium  <= pvalueUACI_512_005_up);
            
            pvalue_Red_Trivium_001(i)   = (minRed_Trivium   >= pvalueUACI_512_001_down) & (maxRed_Trivium   <= pvalueUACI_512_001_up);
            pvalue_Green_Trivium_001(i) = (minGreen_Trivium >= pvalueUACI_512_001_down) & (maxGreen_Trivium <= pvalueUACI_512_001_up);
            pvalue_Blue_Trivium_001(i)  = (minBlue_Trivium  >= pvalueUACI_512_001_down) & (maxBlue_Trivium  <= pvalueUACI_512_001_up);
            
            pvalue_Red_Trivium_0001(i)   = (minRed_Trivium   >= pvalueUACI_512_0001_down) & (maxRed_Trivium   <= pvalueUACI_512_0001_up);
            pvalue_Green_Trivium_0001(i) = (minGreen_Trivium >= pvalueUACI_512_0001_down) & (maxGreen_Trivium <= pvalueUACI_512_0001_up);
            pvalue_Blue_Trivium_0001(i)  = (minBlue_Trivium  >= pvalueUACI_512_0001_down) & (maxBlue_Trivium  <= pvalueUACI_512_0001_up);
            
        elseif tablesRGB_Trivium{i, 2}.imW(i) == 1024
            
            pvalue_Red_Trivium_005(i)   = (minRed_Trivium   >= pvalueUACI_1024_005_down) & (maxRed_Trivium   <= pvalueUACI_1024_005_up);
            pvalue_Green_Trivium_005(i) = (minGreen_Trivium >= pvalueUACI_1024_005_down) & (maxGreen_Trivium <= pvalueUACI_1024_005_up);
            pvalue_Blue_Trivium_005(i)  = (minBlue_Trivium  >= pvalueUACI_1024_005_down) & (maxBlue_Trivium  <= pvalueUACI_1024_005_up);
            
            pvalue_Red_Trivium_001(i)   = (minRed_Trivium   >= pvalueUACI_1024_001_down) & (maxRed_Trivium   <= pvalueUACI_1024_001_up);
            pvalue_Green_Trivium_001(i) = (minGreen_Trivium >= pvalueUACI_1024_001_down) & (maxGreen_Trivium <= pvalueUACI_1024_001_up);
            pvalue_Blue_Trivium_001(i)  = (minBlue_Trivium  >= pvalueUACI_1024_001_down) & (maxBlue_Trivium  <= pvalueUACI_1024_001_up);
            
            pvalue_Red_Trivium_0001(i)   = (minRed_Trivium   >= pvalueUACI_1024_0001_down) & (maxRed_Trivium   <= pvalueUACI_1024_0001_up);
            pvalue_Green_Trivium_0001(i) = (minGreen_Trivium >= pvalueUACI_1024_0001_down) & (maxGreen_Trivium <= pvalueUACI_1024_0001_up);
            pvalue_Blue_Trivium_0001(i)  = (minBlue_Trivium  >= pvalueUACI_1024_0001_down) & (maxBlue_Trivium  <= pvalueUACI_1024_0001_up);
            
        end
    
        
    % GRAIN

        if tablesRGB_Trivium{i, 2}.imW(1) == 256
           
            pvalue_Red_Grain_005(i)   = (minRed_Grain   >= pvalueUACI_256_005_down) & (maxRed_Grain   <= pvalueUACI_256_005_up);
            pvalue_Green_Grain_005(i) = (minGreen_Grain >= pvalueUACI_256_005_down) & (maxGreen_Grain <= pvalueUACI_256_005_up);
            pvalue_Blue_Grain_005(i)  = (minBlue_Grain  >= pvalueUACI_256_005_down) & (maxBlue_Grain  <= pvalueUACI_256_005_up);
            
            pvalue_Red_Grain_001(i)   = (minRed_Grain   >= pvalueUACI_256_001_down) & (maxRed_Grain   <= pvalueUACI_256_001_up);
            pvalue_Green_Grain_001(i) = (minGreen_Grain >= pvalueUACI_256_001_down) & (maxGreen_Grain <= pvalueUACI_256_001_up);
            pvalue_Blue_Grain_001(i)  = (minBlue_Grain  >= pvalueUACI_256_001_down) & (maxBlue_Grain  <= pvalueUACI_256_001_up);
            
            pvalue_Red_Grain_0001(i)   = (minRed_Grain   >= pvalueUACI_256_0001_down) & (maxRed_Grain   <= pvalueUACI_256_0001_up);
            pvalue_Green_Grain_0001(i) = (minGreen_Grain >= pvalueUACI_256_0001_down) & (maxGreen_Grain <= pvalueUACI_256_0001_up);
            pvalue_Blue_Grain_0001(i)  = (minBlue_Grain  >= pvalueUACI_256_0001_down) & (maxBlue_Grain  <= pvalueUACI_256_0001_up);
            
        elseif tablesRGB_Grain{i, 2}.imW(i) == 512
            
            pvalue_Red_Grain_005(i)   = (minRed_Grain   >= pvalueUACI_512_005_down) & (maxRed_Grain   <= pvalueUACI_512_005_up);
            pvalue_Green_Grain_005(i) = (minGreen_Grain >= pvalueUACI_512_005_down) & (maxGreen_Grain <= pvalueUACI_512_005_up);
            pvalue_Blue_Grain_005(i)  = (minBlue_Grain  >= pvalueUACI_512_005_down) & (maxBlue_Grain  <= pvalueUACI_512_005_up);
            
            pvalue_Red_Grain_001(i)   = (minRed_Grain   >= pvalueUACI_512_001_down) & (maxRed_Grain   <= pvalueUACI_512_001_up);
            pvalue_Green_Grain_001(i) = (minGreen_Grain >= pvalueUACI_512_001_down) & (maxGreen_Grain <= pvalueUACI_512_001_up);
            pvalue_Blue_Grain_001(i)  = (minBlue_Grain  >= pvalueUACI_512_001_down) & (maxBlue_Grain  <= pvalueUACI_512_001_up);
            
            pvalue_Red_Grain_0001(i)   = (minRed_Grain   >= pvalueUACI_512_0001_down) & (maxRed_Grain   <= pvalueUACI_512_0001_up);
            pvalue_Green_Grain_0001(i) = (minGreen_Grain >= pvalueUACI_512_0001_down) & (maxGreen_Grain <= pvalueUACI_512_0001_up);
            pvalue_Blue_Grain_0001(i)  = (minBlue_Grain  >= pvalueUACI_512_0001_down) & (maxBlue_Grain  <= pvalueUACI_512_0001_up);
            
        elseif tablesRGB_Grain{i, 2}.imW(i) == 1024
            
            pvalue_Red_Grain_005(i)   = (minRed_Grain   >= pvalueUACI_1024_005_down) & (maxRed_Grain   <= pvalueUACI_1024_005_up);
            pvalue_Green_Grain_005(i) = (minGreen_Grain >= pvalueUACI_1024_005_down) & (maxGreen_Grain <= pvalueUACI_1024_005_up);
            pvalue_Blue_Grain_005(i)  = (minBlue_Grain  >= pvalueUACI_1024_005_down) & (maxBlue_Grain  <= pvalueUACI_1024_005_up);
            
            pvalue_Red_Grain_001(i)   = (minRed_Grain   >= pvalueUACI_1024_001_down) & (maxRed_Grain   <= pvalueUACI_1024_001_up);
            pvalue_Green_Grain_001(i) = (minGreen_Grain >= pvalueUACI_1024_001_down) & (maxGreen_Grain <= pvalueUACI_1024_001_up);
            pvalue_Blue_Grain_001(i)  = (minBlue_Grain  >= pvalueUACI_1024_001_down) & (maxBlue_Grain  <= pvalueUACI_1024_001_up);
            
            pvalue_Red_Grain_0001(i)   = (minRed_Grain   >= pvalueUACI_1024_0001_down) & (maxRed_Grain   <= pvalueUACI_1024_0001_up);
            pvalue_Green_Grain_0001(i) = (minGreen_Grain >= pvalueUACI_1024_0001_down) & (maxGreen_Grain <= pvalueUACI_1024_0001_up);
            pvalue_Blue_Grain_0001(i)  = (minBlue_Grain  >= pvalueUACI_1024_0001_down) & (maxBlue_Grain  <= pvalueUACI_1024_0001_up);
            
        end

        
    % MICKEY
        
        if tablesRGB_Mickey{i, 2}.imW(1) == 256
           
            pvalue_Red_Mickey_005(i)   = (minRed_Mickey   >= pvalueUACI_256_005_down) & (maxRed_Mickey   <= pvalueUACI_256_005_up);
            pvalue_Green_Mickey_005(i) = (minGreen_Mickey >= pvalueUACI_256_005_down) & (maxGreen_Mickey <= pvalueUACI_256_005_up);
            pvalue_Blue_Mickey_005(i)  = (minBlue_Mickey  >= pvalueUACI_256_005_down) & (maxBlue_Mickey  <= pvalueUACI_256_005_up);
            
            pvalue_Red_Mickey_001(i)   = (minRed_Mickey   >= pvalueUACI_256_001_down) & (maxRed_Mickey   <= pvalueUACI_256_001_up);
            pvalue_Green_Mickey_001(i) = (minGreen_Mickey >= pvalueUACI_256_001_down) & (maxGreen_Mickey <= pvalueUACI_256_001_up);
            pvalue_Blue_Mickey_001(i)  = (minBlue_Mickey  >= pvalueUACI_256_001_down) & (maxBlue_Mickey  <= pvalueUACI_256_001_up);
            
            pvalue_Red_Mickey_0001(i)   = (minRed_Mickey   >= pvalueUACI_256_0001_down) & (maxRed_Mickey   <= pvalueUACI_256_0001_up);
            pvalue_Green_Mickey_0001(i) = (minGreen_Mickey >= pvalueUACI_256_0001_down) & (maxGreen_Mickey <= pvalueUACI_256_0001_up);
            pvalue_Blue_Mickey_0001(i)  = (minBlue_Mickey  >= pvalueUACI_256_0001_down) & (maxBlue_Mickey  <= pvalueUACI_256_0001_up);
            
        elseif tablesRGB_Mickey{i, 2}.imW(i) == 512
            
            pvalue_Red_Mickey_005(i)   = (minRed_Mickey   >= pvalueUACI_512_005_down) & (maxRed_Mickey   <= pvalueUACI_512_005_up);
            pvalue_Green_Mickey_005(i) = (minGreen_Mickey >= pvalueUACI_512_005_down) & (maxGreen_Mickey <= pvalueUACI_512_005_up);
            pvalue_Blue_Mickey_005(i)  = (minBlue_Mickey  >= pvalueUACI_512_005_down) & (maxBlue_Mickey  <= pvalueUACI_512_005_up);
            
            pvalue_Red_Mickey_001(i)   = (minRed_Mickey   >= pvalueUACI_512_001_down) & (maxRed_Mickey   <= pvalueUACI_512_001_up);
            pvalue_Green_Mickey_001(i) = (minGreen_Mickey >= pvalueUACI_512_001_down) & (maxGreen_Mickey <= pvalueUACI_512_001_up);
            pvalue_Blue_Mickey_001(i)  = (minBlue_Mickey  >= pvalueUACI_512_001_down) & (maxBlue_Mickey  <= pvalueUACI_512_001_up);
            
            pvalue_Red_Mickey_0001(i)   = (minRed_Mickey   >= pvalueUACI_512_0001_down) & (maxRed_Mickey   <= pvalueUACI_512_0001_up);
            pvalue_Green_Mickey_0001(i) = (minGreen_Mickey >= pvalueUACI_512_0001_down) & (maxGreen_Mickey <= pvalueUACI_512_0001_up);
            pvalue_Blue_Mickey_0001(i)  = (minBlue_Mickey  >= pvalueUACI_512_0001_down) & (maxBlue_Mickey  <= pvalueUACI_512_0001_up);
            
        elseif tablesRGB_Mickey{i, 2}.imW(i) == 1024
            
            pvalue_Red_Mickey_005(i)   = (minRed_Mickey   >= pvalueUACI_1024_005_down) & (maxRed_Mickey   <= pvalueUACI_1024_005_up);
            pvalue_Green_Mickey_005(i) = (minGreen_Mickey >= pvalueUACI_1024_005_down) & (maxGreen_Mickey <= pvalueUACI_1024_005_up);
            pvalue_Blue_Mickey_005(i)  = (minBlue_Mickey  >= pvalueUACI_1024_005_down) & (maxBlue_Mickey  <= pvalueUACI_1024_005_up);
            
            pvalue_Red_Mickey_001(i)   = (minRed_Mickey   >= pvalueUACI_1024_001_down) & (maxRed_Mickey   <= pvalueUACI_1024_001_up);
            pvalue_Green_Mickey_001(i) = (minGreen_Mickey >= pvalueUACI_1024_001_down) & (maxGreen_Mickey <= pvalueUACI_1024_001_up);
            pvalue_Blue_Mickey_001(i)  = (minBlue_Mickey  >= pvalueUACI_1024_001_down) & (maxBlue_Mickey  <= pvalueUACI_1024_001_up);
            
            pvalue_Red_Mickey_0001(i)   = (minRed_Mickey   >= pvalueUACI_1024_0001_down) & (maxRed_Mickey   <= pvalueUACI_1024_0001_up);
            pvalue_Green_Mickey_0001(i) = (minGreen_Mickey >= pvalueUACI_1024_0001_down) & (maxGreen_Mickey <= pvalueUACI_1024_0001_up);
            pvalue_Blue_Mickey_0001(i)  = (minBlue_Mickey  >= pvalueUACI_1024_0001_down) & (maxBlue_Mickey  <= pvalueUACI_1024_0001_up);
            
        end
    
end



% Runs the test for all grayscale images.
for i = 1:qtFilesGray
    
    % Gets the min and max value founded in all executions of all imagens for
    % each cryptosystem. This minimum value is calculated by subtracting the
    % mean value to the standard deviation, the maximum value is calculated by
    % adding the mean value to the standard deviation.
    
    % TRIVIUM
    
    minGray_Trivium      = mean(tablesGray_Trivium{i, 2}.diff_UACIscore) - std(tablesGray_Trivium{i, 2}.diff_UACIscore);
    maxGray_Trivium      = mean(tablesGray_Trivium{i, 2}.diff_UACIscore) + std(tablesGray_Trivium{i, 2}.diff_UACIscore);
    
    
    % GRAIN
    
    minGray_Grain      = mean(tablesGray_Grain{i, 2}.diff_UACIscore) - std(tablesGray_Grain{i, 2}.diff_UACIscore);
    maxGray_Grain      = mean(tablesGray_Grain{i, 2}.diff_UACIscore) + std(tablesGray_Grain{i, 2}.diff_UACIscore);
    
    
    % MICKEY
    
    minGray_Mickey      = mean(tablesGray_Mickey{i, 2}.diff_UACIscore) - std(tablesGray_Mickey{i, 2}.diff_UACIscore);
    maxGray_Mickey      = mean(tablesGray_Mickey{i, 2}.diff_UACIscore) + std(tablesGray_Mickey{i, 2}.diff_UACIscore);
    
    
    
    % Verifies if the minimum values are greather or equal then all low p-values limits
    % and if the maximum value is less then or equal to all high p-values limits, in this 
    % case the comparation returns "TRUE" or logical "1" value.
    
    % TRIVIUM

        if tablesGray_Trivium{i, 2}.imW(1) == 256
           
            pvalue_Gray_Trivium_005(i)    = (minGray_Trivium   >= pvalueUACI_256_005_down)  & (maxGray_Trivium   <= pvalueUACI_256_005_up);
            pvalue_Gray_Trivium_001(i)    = (minGray_Trivium   >= pvalueUACI_256_001_down)  & (maxGray_Trivium   <= pvalueUACI_256_001_up);
            pvalue_Gray_Trivium_0001(i)   = (minGray_Trivium   >= pvalueUACI_256_0001_down) & (maxGray_Trivium   <= pvalueUACI_256_0001_up);
            
        elseif tablesGray_Trivium{i, 2}.imW(i) == 512
            
            pvalue_Gray_Trivium_005(i)    = (minGray_Trivium   >= pvalueUACI_512_005_down)  & (maxGray_Trivium   <= pvalueUACI_512_005_up);
            pvalue_Gray_Trivium_001(i)    = (minGray_Trivium   >= pvalueUACI_512_001_down)  & (maxGray_Trivium   <= pvalueUACI_512_001_up);
            pvalue_Gray_Trivium_0001(i)   = (minGray_Trivium   >= pvalueUACI_512_0001_down) & (maxGray_Trivium   <= pvalueUACI_512_0001_up);
            
        elseif tablesGray_Trivium{i, 2}.imW(i) == 1024
            
            pvalue_Gray_Trivium_005(i)    = (minGray_Trivium   >= pvalueUACI_1024_005_down)  & (maxGray_Trivium   <= pvalueUACI_1024_005_up);
            pvalue_Gray_Trivium_001(i)    = (minGray_Trivium   >= pvalueUACI_1024_001_down)  & (maxGray_Trivium   <= pvalueUACI_1024_001_up);
            pvalue_Gray_Trivium_0001(i)   = (minGray_Trivium   >= pvalueUACI_1024_0001_down) & (maxGray_Trivium   <= pvalueUACI_1024_0001_up);
            
        end
    
        
    % GRAIN

        if tablesGray_Grain{i, 2}.imW(1) == 256
           
            pvalue_Gray_Grain_005(i)    = (minGray_Grain   >= pvalueUACI_256_005_down)  & (maxGray_Grain   <= pvalueUACI_256_005_up);
            pvalue_Gray_Grain_001(i)    = (minGray_Grain   >= pvalueUACI_256_001_down)  & (maxGray_Grain   <= pvalueUACI_256_001_up);
            pvalue_Gray_Grain_0001(i)   = (minGray_Grain   >= pvalueUACI_256_0001_down) & (maxGray_Grain   <= pvalueUACI_256_0001_up);
            
        elseif tablesGray_Grain{i, 2}.imW(i) == 512
            
            pvalue_Gray_Grain_005(i)    = (minGray_Grain   >= pvalueUACI_512_005_down)  & (maxGray_Grain   <= pvalueUACI_512_005_up);
            pvalue_Gray_Grain_001(i)    = (minGray_Grain   >= pvalueUACI_512_001_down)  & (maxGray_Grain   <= pvalueUACI_512_001_up);
            pvalue_Gray_Grain_0001(i)   = (minGray_Grain   >= pvalueUACI_512_0001_down) & (maxGray_Grain   <= pvalueUACI_512_0001_up);
            
        elseif tablesGray_Grain{i, 2}.imW(i) == 1024
            
            pvalue_Gray_Grain_005(i)    = (minGray_Grain   >= pvalueUACI_1024_005_down)  & (maxGray_Grain   <= pvalueUACI_1024_005_up);
            pvalue_Gray_Grain_001(i)    = (minGray_Grain   >= pvalueUACI_1024_001_down)  & (maxGray_Grain   <= pvalueUACI_1024_001_up);
            pvalue_Gray_Grain_0001(i)   = (minGray_Grain   >= pvalueUACI_1024_0001_down) & (maxGray_Grain   <= pvalueUACI_1024_0001_up);
            
        end

        
    % MICKEY

        if tablesGray_Mickey{i, 2}.imW(1) == 256
           
            pvalue_Gray_Mickey_005(i)    = (minGray_Mickey   >= pvalueUACI_256_005_down)  & (maxGray_Mickey   <= pvalueUACI_256_005_up);
            pvalue_Gray_Mickey_001(i)    = (minGray_Mickey   >= pvalueUACI_256_001_down)  & (maxGray_Mickey   <= pvalueUACI_256_001_up);
            pvalue_Gray_Mickey_0001(i)   = (minGray_Mickey   >= pvalueUACI_256_0001_down) & (maxGray_Mickey   <= pvalueUACI_256_0001_up);
            
        elseif tablesGray_Mickey{i, 2}.imW(i) == 512
            
            pvalue_Gray_Mickey_005(i)    = (minGray_Mickey   >= pvalueUACI_512_005_down)  & (maxGray_Mickey   <= pvalueUACI_512_005_up);
            pvalue_Gray_Mickey_001(i)    = (minGray_Mickey   >= pvalueUACI_512_001_down)  & (maxGray_Mickey   <= pvalueUACI_512_001_up);
            pvalue_Gray_Mickey_0001(i)   = (minGray_Mickey   >= pvalueUACI_512_0001_down) & (maxGray_Mickey   <= pvalueUACI_512_0001_up);
            
        elseif tablesGray_Mickey{i, 2}.imW(i) == 1024
            
            pvalue_Gray_Mickey_005(i)    = (minGray_Mickey   >= pvalueUACI_1024_005_down)  & (maxGray_Mickey   <= pvalueUACI_1024_005_up);
            pvalue_Gray_Mickey_001(i)    = (minGray_Mickey   >= pvalueUACI_1024_001_down)  & (maxGray_Mickey   <= pvalueUACI_1024_001_up);
            pvalue_Gray_Mickey_0001(i)   = (minGray_Mickey   >= pvalueUACI_1024_0001_down) & (maxGray_Mickey   <= pvalueUACI_1024_0001_up);
            
        end
    
end


% Creates, prints and exports the tables containing the resulting
% processing.

fprintf('\n\n\n');
disp('---------------------------------------------------------------------------------------------------------------------------');
disp('--------------------------------------------- UACI P-VALUE PASS TEST - TRIVIUM --------------------------------------------');
disp('---------------------------------------------------------------------------------------------------------------------------');
fprintf('\n');

% ---------------------------------- RGB ----------------------------------

% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';

% Set the columns.
T.Red_005      = pvalue_Red_Trivium_005';
T.Green_005    = pvalue_Green_Trivium_005';
T.Blue_005     = pvalue_Blue_Trivium_005';

T.Red_001      = pvalue_Red_Trivium_001';
T.Green_001    = pvalue_Green_Trivium_001';
T.Blue_001     = pvalue_Blue_Trivium_001';

T.Red_0001     = pvalue_Red_Trivium_0001';
T.Green_0001   = pvalue_Green_Trivium_0001';
T.Blue_0001    = pvalue_Blue_Trivium_0001';

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'pvalue_UACI_RGB_Trivium.csv']);

% display table.
disp(T);

% --------------------------------- GRAY ----------------------------------

% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';

% Set the columns.
T.pval_005     = pvalue_Gray_Trivium_005';
T.pval_001     = pvalue_Gray_Trivium_001';
T.pval_0001    = pvalue_Gray_Trivium_0001';

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'pvalue_UACI_Gray_Trivium.csv']);

% display table.
disp(T);



fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------');
disp('---------------------------------------------- UACI P-VALUE PASS TEST - GRAIN ---------------------------------------------');
disp('---------------------------------------------------------------------------------------------------------------------------');
fprintf('\n');

% ---------------------------------- RGB ----------------------------------

% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';

% Set the columns.
T.Red_005      = pvalue_Red_Grain_005';
T.Green_005    = pvalue_Green_Grain_005';
T.Blue_005     = pvalue_Blue_Grain_005';

T.Red_001      = pvalue_Red_Grain_001';
T.Green_001    = pvalue_Green_Grain_001';
T.Blue_001     = pvalue_Blue_Grain_001';

T.Red_0001     = pvalue_Red_Grain_0001';
T.Green_0001   = pvalue_Green_Grain_0001';
T.Blue_0001    = pvalue_Blue_Grain_0001';

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'pvalue_UACI_RGB_Grain.csv']);

% display table.
disp(T);

% --------------------------------- GRAY ----------------------------------

% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';

% Set the columns.
T.pval_005     = pvalue_Gray_Grain_005';
T.pval_001     = pvalue_Gray_Grain_001';
T.pval_0001    = pvalue_Gray_Grain_0001';

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'pvalue_UACI_Gray_Grain.csv']);

% display table.
disp(T);



fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------');
disp('--------------------------------------------- UACI P-VALUE PASS TEST - MICKEY ---------------------------------------------');
disp('---------------------------------------------------------------------------------------------------------------------------');
fprintf('\n');

% ---------------------------------- RGB ----------------------------------

% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';

% Set the columns.
T.Red_005      = pvalue_Red_Mickey_005';
T.Green_005    = pvalue_Green_Mickey_005';
T.Blue_005     = pvalue_Blue_Mickey_005';

T.Red_001      = pvalue_Red_Mickey_001';
T.Green_001    = pvalue_Green_Mickey_001';
T.Blue_001     = pvalue_Blue_Mickey_001';

T.Red_0001     = pvalue_Red_Mickey_0001';
T.Green_0001   = pvalue_Green_Mickey_0001';
T.Blue_0001    = pvalue_Blue_Mickey_0001';

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'pvalue_UACI_RGB_Mickey.csv']);

% display table.
disp(T);

% --------------------------------- GRAY ----------------------------------

% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';

% Set the columns.
T.pval_005     = pvalue_Gray_Mickey_005';
T.pval_001     = pvalue_Gray_Mickey_001';
T.pval_0001    = pvalue_Gray_Mickey_0001';

% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'pvalue_UACI_Gray_Mickey.csv']);

% display table.
disp(T);