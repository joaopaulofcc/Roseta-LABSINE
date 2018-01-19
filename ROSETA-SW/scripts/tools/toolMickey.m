%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#       Auxiliar script responsible for generate keystream bits         #
%#                        from MICKEY generator.                         #
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
%# File: toolTrivium.m                                                   #
%#                                                                       #
%# About: This file describe a script which generates a keystream file   #
%#        for a qtd*2 (multiple by 2 for diffusion tests) color or gray  #
%#        images, the generator used is the MICKEY. This file contains   #
%#        pseudorandom bits in hexa format.                              #
%#                                                                       #
%# INPUTS                                                                #
%#                                                                       #
%#     w, h: width, height of the processed image.                       #
%#                                                                       #
%#     color:                                                            #
%#       'gray' - if the image is RGB and the user needs to use in gray. #
%#       'rgb' - if the image is RGB and the user needs to use in RGB.   #
%#                                                                       #
%#     Key: represents the key of encryption system, is represented by   #
%#          a string of 20 hexadecimal digits. For Key examples view:    #
%#          <https://goo.gl/QNjreG>                                      #
%#                                                                       #
%#     IV: represents the initialization vector of encryption system,    #
%#         is represented by a string of 20 hexadecimal digits. For IV   #
%#         examples view: <https://goo.gl/QNjreG>                        #
%#                                                                       #
%#     output: path where the file will be saved.                        #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################

function toolMickey(w, h, color, qtd, Key, IV, output)

    % Add folder with c generators to the system path.
    path = getenv('PATH');
    path = [path ';' pwd '\scripts\generators'];
    setenv('PATH', path);
    
    % If image is RGB color format, that is, 3 different image planes.
    if strcmp(color, 'rgb')
        
        % Set the depth of color planes in the image.
        d = 3;
        
    elseif strcmp(color, 'gray')
        
        d = 1;
        
    % If the "color" parameter is invalid.
    else
        
        error('[ERROR] Color parameter incompatible!');
        
    end

    % Checks if Key or IV parameter is absent, if it they are,
    % generates random new ones.
    if isempty(Key)

        % Generates an binary array.
        Key = randi([0 1],1,80);

        % Converts the binary array to format suported by C
        % generator, that is, decimal number for each byte.

        % Example: 1100101000011011 = 11001101 (205) e 10100001 (161).

        Key = reshape(Key, [10, 8]);
        Key = bi2de(Key);
        Key = num2str(Key');

    else
        
        % Verifies the size of informed key.
        if (length(Key) ~= 20)

            error('[ERROR] Key size incompatible, required 20 hexa characters!');

        end

        % Converts the hex array to binary.
        Key = hexToBinaryVector(Key, 80);

        % Converts the binary array to format suported by C
        % generator, that is, decimal number for each byte.

        % Example: 1100101000011011 = 11001101 (205) e 10100001 (161).
        Key = reshape(Key, [10, 8]);
        Key = bi2de(Key);
        Key = num2str(Key');

    end

    if isempty(IV)

        % Generates an binary array.
        IV = randi([0 1],1,80);

        % Converts the binary array to format suported by C
        % generator, that is, decimal number for each byte.

        % Example: 1100101000011011 = 11001101 (205) e 10100001 (161).

        IV = reshape(IV, [10, 8]);
        IV = bi2de(IV);
        IV = num2str(IV');

    else

        % Verifies the size of informed IV.
        if (length(IV) ~= 20)

            error('[ERROR] IV size incompatible, required 20 hexa characters!');

        end
        
        % Converts the hex array to binary.
        IV = hexToBinaryVector(IV, 80);

        % Converts the binary array to format suported by C
        % generator, that is, decimal number for each byte.

        % Example: 1100101000011011 = 11001101 (205) e 10100001 (161).
        IV = reshape(IV, [10, 8]);
        IV = bi2de(IV);
        IV = num2str(IV');

    end

    % Call the generator and save the C program output to txt file.
    system(['mickey ' num2str((w*h*d*8*2*qtd)/32) ' ' Key ' ' IV ' > ' output]);

end