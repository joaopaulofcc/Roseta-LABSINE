 %#########################################################################
 %#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
 %#                                                                       #
 %# 					Analysis Implementations                          #
 %#                                                                       #
 %#     Script responsible for calculate the correlation coeficients      #
 %#                       of a grayscale image.                           #
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
 %# File: correlationGray.m                                               #
 %#                                                                       #
 %# About: This file describe a script which implements the analysis of   #
 %#		   the correlation coeficients of a give grayscale image by means #
 %#        of "corr2" matlab function. This function is equivalent to the #
 %#        formula showed in the literature to perform this analysis. The #
 %#        coeficient is calculated for the horizontal, vertical and diag #
 %#        onal "samples" adjacent pixels in the image.                   #
 %#                                                                       #
 %# INPUTS                                                                #
 %#                                                                       #
 %#     image: the matlab image object which will be analyzed.            #
 %#                                                                       #
 %#     samples : number of adjacent pair of pixels to be considered.     #
 %#                                                                       #
 %# RETURN                                                                #
 %#                                                                       #
 %#     values: array which contains the all the coeficients calculated.  #
 %#                                                                       #
 %#     updateSamples : updated number of adjacent pair of pixels.        #
 %#                                                                       #
 %#     Others returned values represents the arrays for adjacent pixels  #
 %#     generated for each direction, this values will be used in other   #
 %#     scripts to print the graphic representation of the correlation.   #
 %#                                                                       #
 %# OBS:                                                                  #
 %#     This topic is covered in stackoverflow <https://goo.gl/tn7FTi>    #
 %#                                                                       #
 %# 21/12/17 - Lavras - MG                                                #
 %#########################################################################

function [values, xHorz, yHorz, xVert, yVert, xDiag, yDiag, updateSamples] ...
    = correlationGray(image, samples)

    %% --------------------------------------------------------------------

    % Converts the image values to double.
    image = double(image);
    
    % Get the size of the image.
    [heigth, width] = size(image);
    
    % Calculates the maximum number of samples (pair of adjacent pixels)
    % which will be used for the correlation metric. This value is defined
    % as the minimum "xHorz" value of the horizontal, vertical and diagonal
    % correlation, this corresponds to the diagonal "xHorz" value, where
    % its size is equal to the formula below.
    maxSamples = (heigth * width) - (heigth + width);
    
    
    % Checks if the samples parameter is absent, if it is, replace it for
    % the maximum number of samples.
    if isempty(samples)
        
        updateSamples = maxSamples;
        
    % If this parameter isn't absent, is verified if the reported value is
    % valid, that is, the value is less than or equal the "maxSamples"
    % value. If it is valid, "updateSamples" simply get the same value of
    % "samples" parameter, otherwise gets the "maxSamples" value.
    else
        
        if samples > maxSamples;
        
            updateSamples = maxSamples;
        
        else
            
            updateSamples = samples;
            
        end
        
    end    
    
    %% -----------------------------------------------------------------
    % --------------------- HORIZONTAL CORRELATION --------------------- 
    % ------------------------------------------------------------------

    % Select all rows, and columns from 1 to (image width - 1).
    xHorz       = image(:, 1:end-1);         
    % Select all rows, and columns from 2 to (image width).
    yHorz       = image(:, 2:end);         
    
    % Generate a permutation array.                                  
    randIndex   = randperm(numel(xHorz));
    % Get samples first positions in permutation array.
    randIndex   = randIndex(1:updateSamples);   
    
    % Get new pixels values in each position for
    % X and Y, that is, the horizontal pair of pixels.
    xHorz       = xHorz(randIndex);             
    yHorz       = yHorz(randIndex);             
    
    % Calculate the acorrelation coeficient of this
    % two arrays of adjacent pixels.
    corrHorz    = corr2(xHorz(:), yHorz(:));    
                                     
    % OBS: the function corr2 can be replaced by hardcode equation below:
    % (cov(xHorz, yHorz) / ( sqrt(var(xHorz)) * sqrt(var(yHorz))))



    %% -----------------------------------------------------------------
    % ---------------------- VERTICAL CORRELATION ---------------------- 
    % ------------------------------------------------------------------
    
    % Select rows from 1 to image (height - 1) of all columns.
    xVert       = image(1:end-1,:);           
    % Select rows from 2 to (image height) of all columns.
    yVert       = image(2:end,:);             
    
    % Generate a permutation array.                           
    randIndex   = randperm(numel(xVert));       
    % Get samples first positions in permutation array.
    randIndex   = randIndex(1:updateSamples);   
    
    % Get new pixels values in each position for
    % X and Y, that is, the horizontal pair of pixels.
    xVert       = xVert(randIndex);             
    yVert       = yVert(randIndex);             
    
    % Calculate the acorrelation coeficient of this
    % two arrays of adjacent pixels.
    corrVert    = corr2(xVert(:), yVert(:));    
                                                
                                                
                                                
    %% -----------------------------------------------------------------
    % ---------------------- DIAGONAL CORRELATION ---------------------- 
    % ------------------------------------------------------------------
    
    % Select rows from 1 to (image height - 1) of columns 1 to (image width - 1).
    xDiag       = image(1:end-1, 1:end-1);   
    % Select rows from 2 to (image height) of columns 2 to (image width).
    yDiag       = image(2:end,   2:end);   
    
    % Generate a permutation array.                                          
    randIndex   = randperm(numel(xDiag));       
    % Get samples first positions in permutation array.
    randIndex   = randIndex(1:updateSamples);   
    
    % Get new pixels values in each position for
    % X and Y, that is, the horizontal pair of pixels.    
    xDiag       = xDiag(randIndex);             
    yDiag       = yDiag(randIndex);             
    
    % Calculate the acorrelation coeficient of this
    % two arrays of adjacent pixels.
    corrDiag    = corr2(xDiag(:), yDiag(:));    
                                                

    %% --------------------------------------------------------------------    
    
    % Join values of correlation coeficient into a single array for output.
    values = [corrHorz corrVert corrDiag];
    
end