% Clear enviroment variables.
clear all;

pathProcessed_HOME       = 'statistics/processed/';

pathProcessed_GENERAL    = 'statistics/processed/general/CSV/';


%% -----------------------------------------------------------------------
% --------------------------- CONFIGURE PATHS ----------------------------
% ------------------------------------------------------------------------


% TRIVIUM ANALYSIS PATH.

% Path for the processed ".csv" files analysis.
pathProcessed_Trivium    = 'statistics/processed/trivium/';
mkdir(pathProcessed_Trivium);

% Open CSV Files
filenamesRGB_Trivium    = dir(['statistics/raw/trivium/RGB' '/*.csv']);
filenamesGray_Trivium   = dir(['statistics/raw/trivium/Gray' '/*.csv']);

% Get the number of RGB and Gray image files.
qtFilesRGB_Trivium  = length(filenamesRGB_Trivium);
qtFilesGray_Trivium = length(filenamesGray_Trivium);


% GRAIN ANALYSIS PATH.

pathProcessed_Grain    = 'statistics/processed/grain/';
mkdir(pathProcessed_Grain);

filenamesRGB_Grain    = dir(['statistics/raw/grain/RGB' '/*.csv']);
filenamesGray_Grain   = dir(['statistics/raw/grain/Gray' '/*.csv']);

qtFilesRGB_Grain  = length(filenamesRGB_Grain);
qtFilesGray_Grain = length(filenamesGray_Grain);



% MICKEY ANALYSIS PATH.
pathProcessed_Mickey    = 'statistics/processed/mickey/';
mkdir(pathProcessed_Mickey);

filenamesRGB_Mickey    = dir(['statistics/raw/mickey/RGB' '/*.csv']);
filenamesGray_Mickey   = dir(['statistics/raw/mickey/Gray' '/*.csv']);

qtFilesRGB_Mickey  = length(filenamesRGB_Mickey);
qtFilesGray_Mickey = length(filenamesGray_Mickey);


% Checks if the number of ".csv" files for all generator is the same,
% that is, all the dataset images was tested by all the generators.
if (qtFilesRGB_Trivium ~= qtFilesRGB_Grain)  || ...
   (qtFilesRGB_Trivium ~= qtFilesRGB_Mickey) || ...
   (qtFilesRGB_Grain   ~= qtFilesRGB_Mickey)

    error('[ERROR] Number of file for each generator must be the same!');

end


if (qtFilesGray_Trivium ~= qtFilesGray_Grain)  || ...
   (qtFilesGray_Trivium ~= qtFilesGray_Mickey) || ...
   (qtFilesGray_Grain   ~= qtFilesGray_Mickey)

    error('[ERROR] Number of file for each generator must be the same!');

end


% Set the number of RGB and Gray sample files to the same for all
% geneators, because they have the same number of files.
qtFilesRGB     = qtFilesRGB_Trivium;
qtFilesGray    = qtFilesGray_Trivium;