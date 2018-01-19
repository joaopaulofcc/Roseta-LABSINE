%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#    Script responsible to process differential NPCR metric for data    #
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
%# File: processNPCR.m                                                   #
%#                                                                       #
%# About: This file describe a script which calculates the mean value of #
%#        each NPCR metric and their standard deviation. These values    #
%#        are showed in tables saved in ".csv" files. For all mettrics,  #
%#        the three cryptosystems are analyzed to verify if they respec  #
%#        ts each p-value described in <https://goo.gl/zwNPfw> Wu2011 -  #
%#        NPCR and UACI Randomness Testsfor Image Encryption             #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ------------------------- NPCR P-VALUES LIMITS -------------------------
% ------------------------------------------------------------------------

% 256 px

pvalueNPCR_256_005      = 0.995693; 
pvalueNPCR_256_001      = 0.995527;
pvalueNPCR_256_0001     = 0.995341;

% 512 px

pvalueNPCR_512_005      = 0.995893;
pvalueNPCR_512_001      = 0.995810;
pvalueNPCR_512_0001     = 0.995717;

% 1024 px

pvalueNPCR_1024_005     = 0.995994;
pvalueNPCR_1024_001     = 0.995952;
pvalueNPCR_1024_0001    = 0.995906;



%% -----------------------------------------------------------------------
% -------------------------- NPCR ANALYSIS RGB ---------------------------
% ------------------------------------------------------------------------

% Calculates the differential NPCR for all RGB images.
for i = 1:qtFilesRGB

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        diff_Red_NPCRscore_Trivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.diff_Red_NPCRscore);
        diff_Red_NPCRscore_Trivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.diff_Red_NPCRscore);

        diff_Green_NPCRscore_Trivium_mean{i}    = mean(tablesRGB_Trivium{i, 2}.diff_Green_NPCRscore);
        diff_Green_NPCRscore_Trivium_std{i}     =  std(tablesRGB_Trivium{i, 2}.diff_Green_NPCRscore);

        diff_Blue_NPCRscore_Trivium_mean{i}     = mean(tablesRGB_Trivium{i, 2}.diff_Blue_NPCRscore);
        diff_Blue_NPCRscore_Trivium_std{i}      =  std(tablesRGB_Trivium{i, 2}.diff_Blue_NPCRscore);


    % GRAIN

        diff_Red_NPCRscore_Grain_mean{i}        = mean(tablesRGB_Grain{i, 2}.diff_Red_NPCRscore);
        diff_Red_NPCRscore_Grain_std{i}         =  std(tablesRGB_Grain{i, 2}.diff_Red_NPCRscore);

        diff_Green_NPCRscore_Grain_mean{i}      = mean(tablesRGB_Grain{i, 2}.diff_Green_NPCRscore);
        diff_Green_NPCRscore_Grain_std{i}       =  std(tablesRGB_Grain{i, 2}.diff_Green_NPCRscore);

        diff_Blue_NPCRscore_Grain_mean{i}       = mean(tablesRGB_Grain{i, 2}.diff_Blue_NPCRscore);
        diff_Blue_NPCRscore_Grain_std{i}        =  std(tablesRGB_Grain{i, 2}.diff_Blue_NPCRscore);

    % MICKEY

        diff_Red_NPCRscore_Mickey_mean{i}       = mean(tablesRGB_Mickey{i, 2}.diff_Red_NPCRscore);
        diff_Red_NPCRscore_Mickey_std{i}        =  std(tablesRGB_Mickey{i, 2}.diff_Red_NPCRscore);

        diff_Green_NPCRscore_Mickey_mean{i}     = mean(tablesRGB_Mickey{i, 2}.diff_Green_NPCRscore);
        diff_Green_NPCRscore_Mickey_std{i}      =  std(tablesRGB_Mickey{i, 2}.diff_Green_NPCRscore);

        diff_Blue_NPCRscore_Mickey_mean{i}      = mean(tablesRGB_Mickey{i, 2}.diff_Blue_NPCRscore);
        diff_Blue_NPCRscore_Mickey_std{i}       =  std(tablesRGB_Mickey{i, 2}.diff_Blue_NPCRscore);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM

T.redTrivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Red_NPCRscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Red_NPCRscore_Trivium_std','UniformOutput',false)); 

