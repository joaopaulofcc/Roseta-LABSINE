%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#   Script responsible for list all the ".csv" files from "statistics   #
%#   /raw" folder and for each one call the correct "importcsv..."       # 
%#   script, the table returned by this script is stored in a general    #
%#   array (arrays of tables)for each cryptosystem.                      #
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
%# File: readFilesCSV.m                                                  #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



%% -----------------------------------------------------------------------
% ------------------------------ READ FILES ------------------------------ 
% ------------------------------------------------------------------------    

% RGB IMAGES

% Read each ".csv" statistics for RGB files to a cell array.
for i = 1:qtFilesRGB

    % Get the current file name.
    currFile_Trivium    = filenamesRGB_Trivium(i).name;
    currFile_Grain      = filenamesRGB_Grain(i).name;
    currFile_Mickey     = filenamesRGB_Mickey(i).name;


    % TRIVIUM

        % Extract the file name wuthout "." and "_" characteres and remove the
        % extension for put in the column #1 of the cell array.
        [~, name, ~] = fileparts(currFile_Trivium);
        name = strrep(name, 'trivium_', '');

        % Put the name and the data of ".csv" file in the correct column.
        tablesRGB_Trivium{i, 1} = name;
        tablesRGB_Trivium{i, 2} = importcsvRGB(currFile_Trivium);


    % GRAIN

        [~, name, ~] = fileparts(currFile_Grain);   
        name = strrep(name, 'grain_', '');

        tablesRGB_Grain{i, 1} = name;
        tablesRGB_Grain{i, 2} = importcsvRGB(currFile_Grain);


    % MICKEY

        [~, name, ~] = fileparts(currFile_Mickey);
        name = strrep(name, 'mickey_', '');

        tablesRGB_Mickey{i, 1} = name;
        tablesRGB_Mickey{i, 2} = importcsvRGB(currFile_Mickey);

end


% GRAY IMAGES

% Read each ".csv" statistics for Gray files to a cell array.
for i = 1:qtFilesGray

    % Get the current file name.
    currFile_Trivium    = filenamesGray_Trivium(i).name;
    currFile_Grain      = filenamesGray_Grain(i).name;
    currFile_Mickey     = filenamesGray_Mickey(i).name;


    % TRIVIUM

        % Extract the file name wuthout "." and "_" characteres and remove the
        % extension for put in the column #1 of the cell array.
        [~, name, ~] = fileparts(currFile_Trivium);
        name = strrep(name, 'trivium_', '');

        % Put the name and the data of ".csv" file in the correct column.
        tablesGray_Trivium{i, 1} = name;
        tablesGray_Trivium{i, 2} = importcsvGRAY(currFile_Trivium);


    % GRAIN

        [~, name, ~] = fileparts(currFile_Grain);   
        name = strrep(name, 'grain_', '');

        tablesGray_Grain{i, 1} = name;
        tablesGray_Grain{i, 2} = importcsvGRAY(currFile_Grain);


    % MICKEY

        [~, name, ~] = fileparts(currFile_Mickey);
        name = strrep(name, 'mickey_', '');

        tablesGray_Mickey{i, 1} = name;
        tablesGray_Mickey{i, 2} = importcsvGRAY(currFile_Mickey);

end