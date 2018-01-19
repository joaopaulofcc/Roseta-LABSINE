 %#########################################################################
 %#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
 %#                                                                       #
 %# 					Analysis Implementations                          #
 %#                                                                       #
 %#     Script responsible for calculate the correlation coeficients      #
 %#                           of a RGB image.                             #
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
 %# File: correlationRGB.m                                                #
 %#                                                                       #
 %# About: This file describe a script which implements the analysis of   #
 %#		   the correlation coeficients of a give color RGB image by means #
 %#        of "corr2" matlab function. This function is equivalent to the #
 %#        formula showed in the literature to perform this analysis. The #
 %#        coeficient is calculated for the horizontal, vertical and diag #
 %#        onal "updateSamples" adjacent pixels in the image for each of  #
 %#        three col or channel (R, G, B).                                #
 %#                                                                       #
 %# INPUTS                                                                #
 %#                                                                       #
 %#     image: the matlab image object which will be analyzed.            #
 %#                                                                       #
 %#     samples : number of adjacent pair of pixels to be considered.     #
 %#                                                                       #
 %# RETURN                                                                #
 %#                                                                       #
 %#     valuesRGB: array which contains all the coeficients calculated.   #
 %#                 for all (RGB) channels.                               #
 %#                                                                       #
 %#     valuesR: array which contains all the coeficients calculated.     #
 %#                 for the red channel.                                  #
 %#                                                                       #
 %#     valuesG: array which contains all the coeficients calculated.     #
 %#                 for the green channel.                                #
 %#                                                                       #
 %#     valuesB: array which contains all the coeficients calculated.     #
 %#                 for the blue channel.                                 #
 %#                                                                       #
 %#     updateSamples : updated number of adjacent pair of pixels.        #
 %#                                                                       #
 %#     Others returned values represents the arrays for adjacent pixels  #
 %#     generated for each direction of each color channel, this values   #
 %#     will be used in other scripts to print the graphic representation #
 %#     of the correlation.                                               #
 %#                                                                       #
 %# OBS:                                                                  #
 %#     This topic is covered in stackoverflow <https://goo.gl/tn7FTi>    #
 %#                                                                       #
 %# 21/12/17 - Lavras - MG                                                #
 %#########################################################################