T.greenTrivium  = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Green_NPCRscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Green_NPCRscore_Trivium_std','UniformOutput',false)); 

T.blueTrivium   = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Blue_NPCRscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Blue_NPCRscore_Trivium_std','UniformOutput',false)); 

% GRAIN

T.redGrain    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Red_NPCRscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Red_NPCRscore_Grain_std','UniformOutput',false)); 

T.greenGrain  = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Green_NPCRscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Green_NPCRscore_Grain_std','UniformOutput',false)); 

T.blueGrain   = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Blue_NPCRscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Blue_NPCRscore_Grain_std','UniformOutput',false));   

% MICKEY

T.redMickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Red_NPCRscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Red_NPCRscore_Mickey_std','UniformOutput',false)); 

T.greenMickey  = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Green_NPCRscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Green_NPCRscore_Mickey_std','UniformOutput',false)); 

T.blueMickey   = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_Blue_NPCRscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_Blue_NPCRscore_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'NPCRRGB.csv']);



%% -----------------------------------------------------------------------
% ---------------------- NPCR ANALYSIS ENTIRE RGB ------------------------
% ------------------------------------------------------------------------

% Calculates the differential NPCR for all RGB images together (no separated channels).
for i = 1:qtFilesRGB

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        diff_RGB_NPCRscore_Trivium_mean{i}      = mean(tablesRGB_Trivium{i, 2}.diff_RGB_NPCRscore);
        diff_RGB_NPCRscore_Trivium_std{i}       =  std(tablesRGB_Trivium{i, 2}.diff_RGB_NPCRscore);

    % GRAIN

        diff_RGB_NPCRscore_Grain_mean{i}        = mean(tablesRGB_Grain{i, 2}.diff_RGB_NPCRscore);
        diff_RGB_NPCRscore_Grain_std{i}         =  std(tablesRGB_Grain{i, 2}.diff_RGB_NPCRscore);

    % MICKEY

        diff_RGB_NPCRscore_Mickey_mean{i}       = mean(tablesRGB_Mickey{i, 2}.diff_RGB_NPCRscore);
        diff_RGB_NPCRscore_Mickey_std{i}        =  std(tablesRGB_Mickey{i, 2}.diff_RGB_NPCRscore);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesRGB';


% TRIVIUM
T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_RGB_NPCRscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_RGB_NPCRscore_Trivium_std','UniformOutput',false)); 

% GRAIN
T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_RGB_NPCRscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_RGB_NPCRscore_Grain_std','UniformOutput',false)); 

% MICKEY
T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_RGB_NPCRscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_RGB_NPCRscore_Mickey_std','UniformOutput',false)); 


% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'NPCRRGBEntire.csv']);



%% -----------------------------------------------------------------------
% -------------------------- NPCR ANALYSIS GRAY --------------------------
% ------------------------------------------------------------------------

% Calculates the differential NPCR for all grayscale images.
for i = 1:qtFilesGray

    % Get the mean value and the standard deviation of all execution samples 
    % for each dataset cipher image.

    % TRIVIUM

        diff_NPCRscore_Trivium_mean{i}      = mean(tablesGray_Trivium{i, 2}.diff_NPCRscore);
        diff_NPCRscore_Trivium_std{i}       =  std(tablesGray_Trivium{i, 2}.diff_NPCRscore);

    % GRAIN

        diff_NPCRscore_Grain_mean{i}      = mean(tablesGray_Grain{i, 2}.diff_NPCRscore);
        diff_NPCRscore_Grain_std{i}       =  std(tablesGray_Grain{i, 2}.diff_NPCRscore);

    % MICKEY

        diff_NPCRscore_Mickey_mean{i}      = mean(tablesGray_Mickey{i, 2}.diff_NPCRscore);
        diff_NPCRscore_Mickey_std{i}       =  std(tablesGray_Mickey{i, 2}.diff_NPCRscore);

end


% Create the table for this metric.
T = table;

% File names.
T.File = fileNamesGray';


% TRIVIUM

T.Trivium    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_NPCRscore_Trivium_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_NPCRscore_Trivium_std','UniformOutput',false)); 

% GRAIN

T.Grain    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_NPCRscore_Grain_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_NPCRscore_Grain_std','UniformOutput',false)); 

% MICKEY

