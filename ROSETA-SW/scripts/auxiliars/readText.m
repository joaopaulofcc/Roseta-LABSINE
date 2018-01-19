%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#              Script responsible for read a keystream file             #
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
%# File: readText.m                                                      #
%#                                                                       #
%# About: This file describe a script which reads a keystream file.      #
%#                                                                       #
%# INPUTS                                                                #
%#                                                                       #
%#     keystreamParam: path for the file.                                #
%#                                                                       #
%#     w, h, d: width, height and bit deepness of the processed image.   #
%#                                                                       #
%# RETURN                                                                #
%#                                                                       #
%#     keystream: a bit array of random bits readed and converted from   #
%#                the file, suficient to process the image twice.        #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################

function keystream = readText(keystreamParam, w, h, d)

    % Calculate the number of bits required to processing the two
    % images (multiply by 16 because each image needs 8 bits for each
    % pixel representation).
    totalSize = w*h*d*16;

    % Each image needs of "columns" bits from the keystream to be
    % process, then the matrix of keystream will have 2 rows by
    % "columns" bits.
    columns = w*h*d*8;


    % Try to read the content of the file, WARNING: each character of
    % the file is represented in hexadecimal base, therefore each
    % character represents 4 bits of the resultant keystream.
    try
        keystream = fileread(keystreamParam);
    catch
        error('[ERROR] File not found!');
    end

    % Get the number of hexadecimal characteres.
    sizeFile = numel(keystream);

    % If the number of characters is less then the required for the
    % processing of the 2 images abort the execution.
    if sizeFile < (totalSize / 4)

        error('[ERROR] Length of required keystream is greater then size of file!');

    % If the number of characters is suficient.
    else

        % Lot a aleatory index to be read from the file to be used
        % like a start of the keystream.
        initialIndex = randi((sizeFile - (totalSize / 4) + 1), 1, 1);

        % Backup the keystream to save it into a separated file.
        keystreamHex = keystream(1, initialIndex:...
            (initialIndex + (totalSize/4) - 1));

        % Converts the interval of characters from the random index
        % to the total size required for processing divide by 4
        % because the text contains hexadecimal characters.
        keystream = hexToBinaryVector(keystreamHex, totalSize);

        % Reshape the keystream to a matrix format.
        keystream = reshape(keystream, 2, columns);

    end
    
end