function [valuesRGB, valuesR, valuesG, valuesB, ...
          xHorzR, yHorzR, xVertR, yVertR, xDiagR, yDiagR, ...
          xHorzG, yHorzG, xVertG, yVertG, xDiagG, yDiagG, ...
          xHorzB, yHorzB, xVertB, yVertB, xDiagB, yDiagB, ...
          updateSamples] = correlationRGB(image, samples)

    %% --------------------------------------------------------------------
      
    % Convert image values to double.
    image = double(image);
    
    % Get the size of the image.
    [heigth, width, dim] = size(image);
    
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
    
    % Red Channel

    % Select all rows, and columns from 1 to (image width - 1).
    xHorzR      = image(:, 1:end-1, 1);
    % Select all rows, and columns from 2 to (image width).
    yHorzR      = image(:, 2:end,   1);
    
    % Generate a permutation array.  
    randIndex   = randperm(numel(xHorzR));
    % Get updateSamples first positions in permutation array.
    randIndex   = randIndex(1:updateSamples);   
    
    % Get new pixels values in each position for
    % X and Y, that is, the horizontal pair of pixels.
    xHorzR      = xHorzR(randIndex);
    yHorzR      = yHorzR(randIndex);           
    
    % Calculate the acorrelation coeficient of this
    % two arrays of adjacent pixels.
    corrHorzR   = corr2(xHorzR(:), yHorzR(:));  
      
    % OBS: the function corr2 can be replaced by hardcode equation below:
    % (cov(xHorz, yHorz) / ( sqrt(var(xHorz)) * sqrt(var(yHorz))))
    
    % ---------------------
    
    % Green Channel
    
    xHorzG      = image(:, 1:end-1, 2);                
    yHorzG      = image(:, 2:end,   2);                  
    
    %randIndex   = randperm(numel(xHorzG));                                        
    %randIndex   = randIndex(1:updateSamples); 
    
    xHorzG      = xHorzG(randIndex);                 
    yHorzG      = yHorzG(randIndex);                 
    
    corrHorzG   = corr2(xHorzG(:), yHorzG(:));
    
    % ---------------------
    
    % Blue Channel
    
    xHorzB      = image(:, 1:end-1, 3);                
    yHorzB      = image(:, 2:end,   3);                  
    
    %randIndex   = randperm(numel(xHorzB));                                         
    %randIndex   = randIndex(1:updateSamples);
    
    xHorzB      = xHorzB(randIndex);                 
    yHorzB      = yHorzB(randIndex);                 
    
    corrHorzB   = corr2(xHorzB(:), yHorzB(:));
    
    
    % Calculates the all channels horizontal correlation (mean).
    corrHorzRGB   = mean([corrHorzR corrHorzG corrHorzB]);
    
    
    %% -----------------------------------------------------------------
    % ---------------------- VERTICAL CORRELATION ---------------------- 
    % ------------------------------------------------------------------
    
    % Red Channel
    
    % Select rows from 1 to image (height - 1) of all columns.
    xVertR      = image(1:end-1,:,1);
    % Select rows from 2 to (image height) of all columns.
    yVertR      = image(2:end,:,1);
    
    % Generate a permutation array.                           
    randIndex   = randperm(numel(xVertR));
    % Get updateSamples first positions in permutation array.
    randIndex   = randIndex(1:updateSamples);            
    
    % Get new pixels values in each position for
    % X and Y, that is, the horizontal pair of pixels.
    xVertR      = xVertR(randIndex);            
    yVertR      = yVertR(randIndex);            
    
    % Calculate the acorrelation coeficient of this
    % two arrays of adjacent pixels.
    corrVertR   = corr2(xVertR(:), yVertR(:));  
                                                
    % ---------------------
    
    % Green Channel
    
    xVertG      = image(1:end-1,:,2);  
    yVertG      = image(2:end,:,2);    
    
    %randIndex   = randperm(numel(xVertG));  
    %randIndex   = randIndex(1:updateSamples);       
    
    xVertG      = xVertG(randIndex);                
    yVertG      = yVertG(randIndex);                
    
    corrVertG   = corr2(xVertG(:), yVertG(:));
    
    % ---------------------
    
    % Blue Channel
    
    xVertB      = image(1:end-1,:,3);  
    yVertB      = image(2:end,:,3);    
    
    %randIndex   = randperm(numel(xVertB));                                      
    %randIndex   = randIndex(1:updateSamples);       
    
    xVertB      = xVertB(randIndex);                
    yVertB      = yVertB(randIndex);                
    
    corrVertB   = corr2(xVertB(:), yVertB(:));
    
    
    % Calculates the all channels vertical correlation (mean).
    corrVertRGB   = mean([corrVertR corrVertG corrVertB]);
    
    
    %% -----------------------------------------------------------------
    % ---------------------- DIAGONAL CORRELATION ---------------------- 
    % ------------------------------------------------------------------
    
    % Red Channel
    
    % Select rows from 1 to (image height - 1) of columns 1 to (image width - 1).
    xDiagR      = image(1:end-1, 1:end-1, 1);
    % Select rows from 2 to (image height) of columns 2 to (image width).
    yDiagR      = image(2:end,   2:end,   1);
    
    % Generate a permutation array.                                          
    randIndex   = randperm(numel(xDiagR));      
    % Get updateSamples first positions in permutation array.
    randIndex   = randIndex(1:updateSamples);            
    
    % Get new pixels values in each position for
    % X and Y, that is, the horizontal pair of pixels.    
    xDiagR      = xDiagR(randIndex);            
    yDiagR      = yDiagR(randIndex);            
    
    % Calculate the acorrelation coeficient of this
    % two arrays of adjacent pixels.
    corrDiagR   = corr2(xDiagR(:), yDiagR(:));  
                                                
    % ---------------------
                                                
    % Green Channel
    
    xDiagG      = image(1:end-1, 1:end-1, 2);  
    yDiagG      = image(2:end,   2:end,   2); 
    
    %randIndex   = randperm(numel(xDiagG));                                           
    %randIndex   = randIndex(1:updateSamples);     
    
    xDiagG      = xDiagG(randIndex);                
    yDiagG      = yDiagG(randIndex);                
    
    corrDiagG   = corr2(xDiagG(:), yDiagG(:));
    
    % ---------------------
    
    % Blue Channel
    
    xDiagB      = image(1:end-1, 1:end-1, 3);  
    yDiagB      = image(2:end,   2:end,   3); 
    
    %randIndex   = randperm(numel(xDiagB));                                           
    %randIndex   = randIndex(1:updateSamples);     
    
    xDiagB      = xDiagB(randIndex);                
    yDiagB      = yDiagB(randIndex);                
    
    corrDiagB   = corr2(xDiagB(:), yDiagB(:));
    
    
    
    % Calculates the all channels diagonal correlation (mean).
    corrDiagRGB   = mean([corrDiagR corrDiagG corrDiagB]);
    
    %% --------------------------------------------------------------------    
    
    % Join values of correlation coeficient into a single array for output.
    valuesR = [corrHorzR corrVertR corrDiagR];
    valuesG = [corrHorzG corrVertG corrDiagG];
    valuesB = [corrHorzB corrVertB corrDiagB];
    
    valuesRGB = [corrHorzRGB, corrVertRGB, corrDiagRGB];
    
end