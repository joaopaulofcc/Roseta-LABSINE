%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					    Analysis Implementations                         #
%#                                                                       #
%#     Script responsible for process the bits of an given image with    #
%#                  the bits generated in a keystream.                   #
%#                                                                       #
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
%# File: cipherDecipher.m                                                #
%#                                                                       #
%# About: This file describe a script which cipher or decipher an image. #
%#                                                                       #
%# INPUTS                                                                #
%#                                                                       #
%#     image: the matlab image object to be processed.                   #
%#                                                                       #
%#     keystream: string object where which position represents a bit    #
%#         pseudo random coming from the choosed generator.              #
%#                                                                       #
%# RETURN                                                                #
%#                                                                       #
%#     processedImage: ciphered or deciphered matlab image object.       #
%#                                                                       #
%#     processingTimes: array of process timings demanded in a list of   #
%#         internal operations and of a total process time.              #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################

function [processedImage, processingTimes] = cipherDecipher(keystream, image)


    %% -------------------------------------------------------------------
    
        % Start the total processing timing.
        totalTime = tic;

        % Start the timing of the decimal to binary convertion.
        timeDec2Bin = tic;

        % Converts the pixel values to binary representation.
        A = dec2bin(image, 8);

        % Finalize the timing of the decimal to binary convertion.
        timeDec2Bin = toc(timeDec2Bin);

    %% -------------------------------------------------------------------

        % Start the reshape processing timing.
        timeReshapeArray = tic;

        % Reshape de binary values matrix in a logic elements array (bits).
        B = logical(reshape(A',1,numel(A))'-'0')';

        % Finalize the reshape process timing.
        timeReshapeArray = toc(timeReshapeArray);

    %% -------------------------------------------------------------------

        % Start the XOR operation timing.
        timeXOR = tic;

        % Start the stream processing (cipher or decipher) xoring each
        % image bit with each keystream bit.
        Out = bitxor(keystream, B);

        % Finalize the XOR operation timing.
        timeXOR = toc(timeXOR);

    %% -------------------------------------------------------------------

        % Start the reshape for binary matrix processing timing.
        timeReshapeMatrix1 = tic;

        % Reshape the array 1D for an equivalent 2D representation
        % (matrix) where each row represents a pixel and an columns
        % represents a bit.
        C = reshape(Out,size(A,2),size(A,1));

        % Finalize the reshape for binary matrix processing timing.
        timeReshapeMatrix1 = toc(timeReshapeMatrix1);

    %% -------------------------------------------------------------------

        % Start the binary to decimal convertion timing.
        timeBin2Dec = tic;

        % Converts all elements of binary matrix to decimal representation.
        % View the URL: <https://goo.gl/QCcMDu>.
        tempMatrix = C'*(2.^(size(C',2)-1:-1:0))';

        % Finalize the binary to decimal convertion timing.
        timeBin2Dec = toc(timeBin2Dec);
    
    %% -------------------------------------------------------------------

        % Start the reshape for decimal matrix processing timing.
        timeReshapeMatrix2 = tic;

        % Reshape the binary matrix to original image dimension.
        processedImage = uint8(reshape(tempMatrix,size(image)));

        % Finalize the reshape for decimal matrix processing timing.
        timeReshapeMatrix2 = toc(timeReshapeMatrix2);
    
    %% -------------------------------------------------------------------

        % Finalize the total processing timing.
        totalTime = toc(totalTime);
    
    %% -------------------------------------------------------------------

        % Return the array containing all the processing timings.
        processingTimes = [totalTime timeDec2Bin timeReshapeArray timeXOR timeReshapeMatrix1 timeBin2Dec timeReshapeMatrix2];
   
end