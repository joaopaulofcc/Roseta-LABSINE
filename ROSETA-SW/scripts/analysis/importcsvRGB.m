%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#     Script responsible to import the ".csv" analysis file for RGB     #
%#           images coming from "runAnalysis.m" file execution.          #
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
%# File: importcsvRGB.m                                                  #
%#                                                                       #
%# About: This script is generated automatically by the ".csv" file      #
%#        import tool. Returns a table with the contente of "filename".  #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################



function tableFile = importcsvRGB(filename, startRow, endRow)

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123]);
rawCellColumns = raw(:, [1,2,3,4]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
tableFile = table;
tableFile.script = rawCellColumns(:, 1);
tableFile.Key = rawCellColumns(:, 2);
tableFile.KeyS = rawCellColumns(:, 3);
tableFile.IV = rawCellColumns(:, 4);
tableFile.imW = cell2mat(rawNumericColumns(:, 1));
tableFile.imH = cell2mat(rawNumericColumns(:, 2));
tableFile.imD = cell2mat(rawNumericColumns(:, 3));
tableFile.timeKey = cell2mat(rawNumericColumns(:, 4));
tableFile.tc_Dec2Bin = cell2mat(rawNumericColumns(:, 5));
tableFile.tc_ReshArray = cell2mat(rawNumericColumns(:, 6));
tableFile.tc_XOR = cell2mat(rawNumericColumns(:, 7));
tableFile.tc_ReshapeMatrix1 = cell2mat(rawNumericColumns(:, 8));
tableFile.tcBin2Dec = cell2mat(rawNumericColumns(:, 9));
tableFile.tc_ReshapeMatrix2 = cell2mat(rawNumericColumns(:, 10));
tableFile.tc_totalTime = cell2mat(rawNumericColumns(:, 11));
tableFile.tc_diff_Dec2Bin = cell2mat(rawNumericColumns(:, 12));
tableFile.tc_diff_ReshArray = cell2mat(rawNumericColumns(:, 13));
tableFile.tc_diff_XOR = cell2mat(rawNumericColumns(:, 14));
tableFile.tc_diff_ReshapeMatrix1 = cell2mat(rawNumericColumns(:, 15));
tableFile.tc_diff_Bin2Dec = cell2mat(rawNumericColumns(:, 16));
tableFile.tc_diff_ReshapeMatrix2 = cell2mat(rawNumericColumns(:, 17));
tableFile.tc_diff_totalTime = cell2mat(rawNumericColumns(:, 18));
tableFile.tc_sens_Dec2Bin = cell2mat(rawNumericColumns(:, 19));
tableFile.tc_sens_ReshArray = cell2mat(rawNumericColumns(:, 20));
tableFile.tc_sens_XOR = cell2mat(rawNumericColumns(:, 21));
tableFile.tc_sens_ReshapeMatrix1 = cell2mat(rawNumericColumns(:, 22));
tableFile.tc_sens_Bin2Dec = cell2mat(rawNumericColumns(:, 23));
tableFile.tc_sens_ReshapeMatrix2 = cell2mat(rawNumericColumns(:, 24));
tableFile.tc_sens_totalTime = cell2mat(rawNumericColumns(:, 25));
tableFile.td_Dec2Bin = cell2mat(rawNumericColumns(:, 26));
tableFile.td_ReshArray = cell2mat(rawNumericColumns(:, 27));
tableFile.td_XOR = cell2mat(rawNumericColumns(:, 28));
tableFile.td_ReshapeMatrix1 = cell2mat(rawNumericColumns(:, 29));
tableFile.tdBin2Dec = cell2mat(rawNumericColumns(:, 30));
tableFile.td_ReshapeMatrix2 = cell2mat(rawNumericColumns(:, 31));
tableFile.td_totalTime = cell2mat(rawNumericColumns(:, 32));
tableFile.td_diff_Dec2Bin = cell2mat(rawNumericColumns(:, 33));
tableFile.td_diff_ReshArray = cell2mat(rawNumericColumns(:, 34));
tableFile.td_diff_XOR = cell2mat(rawNumericColumns(:, 35));
tableFile.td_diff_ReshapeMatrix1 = cell2mat(rawNumericColumns(:, 36));
tableFile.td_diff_Bin2Dec = cell2mat(rawNumericColumns(:, 37));
tableFile.td_diff_ReshapeMatrix2 = cell2mat(rawNumericColumns(:, 38));
tableFile.td_diff_totalTime = cell2mat(rawNumericColumns(:, 39));
tableFile.totalTime = cell2mat(rawNumericColumns(:, 40));
tableFile.redIntensityPlain = cell2mat(rawNumericColumns(:, 41));
tableFile.greenIntensityPlain = cell2mat(rawNumericColumns(:, 42));
tableFile.blueIntensityPlain = cell2mat(rawNumericColumns(:, 43));
tableFile.redIntensityCipher = cell2mat(rawNumericColumns(:, 44));
tableFile.greenIntensityCipher = cell2mat(rawNumericColumns(:, 45));
tableFile.blueIntensityCipher = cell2mat(rawNumericColumns(:, 46));
tableFile.redIntensityDecipher = cell2mat(rawNumericColumns(:, 47));
tableFile.greenIntensityDecipher = cell2mat(rawNumericColumns(:, 48));
tableFile.blueIntensityDecipher = cell2mat(rawNumericColumns(:, 49));
tableFile.entropyRGBPlain = cell2mat(rawNumericColumns(:, 50));
tableFile.entropyRGBCipher = cell2mat(rawNumericColumns(:, 51));
tableFile.entropyRGBDecipher = cell2mat(rawNumericColumns(:, 52));
tableFile.entropyRedPlain = cell2mat(rawNumericColumns(:, 53));
tableFile.entropyGreenPlain = cell2mat(rawNumericColumns(:, 54));
tableFile.entropyBluePlain = cell2mat(rawNumericColumns(:, 55));
tableFile.entropyRedCipher = cell2mat(rawNumericColumns(:, 56));
tableFile.entropyGreenCipher = cell2mat(rawNumericColumns(:, 57));
tableFile.entropyBlueCipher = cell2mat(rawNumericColumns(:, 58));
tableFile.entropyRedDecipher = cell2mat(rawNumericColumns(:, 59));
tableFile.entropyGreenDecipher = cell2mat(rawNumericColumns(:, 60));
tableFile.entropyBlueDecipher = cell2mat(rawNumericColumns(:, 61));
tableFile.diff_RGB_NPCRscore = cell2mat(rawNumericColumns(:, 62));
tableFile.diff_RGB_NPCRpval = cell2mat(rawNumericColumns(:, 63));
tableFile.diff_RGB_UACIscore = cell2mat(rawNumericColumns(:, 64));
tableFile.diff_RGB_UACIpval = cell2mat(rawNumericColumns(:, 65));
tableFile.diff_Red_NPCRscore = cell2mat(rawNumericColumns(:, 66));
tableFile.diff_Red_NPCRpval = cell2mat(rawNumericColumns(:, 67));
tableFile.diff_Red_UACIscore = cell2mat(rawNumericColumns(:, 68));
tableFile.diff_Red_UACIpval = cell2mat(rawNumericColumns(:, 69));
tableFile.diff_Green_NPCRscore = cell2mat(rawNumericColumns(:, 70));
tableFile.diff_Green_NPCRpval = cell2mat(rawNumericColumns(:, 71));
tableFile.diff_Green_UACIscore = cell2mat(rawNumericColumns(:, 72));
tableFile.diff_Green_UACIpval = cell2mat(rawNumericColumns(:, 73));
tableFile.diff_Blue_NPCRscore = cell2mat(rawNumericColumns(:, 74));
tableFile.diff_Blue_NPCRpval = cell2mat(rawNumericColumns(:, 75));
tableFile.diff_Blue_UACIscore = cell2mat(rawNumericColumns(:, 76));
tableFile.diff_Blue_UACIpval = cell2mat(rawNumericColumns(:, 77));
tableFile.corr_rgbPlain_H = cell2mat(rawNumericColumns(:, 78));
tableFile.corr_rgbPlain_V = cell2mat(rawNumericColumns(:, 79));
tableFile.corr_rgbPlain_D = cell2mat(rawNumericColumns(:, 80));
tableFile.corr_rgbCipher_H = cell2mat(rawNumericColumns(:, 81));
tableFile.corr_rgbCipher_V = cell2mat(rawNumericColumns(:, 82));
tableFile.corr_rgbCipher_D = cell2mat(rawNumericColumns(:, 83));
tableFile.corr_rgbDecipher_H = cell2mat(rawNumericColumns(:, 84));
tableFile.corr_rgbDecipher_V = cell2mat(rawNumericColumns(:, 85));
tableFile.corr_rgbDecipher_D = cell2mat(rawNumericColumns(:, 86));
tableFile.corr_redPlain_H = cell2mat(rawNumericColumns(:, 87));
tableFile.corr_redPlain_V = cell2mat(rawNumericColumns(:, 88));
tableFile.corr_redPlain_D = cell2mat(rawNumericColumns(:, 89));
tableFile.corr_greenPlain_H = cell2mat(rawNumericColumns(:, 90));
tableFile.corr_greenPlain_V = cell2mat(rawNumericColumns(:, 91));
tableFile.corr_greenPlain_D = cell2mat(rawNumericColumns(:, 92));
tableFile.corr_bluePlain_H = cell2mat(rawNumericColumns(:, 93));
tableFile.corr_bluePlain_V = cell2mat(rawNumericColumns(:, 94));
tableFile.corr_bluePlain_D = cell2mat(rawNumericColumns(:, 95));
tableFile.corr_redCipher_H = cell2mat(rawNumericColumns(:, 96));
tableFile.corr_redCipher_V = cell2mat(rawNumericColumns(:, 97));
tableFile.corr_redCipher_D = cell2mat(rawNumericColumns(:, 98));
tableFile.corr_greenCipher_H = cell2mat(rawNumericColumns(:, 99));
tableFile.corr_greenCipher_V = cell2mat(rawNumericColumns(:, 100));
tableFile.corr_greenCipher_D = cell2mat(rawNumericColumns(:, 101));
tableFile.corr_blueCipher_H = cell2mat(rawNumericColumns(:, 102));
tableFile.corr_blueCipher_V = cell2mat(rawNumericColumns(:, 103));
tableFile.corr_blueCipher_D = cell2mat(rawNumericColumns(:, 104));
tableFile.corr_redDecipher_H = cell2mat(rawNumericColumns(:, 105));
tableFile.corr_redDecipher_V = cell2mat(rawNumericColumns(:, 106));
tableFile.corr_redDecipher_D = cell2mat(rawNumericColumns(:, 107));
tableFile.corr_greenDecipher_H = cell2mat(rawNumericColumns(:, 108));
tableFile.corr_greenDecipher_V = cell2mat(rawNumericColumns(:, 109));
tableFile.corr_greenDecipher_D = cell2mat(rawNumericColumns(:, 110));
tableFile.corr_blueDecipher_H = cell2mat(rawNumericColumns(:, 111));
tableFile.corr_blueDecipher_V = cell2mat(rawNumericColumns(:, 112));
tableFile.corr_blueDecipher_D = cell2mat(rawNumericColumns(:, 113));
tableFile.corr_redKeySensCipher = cell2mat(rawNumericColumns(:, 114));
tableFile.corr_greenKeySensCipher = cell2mat(rawNumericColumns(:, 115));
tableFile.corr_blueKeySensCipher = cell2mat(rawNumericColumns(:, 116));
tableFile.corr_redKeySensDecipher = cell2mat(rawNumericColumns(:, 117));
tableFile.corr_greenKeySensDecipher = cell2mat(rawNumericColumns(:, 118));
tableFile.corr_blueKeySensDecipher = cell2mat(rawNumericColumns(:, 119));