T.Mickey    = strcat(cellfun(@(x) num2str(x,'%.6f'),diff_NPCRscore_Mickey_mean','UniformOutput',false), ...
                 {' '}, char(177), {' '}, ...
                 cellfun(@(x) num2str(x,'%.4f'),diff_NPCRscore_Mickey_std','UniformOutput',false)); 

             
% Save the table for a '.csv' file.
writetable(T, [pathProcessed_GENERAL 'NPCRGray.csv']);



%% -----------------------------------------------------------------------
% ------------------------ NPCR P-VALUES ANALYSIS ------------------------
% ------------------------------------------------------------------------

% Runs the test for all RGB images.
for i = 1:qtFilesRGB
    
    % Gets the min value founded in all executions of all imagens for each
    % cryptosystem. This minimum value is calculated by subtracting the mean
    % value to the standard deviation.
    
    % TRIVIUM
    
    minRed_Trivium      = mean(tablesRGB_Trivium{i, 2}.diff_Red_NPCRscore) - std(tablesRGB_Trivium{i, 2}.diff_Red_NPCRscore);
    maxRed_Trivium      = mean(tablesRGB_Trivium{i, 2}.diff_Red_NPCRscore) + std(tablesRGB_Trivium{i, 2}.diff_Red_NPCRscore);

    minGreen_Trivium    = mean(tablesRGB_Trivium{i, 2}.diff_Green_NPCRscore) - std(tablesRGB_Trivium{i, 2}.diff_Green_NPCRscore);
    maxGreen_Trivium    = mean(tablesRGB_Trivium{i, 2}.diff_Green_NPCRscore) + std(tablesRGB_Trivium{i, 2}.diff_Green_NPCRscore);

    minBlue_Trivium     = mean(tablesRGB_Trivium{i, 2}.diff_Blue_NPCRscore) - std(tablesRGB_Trivium{i, 2}.diff_Blue_NPCRscore);
    maxBlue_Trivium     = mean(tablesRGB_Trivium{i, 2}.diff_Blue_NPCRscore) + std(tablesRGB_Trivium{i, 2}.diff_Blue_NPCRscore);
    
    
    % GRAIN
    
    minRed_Grain      = mean(tablesRGB_Grain{i, 2}.diff_Red_NPCRscore) - std(tablesRGB_Grain{i, 2}.diff_Red_NPCRscore);
    maxRed_Grain      = mean(tablesRGB_Grain{i, 2}.diff_Red_NPCRscore) + std(tablesRGB_Grain{i, 2}.diff_Red_NPCRscore);

    minGreen_Grain    = mean(tablesRGB_Grain{i, 2}.diff_Green_NPCRscore) - std(tablesRGB_Grain{i, 2}.diff_Green_NPCRscore);
    maxGreen_Grain    = mean(tablesRGB_Grain{i, 2}.diff_Green_NPCRscore) + std(tablesRGB_Grain{i, 2}.diff_Green_NPCRscore);

    minBlue_Grain     = mean(tablesRGB_Grain{i, 2}.diff_Blue_NPCRscore) - std(tablesRGB_Grain{i, 2}.diff_Blue_NPCRscore);
    maxBlue_Grain     = mean(tablesRGB_Grain{i, 2}.diff_Blue_NPCRscore) + std(tablesRGB_Grain{i, 2}.diff_Blue_NPCRscore);
    
    
    % MICKEY
    
    minRed_Mickey      = mean(tablesRGB_Mickey{i, 2}.diff_Red_NPCRscore) - std(tablesRGB_Mickey{i, 2}.diff_Red_NPCRscore);
    maxRed_Mickey      = mean(tablesRGB_Mickey{i, 2}.diff_Red_NPCRscore) + std(tablesRGB_Mickey{i, 2}.diff_Red_NPCRscore);

    minGreen_Mickey    = mean(tablesRGB_Mickey{i, 2}.diff_Green_NPCRscore) - std(tablesRGB_Mickey{i, 2}.diff_Green_NPCRscore);
    maxGreen_Mickey    = mean(tablesRGB_Mickey{i, 2}.diff_Green_NPCRscore) + std(tablesRGB_Mickey{i, 2}.diff_Green_NPCRscore);

    minBlue_Mickey     = mean(tablesRGB_Mickey{i, 2}.diff_Blue_NPCRscore) - std(tablesRGB_Mickey{i, 2}.diff_Blue_NPCRscore);
    maxBlue_Mickey     = mean(tablesRGB_Mickey{i, 2}.diff_Blue_NPCRscore) + std(tablesRGB_Mickey{i, 2}.diff_Blue_NPCRscore);
    
    
    % Verifies if the minimum values are greather or equal then all p-values limits
    % in this case the comparation returns "TRUE" or logical "1" value.
    
    % TRIVIUM

        if tablesRGB_Trivium{i, 2}.imW(1) == 256
           
            pvalue_Red_Trivium_005(i)   = minRed_Trivium    >= pvalueNPCR_256_005;
            pvalue_Green_Trivium_005(i) = minGreen_Trivium  >= pvalueNPCR_256_005;
            pvalue_Blue_Trivium_005(i)  = minBlue_Trivium   >= pvalueNPCR_256_005;
            
            pvalue_Red_Trivium_001(i)   = minRed_Trivium    >= pvalueNPCR_256_001;
            pvalue_Green_Trivium_001(i) = minGreen_Trivium  >= pvalueNPCR_256_001;
            pvalue_Blue_Trivium_001(i)  = minBlue_Trivium   >= pvalueNPCR_256_001;
            
            pvalue_Red_Trivium_0001(i)   = minRed_Trivium   >= pvalueNPCR_256_0001;
            pvalue_Green_Trivium_0001(i) = minGreen_Trivium >= pvalueNPCR_256_0001;
            pvalue_Blue_Trivium_0001(i)  = minBlue_Trivium  >= pvalueNPCR_256_0001;
            
        elseif tablesRGB_Trivium{i, 2}.imW(i) == 512
            
            pvalue_Red_Trivium_005(i)   = minRed_Trivium    >= pvalueNPCR_512_005;
            pvalue_Green_Trivium_005(i) = minGreen_Trivium  >= pvalueNPCR_512_005;
            pvalue_Blue_Trivium_005(i)  = minBlue_Trivium   >= pvalueNPCR_512_005;
            
            pvalue_Red_Trivium_001(i)   = minRed_Trivium    >= pvalueNPCR_512_001;
            pvalue_Green_Trivium_001(i) = minGreen_Trivium  >= pvalueNPCR_512_001;
            pvalue_Blue_Trivium_001(i)  = minBlue_Trivium   >= pvalueNPCR_512_001;
            
            pvalue_Red_Trivium_0001(i)   = minRed_Trivium   >= pvalueNPCR_512_0001;
            pvalue_Green_Trivium_0001(i) = minGreen_Trivium >= pvalueNPCR_512_0001;
            pvalue_Blue_Trivium_0001(i)  = minBlue_Trivium  >= pvalueNPCR_512_0001;
            
        elseif tablesRGB_Trivium{i, 2}.imW(i) == 1024
            
            pvalue_Red_Trivium_005(i)   = minRed_Trivium    >= pvalueNPCR_1024_005;
            pvalue_Green_Trivium_005(i) = minGreen_Trivium  >= pvalueNPCR_1024_005;
            pvalue_Blue_Trivium_005(i)  = minBlue_Trivium   >= pvalueNPCR_1024_005;
            
            pvalue_Red_Trivium_001(i)   = minRed_Trivium    >= pvalueNPCR_1024_001;
            pvalue_Green_Trivium_001(i) = minGreen_Trivium  >= pvalueNPCR_1024_001;
            pvalue_Blue_Trivium_001(i)  = minBlue_Trivium   >= pvalueNPCR_1024_001;
            
            pvalue_Red_Trivium_0001(i)   = minRed_Trivium   >= pvalueNPCR_1024_0001;
            pvalue_Green_Trivium_0001(i) = minGreen_Trivium >= pvalueNPCR_1024_0001;
            pvalue_Blue_Trivium_0001(i)  = minBlue_Trivium  >= pvalueNPCR_1024_0001;
            
        end
    
        
    % GRAIN

        if tablesRGB_Grain{i, 2}.imW(i) == 256
           
            pvalue_Red_Grain_005(i)   = minRed_Grain    >= pvalueNPCR_256_005;
            pvalue_Green_Grain_005(i) = minGreen_Grain  >= pvalueNPCR_256_005;
            pvalue_Blue_Grain_005(i)  = minBlue_Grain   >= pvalueNPCR_256_005;
            
            pvalue_Red_Grain_001(i)   = minRed_Grain    >= pvalueNPCR_256_001;
            pvalue_Green_Grain_001(i) = minGreen_Grain  >= pvalueNPCR_256_001;
            pvalue_Blue_Grain_001(i)  = minBlue_Grain   >= pvalueNPCR_256_001;
            
            pvalue_Red_Grain_0001(i)   = minRed_Grain   >= pvalueNPCR_256_0001;
            pvalue_Green_Grain_0001(i) = minGreen_Grain >= pvalueNPCR_256_0001;
            pvalue_Blue_Grain_0001(i)  = minBlue_Grain  >= pvalueNPCR_256_0001;
            
        elseif tablesRGB_Grain{i, 2}.imW(i) == 512
            
            pvalue_Red_Grain_005(i)   = minRed_Grain    >= pvalueNPCR_512_005;
            pvalue_Green_Grain_005(i) = minGreen_Grain  >= pvalueNPCR_512_005;
            pvalue_Blue_Grain_005(i)  = minBlue_Grain   >= pvalueNPCR_512_005;
            
            pvalue_Red_Grain_001(i)   = minRed_Grain    >= pvalueNPCR_512_001;
            pvalue_Green_Grain_001(i) = minGreen_Grain  >= pvalueNPCR_512_001;
            pvalue_Blue_Grain_001(i)  = minBlue_Grain   >= pvalueNPCR_512_001;
            
            pvalue_Red_Grain_0001(i)   = minRed_Grain   >= pvalueNPCR_512_0001;
            pvalue_Green_Grain_0001(i) = minGreen_Grain >= pvalueNPCR_512_0001;
            pvalue_Blue_Grain_0001(i)  = minBlue_Grain  >= pvalueNPCR_512_0001;
            
        elseif tablesRGB_Grain{i, 2}.imW(i) == 1024
            
            pvalue_Red_Grain_005(i)   = minRed_Grain    >= pvalueNPCR_1024_005;
            pvalue_Green_Grain_005(i) = minGreen_Grain  >= pvalueNPCR_1024_005;
            pvalue_Blue_Grain_005(i)  = minBlue_Grain   >= pvalueNPCR_1024_005;
            
            pvalue_Red_Grain_001(i)   = minRed_Grain    >= pvalueNPCR_1024_001;
            pvalue_Green_Grain_001(i) = minGreen_Grain  >= pvalueNPCR_1024_001;
            pvalue_Blue_Grain_001(i)  = minBlue_Grain   >= pvalueNPCR_1024_001;
            
            pvalue_Red_Grain_0001(i)   = minRed_Grain   >= pvalueNPCR_1024_0001;
            pvalue_Green_Grain_0001(i) = minGreen_Grain >= pvalueNPCR_1024_0001;
            pvalue_Blue_Grain_0001(i)  = minBlue_Grain  >= pvalueNPCR_1024_0001;
            
        end

        
    % MICKEY

        if tablesRGB_Mickey{i, 2}.imW(i) == 256
           
            pvalue_Red_Mickey_005(i)   = minRed_Mickey    >= pvalueNPCR_256_005;
            pvalue_Green_Mickey_005(i) = minGreen_Mickey  >= pvalueNPCR_256_005;
            pvalue_Blue_Mickey_005(i)  = minBlue_Mickey   >= pvalueNPCR_256_005;
            
            pvalue_Red_Mickey_001(i)   = minRed_Mickey    >= pvalueNPCR_256_001;
            pvalue_Green_Mickey_001(i) = minGreen_Mickey  >= pvalueNPCR_256_001;
            pvalue_Blue_Mickey_001(i)  = minBlue_Mickey   >= pvalueNPCR_256_001;
            
            pvalue_Red_Mickey_0001(i)   = minRed_Mickey   >= pvalueNPCR_256_0001;
            pvalue_Green_Mickey_0001(i) = minGreen_Mickey >= pvalueNPCR_256_0001;
            pvalue_Blue_Mickey_0001(i)  = minBlue_Mickey  >= pvalueNPCR_256_0001;
            
        elseif tablesRGB_Mickey{i, 2}.imW(i) == 512
            
            pvalue_Red_Mickey_005(i)   = minRed_Mickey    >= pvalueNPCR_512_005;
            pvalue_Green_Mickey_005(i) = minGreen_Mickey  >= pvalueNPCR_512_005;
            pvalue_Blue_Mickey_005(i)  = minBlue_Mickey   >= pvalueNPCR_512_005;
            
            pvalue_Red_Mickey_001(i)   = minRed_Mickey    >= pvalueNPCR_512_001;
            pvalue_Green_Mickey_001(i) = minGreen_Mickey  >= pvalueNPCR_512_001;
            pvalue_Blue_Mickey_001(i)  = minBlue_Mickey   >= pvalueNPCR_512_001;
            
            pvalue_Red_Mickey_0001(i)   = minRed_Mickey   >= pvalueNPCR_512_0001;
            pvalue_Green_Mickey_0001(i) = minGreen_Mickey >= pvalueNPCR_512_0001;
            pvalue_Blue_Mickey_0001(i)  = minBlue_Mickey  >= pvalueNPCR_512_0001;
            
        elseif tablesRGB_Mickey{i, 2}.imW(i) == 1024
            
            pvalue_Red_Mickey_005(i)   = minRed_Mickey    >= pvalueNPCR_1024_005;
            pvalue_Green_Mickey_005(i) = minGreen_Mickey  >= pvalueNPCR_1024_005;
            pvalue_Blue_Mickey_005(i)  = minBlue_Mickey   >= pvalueNPCR_1024_005;
            
            pvalue_Red_Mickey_001(i)   = minRed_Mickey    >= pvalueNPCR_1024_001;
            pvalue_Green_Mickey_001(i) = minGreen_Mickey  >= pvalueNPCR_1024_001;
            pvalue_Blue_Mickey_001(i)  = minBlue_Mickey   >= pvalueNPCR_1024_001;
            
            pvalue_Red_Mickey_0001(i)   = minRed_Mickey   >= pvalueNPCR_1024_0001;
            pvalue_Green_Mickey_0001(i) = minGreen_Mickey >= pvalueNPCR_1024_0001;
            pvalue_Blue_Mickey_0001(i)  = minBlue_Mickey  >= pvalueNPCR_1024_0001;
            
        end
    
end



% Runs the test for all grayscale images.
for i = 1:qtFilesGray
    
    % Gets the min value founded in all executions of all imagens for each
    % cryptosystem. This minimum value is calculated by subtracting the mean
    % value to the standard deviation.
    
    % TRIVIUM
    
    minGray_Trivium    = mean(tablesGray_Trivium{i, 2}.diff_NPCRscore) - std(tablesGray_Trivium{i, 2}.diff_NPCRscore);    
    
    % GRAIN
    
    minGray_Grain      = mean(tablesGray_Grain{i, 2}.diff_NPCRscore) - std(tablesGray_Grain{i, 2}.diff_NPCRscore);    
    
    % MICKEY
    
    minGray_Mickey     = mean(tablesGray_Mickey{i, 2}.diff_NPCRscore) - std(tablesGray_Mickey{i, 2}.diff_NPCRscore);
    
    
    
    % Verifies if the minimum values are greather or equal then all p-values limits,
    % in this case the comparation returns "TRUE" or logical "1" value.
    
    
    % TRIVIUM

        if tablesGray_Trivium{i, 2}.imW(1) == 256
           
            pvalue_Gray_Trivium_005(i)   = minGray_Trivium >= pvalueNPCR_256_005;            
            pvalue_Gray_Trivium_001(i)   = minGray_Trivium >= pvalueNPCR_256_001;            
            pvalue_Gray_Trivium_0001(i)  = minGray_Trivium >= pvalueNPCR_256_0001;
            
        elseif tablesGray_Trivium{i, 2}.imW(i) == 512
            
            pvalue_Gray_Trivium_005(i)   = minGray_Trivium >= pvalueNPCR_512_005;            
            pvalue_Gray_Trivium_001(i)   = minGray_Trivium >= pvalueNPCR_512_001;            
            pvalue_Gray_Trivium_0001(i)  = minGray_Trivium >= pvalueNPCR_512_0001;
            
        elseif tablesGray_Trivium{i, 2}.imW(i) == 1024
            
            pvalue_Gray_Trivium_005(i)   = minGray_Trivium >= pvalueNPCR_1024_005;            
            pvalue_Gray_Trivium_001(i)   = minGray_Trivium >= pvalueNPCR_1024_001;            
            pvalue_Gray_Trivium_0001(i)  = minGray_Trivium >= pvalueNPCR_1024_0001;
            
        end
    
        
    % GRAIN

        if tablesGray_Grain{i, 2}.imW(1) == 256
           
            pvalue_Gray_Grain_005(i)   = minGray_Grain >= pvalueNPCR_256_005;            
            pvalue_Gray_Grain_001(i)   = minGray_Grain >= pvalueNPCR_256_001;            
            pvalue_Gray_Grain_0001(i)  = minGray_Grain >= pvalueNPCR_256_0001;
            
        elseif tablesGray_Grain{i, 2}.imW(i) == 512
            
            pvalue_Gray_Grain_005(i)   = minGray_Grain >= pvalueNPCR_512_005;            
            pvalue_Gray_Grain_001(i)   = minGray_Grain >= pvalueNPCR_512_001;            
            pvalue_Gray_Grain_0001(i)  = minGray_Grain >= pvalueNPCR_512_0001;
            
        elseif tablesGray_Grain{i, 2}.imW(i) == 1024
            
            pvalue_Gray_Grain_005(i)   = minGray_Grain >= pvalueNPCR_1024_005;            
            pvalue_Gray_Grain_001(i)   = minGray_Grain >= pvalueNPCR_1024_001;            
            pvalue_Gray_Grain_0001(i)  = minGray_Grain >= pvalueNPCR_1024_0001;
            
        end

        
    % MICKEY

        if tablesGray_Mickey{i, 2}.imW(1) == 256
           
            pvalue_Gray_Mickey_005(i)   = minGray_Mickey >= pvalueNPCR_256_005;            
            pvalue_Gray_Mickey_001(i)   = minGray_Mickey >= pvalueNPCR_256_001;            
            pvalue_Gray_Mickey_0001(i)  = minGray_Mickey >= pvalueNPCR_256_0001;
            
        elseif tablesGray_Mickey{i, 2}.imW(i) == 512
            
            pvalue_Gray_Mickey_005(i)   = minGray_Mickey >= pvalueNPCR_512_005;            
            pvalue_Gray_Mickey_001(i)   = minGray_Mickey >= pvalueNPCR_512_001;            
            pvalue_Gray_Mickey_0001(i)  = minGray_Mickey >= pvalueNPCR_512_0001;
            
        elseif tablesGray_Mickey{i, 2}.imW(i) == 1024
            
            pvalue_Gray_Mickey_005(i)   = minGray_Mickey >= pvalueNPCR_1024_005;            
            pvalue_Gray_Mickey_001(i)   = minGray_Mickey >= pvalueNPCR_1024_001;            
            pvalue_Gray_Mickey_0001(i)  = minGray_Mickey >= pvalueNPCR_1024_0001;
            
        end
    
end


% Creates, prints and exports the tables containing the resulting
% processing.

fprintf('\n\n\n');
disp('---------------------------------------------------------------------------------------------------------------------------');
disp('--------------------------------------------- NPCR P-VALUE PASS TEST - TRIVIUM --------------------------------------------');
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
writetable(T, [pathProcessed_GENERAL 'pvalue_NPCR_RGB_Trivium.csv']);

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
writetable(T, [pathProcessed_GENERAL 'pvalue_NPCR_Gray_Trivium.csv']);

% display table.
disp(T);



fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------');
disp('---------------------------------------------- NPCR P-VALUE PASS TEST - GRAIN ---------------------------------------------');
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
writetable(T, [pathProcessed_GENERAL 'pvalue_NPCR_RGB_Grain.csv']);

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
writetable(T, [pathProcessed_GENERAL 'pvalue_NPCR_Gray_Grain.csv']);

% display table.
disp(T);



fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------');
disp('--------------------------------------------- NPCR P-VALUE PASS TEST - MICKEY ---------------------------------------------');
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
writetable(T, [pathProcessed_GENERAL 'pvalue_NPCR_RGB_Mickey.csv']);

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
writetable(T, [pathProcessed_GENERAL 'pvalue_NPCR_Gray_Mickey.csv']);

% display table.
disp(T);