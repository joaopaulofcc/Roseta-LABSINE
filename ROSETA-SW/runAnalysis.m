%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					    Analysis Implementations                         #
%#                                                                       #
%#   Script responsible for manage all the cipher/decipher process and   #
%#                 run the statistical tests and plots.                  #
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
%# File: runAnalysis.m                                                   #
%#                                                                       #
%# About: This file describe a script which execute these features:      #
%#                                                                       #
%#      1) If a keystream is not informed by the use, the script will    #
%#         generate a new one in the informed generator. The keystream   #
%#         length will be the same as needed to process an image twice   #
%#         (normal process and differential analysis).                   #
%#                                                                       #
%#      2) Cipher and decipher an informed image or capture a new one    #
%#         from the webcam (mechanisms is provided by the script).       #
%#                                                                       #
%#      3) Run the entropy test, differential test and correlation test. #
%#                                                                       #
%#      4) Call the correct scripts for make plots of the information    #
%#         processed.                                                    #
%#                                                                       #
%#      5) If the user wishes, print on the console all relevant         #
%#         processing informations (verbose mode).                       #
%#                                                                       #
%# INPUTS                                                                #
%#                                                                       #
%#     imagePath: the folder path of the image to be processed. If the   #
%#          user wants to capture a new image this parameter should not  #
%#          be informed. In this case should be used "[]" instead of     #
%#          the path, and so omit this parameter.                        #  
%#                                                                       #
%#     camIndex: the user after run 'webcamlist' command choose what the #
%#          webcam will be used by their index in 'ans' array.           #
%#                                                                       #
%#     resolution: if "imagePath" is absent, this parameter should be    #
%#          a string containing the desired resolution of the webcam     #
%#          capture. To view the supported resolutions, 
%#                                                                       #
%#     resize: if this parameter aren't absent, then the image will be   #
%#          resized for the "resize" dimensions. Syntax - [H W]          #
%#                                                                       #
%#     color:                                                            #
%#       'gray' - if the image is RGB and the user needs to use in gray. #
%#       'rgb' - if the image is RGB and the user needs to use in RGB.   #
%#                                                                       #
%#     generator: is a string representing the pseudo random generator   #
%#          to be used, that is: 'trivium' or 'mickey' or 'grain'.       #
%#                                                                       #
%#     baud: baud rate to be used in serial communication with FPGA.     #
%#                                                                       #
%#     com: serial COM port where FPGA is connected                      #
%#                                                                       #
%#     reset: used in generators in hardware to indicate (1) or not (0)  #
%#          if it is necessary to reset in its circuits.                 #
%#                                                                       #
%#     keystreamFileName: path for an existent keystream text file       #
%#          composed of hexadecimal elements, represented as logical     #
%#          type. If was omitted, this script will generated a new one   #
%#          using the "generator" informed together with the "Key" and   #
%#          "IV" parameters.                                             #
%#                                                                       #
%#     keystreamSensitivityFileName: path for an existent keystream for  #
%#          sensitivity metric calculation. It's similar to a normal     #
%#          keystream file, but ir's generated with an 1-bit modified    #
%#          key value.
%#                                                                       #
%#     Key: represents the key of encryption system, is represented by   #
%#          a string of 20 hexadecimal digits. For Key examples view:    #
%#          <https://goo.gl/QNjreG>                                      #
%#                                                                       #
%#     IV: represents the initialization vector of encryption system,    #
%#         is represented by a string of 20 hexadecimal digits. For IV   #
%#         examples view: <https://goo.gl/QNjreG>                        #
%#                                                                       #
%#     samples: number of pixels pair sampled in correlation analysis.   #
%#                                                                       #
%#     verbose: 1 - if user want to view execution information on screen #
%#              0 - otherwise                                            #
%#                                                                       #
%#     csv: 1 - if user want to save the statistics to a .csv file.      #
%#          0 - otherwise                                                #
%#                                                                       #
%#     csvFileName: name of the csv file to be writed.                   #
%#                                                                       #
%#     seedIN: random seed to be used, if is empty generates a new one.  #
%#                                                                       #
%#     name: string representing the name of the project. Is it used to  #
%#           create the folders structure for the output results.        #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################

function [paths, entropyOUT, intensityOUT, correlationOUT, diffusionOUT, ...
    sensitivityOUT] = runAnalysis(imagePath, camIndex, resolution, resize, color, ...
    generator, baud, com, reset, keystreamFileName, keystreamSensitivityFileName, ...
    Key, IV, samples, verbose, csv, csvFileName, seedIN, name)

    % Turn off the plots exibition while execution is on progress.
    set(groot,'defaultFigureVisible','off');
    
    
    %% --------------------------------------------------------------------
    
    % Check if the number of informed parameters is correct, if is not,
    % warns the user, shows the correct syntax and terminate the script.
    if nargin < 19
        
        fprintf('\n');
        disp('[ERROR] Not enough input arguments.');
        fprintf('\n');
        fprintf(['EXPECTED: runAnalysis(imagePath, camIndex, resolution, resize, ' ...
                'color, generator, baud, com, reset, keystreamFileName, ' ...
                'keystreamSensitivityFileName, Key, IV, samples, verbose, ' ...
                'csv, csvFileName, seedIN, name)']);
        fprintf('\n\n');
        
        return;
        
    end


    %% --------------------------------------------------------------------

    % If the user does not inform the "seedIN" parameter, the script will
    % generates a new one random number seed. Otherwise, the script will
    % load the informed seed.
    if isempty(seedIN)
        
        seed = rng;
        
    else
        
        load(seedIN, 'seed');
        rng(seed);
        
    end
    
    
    % Checks if the source of the image is an file or a webcam.
    if isempty(imagePath)
        
        
        % Verifies if the "camIndex" parameter is present, then creates a 
        % handle for the selected or default webcam.
        if isempty(camIndex)
            
            cam = webcam();
            
        else
            
            cam = webcam(camIndex);
            
        end
        
        % Define resolution of camera.
        cam.Resolution = resolution;
        
        % Show the preview of webcam.
        %prevCam = preview(cam);
        
        % Move the preview to the center of the screen.
        %movegui(prevCam,'center');
        
        % Wait until the user press a key (like a trigger to snapshot).
        pause(2);

        % Close the preview.
        %closePreview(cam)
        
        % Capture an image.
        imgRead = snapshot(cam);
        
        % Remove handle of the memory.
        clear('cam');
        
    % If the image comes from a path of a file.
    else
        
        % Read an image from path.
        imgRead = imread(imagePath);
        
    end
    
    
    %% --------------------------------------------------------------------
    
    % If image is represented in RGB mode and the user wants to process the
    % correspondent in grayscale, starts the convertion process.
    if ( (size(imgRead, 3) == 3) && strcmp(color, 'gray') )
        
        % Convert the image for gray scale.
        imgGray = rgb2gray(imgRead);
        
        % Chose the converted image for default image on the process.
        imgPlain = imgGray;
        
    % If image is RGB mode and the user wants to process the correspondent
    % in RGB mode dont need a convertion process.
    elseif ( (size(imgRead, 3) == 3) && strcmp(color, 'rgb') )  
        
        % Chose the converted image for default image on the process.
        imgPlain = imgRead;
        
    % Otherwise if user send a grayscale image, he only can process this
    % image in gray scale mode.
    elseif ( (size(imgRead, 3) == 1) && strcmp(color, 'gray') )
        
        imgPlain = imgRead;
        
    % If the "color" parameter is empty, change the parameter to the 
    % correspondent value.
    elseif ( (size(imgRead, 3) == 3) && isempty(color) )
        
        color = 'rgb';
        
        imgPlain = imgRead;
        
    elseif ( (size(imgRead, 3) == 1) && isempty(color) )
        
        color = 'gray';
        
        imgPlain = imgRead;
        
	% Any other combination of image format and RGB flag is invalid.
    else
        
        error('[ERROR] Image color format and RGB parameter incompatible!');
        
    end
    
    
    % If "resize" parameter is not absent, then resize the image.
    if not(isempty(resize))
        
        % Check if the parameter contains the height and width dimensions.
        if numel(resize) ~= 2
            
            error('[ERROR] Invalid resize parameter. Expected [H W]!');
            
        end
        
        % Resize the image for the required dimension.
        imgPlain = imresize(imgPlain, [resize(1) resize(2)]);
        
    end
    
    
    %% --------------------------------------------------------------------
    
    % Prepare image to differential Analysis (NPCR and UACI).
    
    % Make a copy of the default image.
    imgDiffusion = imgPlain;
    
    % Select a pixel index randomly.
    pos = randi([1, numel(imgDiffusion)], 1);
    
    % Change this pixel value to another onde chose randomly.
    imgDiffusion(pos) = abs(randi([0 255], 1) - imgDiffusion(pos));

    
    % Get the size of image.
    [w,h,d] = size(imgPlain);
    
    
    % Starts the time marker of Total Time.
    totalTime = tic;
    
    % Starts the time marker for keystream generator.
    keystreamTime = tic;
    
    %% --------------------------------------------------------------------
    
    % The keystream was generated, not readed (default)
    keystreamRead = 0;
    
    % Checks if is necessary to generate a new keystream, or this was
    % informed in the parameters of the script.
    if isempty(keystreamFileName)
       
        % Generate keystream suficient for processing of two images
        % (default and differential)
        
        % Check which generator will be use.
        if strcmp(generator, 'trivium')
            
            % Checks if Key or IV parameter is absent, if it they are,
            % generates random new ones.
            if isempty(Key)
            
                % Generates an binary array.
                Key = randi([0 1],1,80);
               
                 % Save the Key in binary format.
                binKey = Key;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(Key);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 00000011 (3) e 01111000 (120).
                
                Key = reshape(Key, [10, 8]);
                Key = Key';
                Key = reshape(Key.', [8, 10]).';
                Key = bi2de(Key);
                Key = num2str(Key');
                
            else
                
                % Verifies the size of informed key.
                if (length(Key) ~= 20)
                   
                    error('[ERROR] Key size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexKey = Key;
                
                % Reshapes the hex array to preserve the right endian.
                Key = reshape(Key, [10, 2]);
                Key = Key';
                Key = reshape(Key.', [2, 10]).';
                
                % Converts the hex array to binary.
                Key = hexToBinaryVector(Key, 8);
                
                % Save the Key in binary format.
                binKey = reshape(Key, [1,80]);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 00000011 (3) e 01111000 (120).
                
                Key = bi2de(Key);
                Key = num2str(Key');
                
            end
            
            if isempty(IV)
            
                % Generates an binary array.
                IV = randi([0 1],1,80);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexIV = binaryVectorToHex(IV);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 00000011 (3) e 01111000 (120).
                
                IV = reshape(IV, [10, 8]);
                IV = IV';
                IV = reshape(IV.', [8, 10]).';
                IV = bi2de(IV);
                IV = num2str(IV');
                
            else
                
                % Verifies the size of informed IV.
                if (length(IV) ~= 20)
                   
                    error('[ERROR] IV size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexIV = IV;
                
                % Reshapes the hex array to preserve the right endian.
                IV = reshape(IV, [10, 2]);
                IV = IV';
                IV = reshape(IV.', [2, 10]).';
                
                % Converts the hex array to binary.
                IV = hexToBinaryVector(IV, 8);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 00000011 (3) e 01111000 (120).
                
                IV = bi2de(IV);
                IV = num2str(IV');
                
            end
            
            % Randomly selects a Key position and inverts this bit, used
            % for key sensitivity analysis.
            pos = randi([1, 80], 1);
            keySensitivity = binKey;
            keySensitivity(pos) = not(keySensitivity(pos));
            
            binKeySensitivity = keySensitivity;
            hexKeySensitivity = binaryVectorToHex(keySensitivity);
            
            % Converts the sensitivity key to format suported by C generator. 
            keySensitivity = reshape(keySensitivity, [10, 8]);
            keySensitivity = bi2de(keySensitivity);
            keySensitivity = num2str(keySensitivity');
            
            
            % Call the generator and save the C program output to txt file.
            system(['trivium ' num2str((w*h*d*8*2)/32) ' ' Key ' ' IV ' > keystream.txt']);
            
            % Call the same generator using the modified Key.
            system(['trivium ' num2str((w*h*d*8*2)/32) ' ' keySensitivity ' ' IV ' > keystreamSensitivity.txt']);
            
         
            
        % Check which generator will be use.
        elseif strcmp(generator, 'triviumFPGA')
            
            % Checks if Key or IV parameter is absent, if it they are,
            % generates random new ones.
            if isempty(Key)
            
                % Generates an binary array.
                Key = randi([0 1],1,80);
               
                 % Save the Key in binary format.
                binKey = Key;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(Key);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = reshape(Key, [10, 8]);
                Key = Key';
                Key = reshape(Key.', [8, 10]).';
                Key = bi2de(fliplr(Key));
                Key = Key';
                
            else
                
                % Verifies the size of informed key.
                if (length(Key) ~= 20)
                   
                    error('[ERROR] Key size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexKey = Key;
                
                % Reshapes the hex array to preserve the right endian.
                Key = reshape(Key, [10, 2]);
                Key = Key';
                Key = reshape(Key.', [2, 10]).';
                
                % Converts the hex array to binary.
                Key = hexToBinaryVector(Key, 8);
                
                % Save the Key in binary format.
                binKey = reshape(Key, [1,80]);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = bi2de(fliplr(Key));
                Key = Key';
                                
            end
            
            if isempty(IV)
            
                % Generates an binary array.
                IV = randi([0 1],1,80);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexIV = binaryVectorToHex(IV);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = reshape(IV, [10, 8]);
                IV = IV';
                IV = reshape(IV.', [8, 10]).';
                IV = bi2de(fliplr(IV));
                IV = IV';
              
            else
                
                % Verifies the size of informed IV.
                if (length(IV) ~= 20)
                   
                    error('[ERROR] IV size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexIV = IV;
                
                % Reshapes the hex array to preserve the right endian.
                IV = reshape(IV, [10, 2]);
                IV = IV';
                IV = reshape(IV.', [2, 10]).';
                
                % Converts the hex array to binary.
                IV = hexToBinaryVector(IV, 8);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = bi2de(fliplr(IV));
                IV = IV';
                
            end
            
            % Randomly selects a Key position and inverts this bit, used
            % for key sensitivity analysis.
            pos = randi([1, 80], 1);
            keySensitivity = binKey;
            keySensitivity(pos) = not(keySensitivity(pos));
            
            binKeySensitivity = keySensitivity;
            hexKeySensitivity = binaryVectorToHex(keySensitivity);
            
            % Converts the sensitivity key to format suported by FPGA generator. 
            keySensitivity = reshape(keySensitivity, [10, 8]);
            keySensitivity = bi2de(keySensitivity);
            keySensitivity = num2str(keySensitivity');
            
            % Verifies the reset parameter.
            if (reset == 1) || (reset == 0)
                
                % Call the generator and save the FPGA serial output to txt file.
                triviumFPGA(1, Key, IV, w, h, d, 'keystream.txt', baud, com);       
                
                % Call the same generator using the modified Key.
                triviumFPGA(1, keySensitivity, IV, w, h, d, 'keystreamSensitivity.txt', baud, com);                
            
            else
            
                error('[ERROR] reset parameter needs to be present and its value should be numerical!');
                
            end
            
            
            
        % If the chosen generator is GRAIN.
        elseif strcmp(generator, 'grain')
            
            % Checks if Key or IV parameter is absent, if it they are,
            % generates random new ones.
            if isempty(Key)
            
                % Generates an binary array.
                Key = randi([0 1],1,80);
               
                 % Save the Key in binary format.
                binKey = Key;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(Key);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = reshape(Key, [10, 8]);
                Key = Key';
                Key = reshape(Key.', [8, 10]).';
                Key = bi2de(fliplr(Key));
                Key = num2str(Key');
                
            else
                
                % Verifies the size of informed key.
                if (length(Key) ~= 20)
                   
                    error('[ERROR] Key size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexKey = Key;
                
                % Reshapes the hex array to preserve the right endian.
                Key = reshape(Key, [10, 2]);
                Key = Key';
                Key = reshape(Key.', [2, 10]).';
                
                % Converts the hex array to binary.
                Key = hexToBinaryVector(Key, 8);
                
                % Save the Key in binary format.
                binKey = reshape(Key, [1,80]);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = bi2de(fliplr(Key));
                Key = num2str(Key');
                
            end
            
            if isempty(IV)
            
                % Generates an binary array. Grain needs a 64 bit IV, but
                % to keep the random generator synchronized with other
                % analysis which uses the Trivium and MICKEY generator,
                % creates a 80 random bits.
                temp = randi([0 1],1,80);
                IV = temp(1:64);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexIV = binaryVectorToHex(IV);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = reshape(IV, [8, 8]);
                IV = IV';
                IV = reshape(IV.', [8, 8]).';
                IV = bi2de(fliplr(IV));
                IV = num2str(IV');
                
            else
                
                % Verifies the size of informed IV.
                if (length(IV) ~= 16)
                   
                    error('[ERROR] IV size incompatible, required 16 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexIV = IV;
                
                % Reshapes the hex array to preserve the right endian.
                IV = reshape(IV, [8, 2]);
                IV = IV';
                IV = reshape(IV.', [2, 8]).';
                
                % Converts the hex array to binary.
                IV = hexToBinaryVector(IV, 8);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = bi2de(fliplr(IV));
                IV = num2str(IV');
                
            end
            
            % Randomly selects a Key position and inverts this bit, used
            % for key sensitivity analysis.
            pos = randi([1, 80], 1);
            keySensitivity = binKey;
            keySensitivity(pos) = not(keySensitivity(pos));
            
            binKeySensitivity = keySensitivity;
            hexKeySensitivity = binaryVectorToHex(keySensitivity);
            
            % Converts the sensitivity key to format suported by C generator. 
            keySensitivity = reshape(keySensitivity, [10, 8]);
            keySensitivity = bi2de(keySensitivity);
            keySensitivity = num2str(keySensitivity');
            
            
            % Call the generator and save the C program output to txt file.
            system(['grain ' num2str((w*h*d*8*2)/8) ' ' Key ' ' IV ' > keystream.txt']);
            
            % Call the same generator using the modified Key.
            system(['grain ' num2str((w*h*d*8*2)/8) ' ' keySensitivity ' ' IV ' > keystreamSensitivity.txt']);
            
            
            
        % Check which generator will be use.
        elseif strcmp(generator, 'grainFPGA')
            
            % Checks if Key or IV parameter is absent, if it they are,
            % generates random new ones.
            if isempty(Key)
            
                % Generates an binary array.
                Key = randi([0 1],1,80);
               
                 % Save the Key in binary format.
                binKey = Key;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(Key);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = reshape(Key, [10, 8]);
                Key = Key';
                Key = reshape(Key.', [8, 10]).';
                Key = bi2de(fliplr(Key));
                Key = Key';
                
            else
                
                % Verifies the size of informed key.
                if (length(Key) ~= 20)
                   
                    error('[ERROR] Key size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexKey = Key;
                
                % Converts the hex array to binary.
                Key = hexToBinaryVector(Key, 80);

                % Save the Key in binary format.
                binKey = reshape(Key, [1,80]);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                Key = reshape(Key, [8, 10])';
                Key = bi2de(Key);
                
            end
            
            if isempty(IV)
            
                % Generates an binary array.
                IV = randi([0 1],1,64);
                
                % Save the IV in binary format.
                binIV = IV;
  
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(IV);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                IV = reshape(IV, [8, 8])';
                IV = bi2de(IV);
                
            else
                
                % Verifies the size of informed IV.
                if (length(IV) ~= 16)
                   
                    error('[ERROR] IV size incompatible, required 16 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexIV = IV;
                
                % Converts the hex array to binary.
                IV = hexToBinaryVector(IV, 64);

                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                IV = reshape(IV, [8, 8])';
                IV = bi2de(IV);
                
            end
            
            
            % Randomly selects a Key position and inverts this bit, used
            % for key sensitivity analysis.
            pos = randi([1, 80], 1);
            keySensitivity = binKey;
            keySensitivity(pos) = not(keySensitivity(pos));
            
            binKeySensitivity = keySensitivity;
            hexKeySensitivity = binaryVectorToHex(keySensitivity);
            
            % Converts the sensitivity key to format suported by FPGA generator. 
            keySensitivity = reshape(keySensitivity, [10, 8]);
            keySensitivity = bi2de(keySensitivity);
            keySensitivity = num2str(keySensitivity');
            
            
            % Verifies the reset parameter.
            if (reset == 1) || (reset == 0)
                
                % Call the generator and save the FPGA serial output to txt file.
                grainFPGA(reset, Key, IV, w, h, d, 'keystream.txt', baud, com);                
            
                % Call the same generator using the modified Key.
                grainFPGA(reset, keySensitivity, IV, w, h, d, 'keystreamSensitivity.txt', baud, com);                
            
            else
            
                error('[ERROR] reset parameter needs to be present and its value should be numerical!');
                
            end
            
            
            
            
        % If the chosen generator is MICKEY.
        elseif strcmp(generator, 'mickey')
            
            % Checks if Key or IV parameter is absent, if it they are,
            % generates random new ones.
            if isempty(Key)
            
                % Generates an binary array.
                Key = randi([0 1],1,80);
               
                 % Save the Key in binary format.
                binKey = Key;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(Key);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = reshape(Key, [10, 8]);
                Key = Key';
                Key = reshape(Key.', [8, 10]).';
                Key = bi2de(fliplr(Key));
                Key = num2str(Key');
                
            else
                
                % Verifies the size of informed key.
                if (length(Key) ~= 20)
                   
                    error('[ERROR] Key size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexKey = Key;
                
                % Reshapes the hex array to preserve the right endian.
                Key = reshape(Key, [10, 2]);
                Key = Key';
                Key = reshape(Key.', [2, 10]).';
                
                % Converts the hex array to binary.
                Key = hexToBinaryVector(Key, 8);
                
                % Save the Key in binary format.
                binKey = reshape(Key, [1,80]);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = bi2de(fliplr(Key));
                Key = num2str(Key');
                
            end
            
            if isempty(IV)
            
                % Generates an binary array.
                IV = randi([0 1],1,80);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexIV = binaryVectorToHex(IV);
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = reshape(IV, [10, 8]);
                IV = IV';
                IV = reshape(IV.', [8, 10]).';
                IV = bi2de(fliplr(IV));
                IV = num2str(IV');
                
            else
                
                % Verifies the size of informed IV.
                if (length(IV) ~= 20)
                   
                    error('[ERROR] IV size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexIV = IV;
                
                % Reshapes the hex array to preserve the right endian.
                IV = reshape(IV, [10, 2]);
                IV = IV';
                IV = reshape(IV.', [2, 10]).';
                
                % Converts the hex array to binary.
                IV = hexToBinaryVector(IV, 8);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to format suported by C
                % generator, that is, decimal number for each byte.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = bi2de(fliplr(IV));
                IV = num2str(IV');
                
            end

            % Randomly selects a Key position and inverts this bit, used
            % for key sensitivity analysis.
            pos = randi([1, 80], 1);
            keySensitivity = binKey;
            keySensitivity(pos) = not(keySensitivity(pos));
            
            binKeySensitivity = keySensitivity;
            hexKeySensitivity = binaryVectorToHex(keySensitivity);
            
            % Converts the sensitivity key to format suported by C generator. 
            keySensitivity = reshape(keySensitivity, [10, 8]);
            keySensitivity = bi2de(keySensitivity);
            keySensitivity = num2str(keySensitivity');
            
            % Call the generator and save the C program output to txt file.
            system(['mickey ' num2str((w*h*d*8*2)/8) ' ' Key ' ' IV ' > keystream.txt']);
            
            % Call the same generator using the modified Key.
            system(['mickey ' num2str((w*h*d*8*2)/8) ' ' keySensitivity ' ' IV ' > keystreamSensitivity.txt']);
            
            
            
        % Check which generator will be use.
        elseif strcmp(generator, 'mickeyFPGA')

            % Checks if Key or IV parameter is absent, if it they are,
            % generates random new ones.
            if isempty(Key)

                % Generates an binary array.
                Key = randi([0 1],1,80);
               
                 % Save the Key in binary format.
                binKey = Key;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexKey = binaryVectorToHex(Key);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = reshape(Key, [10, 8]);
                Key = Key';
                Key = reshape(Key.', [8, 10]).';
                Key = bi2de(fliplr(Key));
                Key = Key';

            else

                % Verifies the size of informed key.
                if (length(Key) ~= 20)
                   
                    error('[ERROR] Key size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexKey = Key;
                
                % Reshapes the hex array to preserve the right endian.
                Key = reshape(Key, [10, 2]);
                Key = Key';
                Key = reshape(Key.', [2, 10]).';
                
                % Converts the hex array to binary.
                Key = hexToBinaryVector(Key, 8);
                
                % Save the Key in binary format.
                binKey = reshape(Key, [1,80]);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                Key = bi2de(fliplr(Key));
                Key = Key';

            end

            if isempty(IV)

                % Generates an binary array.
                IV = randi([0 1],1,80);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to hexadecimal representation
                % for future print.
                hexIV = binaryVectorToHex(IV);
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = reshape(IV, [10, 8]);
                IV = IV';
                IV = reshape(IV.', [8, 10]).';
                IV = bi2de(fliplr(IV));
                IV = IV';

            else

                % Verifies the size of informed IV.
                if (length(IV) ~= 20)
                   
                    error('[ERROR] IV size incompatible, required 20 hexa characters!');
                
                end
                
                % Save the parameter in hexadecimal to future print.
                hexIV = IV;
                
                % Reshapes the hex array to preserve the right endian.
                IV = reshape(IV, [10, 2]);
                IV = IV';
                IV = reshape(IV.', [2, 10]).';
                
                % Converts the hex array to binary.
                IV = hexToBinaryVector(IV, 8);
                
                % Save the IV in binary format.
                binIV = IV;
                
                % Converts the binary array to format suported by FPGA
                % hardware, that is, decimal format. Each byte of the
                % sequence (each number) will be sended by UART port.
                
                % Example: 1100000000011110 = 11000000 (192) e 00011110 (30).
                
                IV = bi2de(fliplr(IV));
                IV = IV';

            end


            % Randomly selects a Key position and inverts this bit, used
            % for key sensitivity analysis.
            pos = randi([1, 80], 1);
            keySensitivity = binKey;
            keySensitivity(pos) = not(keySensitivity(pos));

            binKeySensitivity = keySensitivity;
            hexKeySensitivity = binaryVectorToHex(keySensitivity.');

            % Converts the sensitivity key to format suported by FPGA generator. 
            keySensitivity = reshape(keySensitivity, [10, 8]);
            keySensitivity = bi2de(keySensitivity);
            keySensitivity = num2str(keySensitivity');


            % Verifies the reset parameter.
            if (reset == 1) || (reset == 0)

                % Call the generator and save the FPGA serial output to txt file.
                mickeyFPGA(reset, Key, IV, w, h, d, 'keystream.txt', baud, com);                

                % Call the same generator using the modified Key.
                mickeyFPGA(reset, keySensitivity, IV, w, h, d, 'keystreamSensitivity.txt', baud, com);                

            else

                error('[ERROR] reset parameter needs to be present and its value should be numerical!');

            end
            
            
        end
         
        % Call the function responsible for read the keystream file and
        % returns the keystream readed in binary format.
        keystream = readText('keystream.txt', w, h, d);    
        
        % Reads the modified keystream for sensitivty analysis.
        keystreamSensitivity = readText('keystreamSensitivity.txt', w, h, d);
        
        
    % If the keystream parameter is not empty.
    else
        
        % The keystream was readed from a file, not generated.
        keystreamRead = 1;
        
        % Is not possible to get the Key/IV values from the keystream file.
        hexKey              = [];
        hexKeySensitivity   = [];
        hexIV               = [];
        binKey              = [];
        binKeySensitivity   = [];
        
        % Call the function responsible for read the keystream file and
        % returns the keystream readed in binary format.
        keystream = readText(keystreamFileName, w, h, d);
        keystreamSensitivity = readText(keystreamSensitivityFileName, w, h, d);
           
    end
    
    % Finalize the time marker of keystream generator.
    keystreamTime = toc(keystreamTime);
    
    
    
    %% -----------------------------------------------------------------
    % ------------------------- CIPHER PROCESS ------------------------- 
    % ------------------------------------------------------------------

    % Starts the cipher process of the plain default image.
    [imgCipher, cipherTime] = cipherDecipher(keystream(1,:), imgPlain);

    % Starts the cipher process of the image for differential analysis.
    [imgCipherDiffusion, cipherTime2] = cipherDecipher(keystream(2,:), ...
        imgDiffusion);
    
    % Starts the cipher process of the image for key sensitivity analysis.
    % The image to be processed is the plain image.
    [imgCipherSensitivity, cipherTime3] = cipherDecipher(keystreamSensitivity(1,:), imgPlain);
    
    

    %% -----------------------------------------------------------------
    % ------------------------ DECIPHER PROCESS ------------------------ 
    % ------------------------------------------------------------------

    % Starts the decipher process of the cipher image.
    [imgDecipher, decipherTime] = cipherDecipher(keystream(1,:), imgCipher);
    
    % Starts the decipher process of the image for key sensitivity analysis.
    % The image to be processed is the image encrypted with the original
    % keystream, generated by the "key" value.
    [imgDecipherSensitivity, decipherTime2] = cipherDecipher(keystreamSensitivity(1,:), imgCipher);


    % -------------------------------------------------------------------

    % Finalize the total process time of the images processing.
    totalTime = toc(totalTime);

    
    %% -----------------------------------------------------------------
    % -------------------------- CREATE PATHS -------------------------- 
    % ------------------------------------------------------------------
    
    % Get the actual date and time.
    dateSCRIPT = datestr(datetime('now'), '[dd-mm-yy HH.MM.SS.fff]');
    
    % Default path for outputs results.
    pathHOME            = ['executions/' name ' ' dateSCRIPT '/'];
    
    % Creates default folder.
    mkdir_if_not_exist(pathHOME);
    
    % Create path for images folder.
    mkdir_if_not_exist([pathHOME 'images']);
    
    % Path for histogram of image.
    pathHIST       = ['executions/' name ' ' dateSCRIPT '/histogram/'];
    mkdir_if_not_exist(pathHIST);
    
    % If the image is RGB color, creates individual folders for histogram.
    if strcmp(color, 'rgb')
        
        mkdir_if_not_exist([pathHIST 'plain']);
        mkdir_if_not_exist([pathHIST 'cipher']);
        mkdir_if_not_exist([pathHIST 'decipher']);
        
    end
    
    % Path for correlation graphs.
    pathCORR    = ['executions/' name ' ' dateSCRIPT '/correlation/'];
    mkdir_if_not_exist(pathCORR);
    
    % If the image is RGB color, creates individual folders for correlation.
    if strcmp(color, 'rgb')
        
        mkdir_if_not_exist([pathCORR 'red']);     % Red
        mkdir_if_not_exist([pathCORR 'green']);   % Green
        mkdir_if_not_exist([pathCORR 'blue']);    % Blue
        
    end
    
    
    % Path for key sensitivity graphs.
    pathSENS    = ['executions/' name ' ' dateSCRIPT '/sensitivity/'];
    mkdir_if_not_exist(pathSENS);
    
    
    % Path for the statistics analysis saved in .csv file.
    pathCSV    = 'statistics/raw/';
    mkdir_if_not_exist(pathCSV);
    
    % Create folders to store the ".csv" raw analysis file for each
    % generator and color mode.
    mkdir_if_not_exist([pathCSV 'trivium/RGB/']);
    mkdir_if_not_exist([pathCSV 'trivium/Gray/']);
    
    mkdir_if_not_exist([pathCSV 'triviumFPGA/RGB/']);
    mkdir_if_not_exist([pathCSV 'triviumFPGA/Gray/']);
    
    mkdir_if_not_exist([pathCSV 'grain/RGB/']);
    mkdir_if_not_exist([pathCSV 'grain/Gray/']);
    
    mkdir_if_not_exist([pathCSV 'grainFPGA/RGB/']);
    mkdir_if_not_exist([pathCSV 'grainFPGA/Gray/']);
    
    mkdir_if_not_exist([pathCSV 'mickey/RGB/']);
    mkdir_if_not_exist([pathCSV 'mickey/Gray/']);
    
    mkdir_if_not_exist([pathCSV 'mickeyFPGA/RGB/']);
    mkdir_if_not_exist([pathCSV 'mickeyFPGA/Gray/'])
    
    
    % Path for keystream files.
    pathKEY    = ['executions/' name ' ' dateSCRIPT '/keystream/'];
    mkdir_if_not_exist(pathKEY);
    
    
    % Path for seed file.
    pathSEED    = ['executions/' name ' ' dateSCRIPT '/seed/'];
    mkdir_if_not_exist(pathSEED);
    
    
    % Create an array with all the paths.
    paths = {pathHOME, pathHIST, pathCORR, pathSENS, pathCSV, pathKEY, pathSEED};
    
    
    %% -----------------------------------------------------------------
    % --------------------------- STATISTICS --------------------------- 
    % ------------------------------------------------------------------

    
    % If image is RGB color format, that is, 3 different image planes.
    if strcmp(color, 'rgb')

        % Reset the matlab random number generator.
        rng(seed);
        
        %% CORRELATION
        
        % Calculates the correlation for key sensitivity analysis.
        
        % Red channel.
        corrKeySensitivityCipher(1)    = corr2(imgCipher(:, :, 1), imgCipherSensitivity(:, :, 1));
        corrKeySensitivityDecipher(1)  = corr2(imgDecipher(:, :, 1), imgDecipherSensitivity(:, :, 1));
        
        % Green channel.
        corrKeySensitivityCipher(2)    = corr2(imgCipher(:, :, 2), imgCipherSensitivity(:, :, 2));
        corrKeySensitivityDecipher(2)  = corr2(imgDecipher(:, :, 2), imgDecipherSensitivity(:, :, 2));
        
        % Blue channel.
        corrKeySensitivityCipher(3)    = corr2(imgCipher(:, :, 3), imgCipherSensitivity(:, :, 3));
        corrKeySensitivityDecipher(3)  = corr2(imgDecipher(:, :, 3), imgDecipherSensitivity(:, :, 3));
        
        % RGB (all channels)
        corrKeySensitivityCipherRGB    = mean([corrKeySensitivityCipher(1) corrKeySensitivityCipher(2) corrKeySensitivityCipher(3)]);
        corrKeySensitivityDecipherRGB  = mean([corrKeySensitivityDecipher(1) corrKeySensitivityDecipher(2) corrKeySensitivityDecipher(3)]);
        
        % Calculates de correlation coeficient for the plain image.
        [correlationValueRGBPlain, ...
            correlationValueRPlain, correlationValueGPlain, correlationValueBPlain, ...
            xHorzRPlain, yHorzRPlain, xVertRPlain, yVertRPlain, xDiagRPlain, ...
            yDiagRPlain, xHorzGPlain, yHorzGPlain, xVertGPlain, yVertGPlain, ...
            xDiagGPlain, yDiagGPlain, xHorzBPlain, yHorzBPlain, xVertBPlain, ...
            yVertBPlain, xDiagBPlain, yDiagBPlain, updateSamplesPlain] ...
            = correlationRGB(imgPlain, samples);
        
        % Reset the matlab random number generator.
        % Set the seed for the same used on the plain correlation above.
        rng(seed);
        
        % Calculates de correlation coeficient for the cipher image.
        [correlationValueRGBCipher, ...
            correlationValueRCipher, correlationValueGCipher, correlationValueBCipher, ...
            xHorzRCipher, yHorzRCipher, xVertRCipher, yVertRCipher, ...
            xDiagRCipher, yDiagRCipher, xHorzGCipher, yHorzGCipher, ...
            xVertGCipher, yVertGCipher, xDiagGCipher, yDiagGCipher, ...
            xHorzBCipher, yHorzBCipher, xVertBCipher, yVertBCipher, ...
            xDiagBCipher, yDiagBCipher, ~] ...
            = correlationRGB(imgCipher, samples);

        % Reset the matlab random number generator.
        % Set the seed for the same used on the plain correlation above.
        rng(seed);
        
        % Calculates de correlation coeficient for the decipher image.
        [correlationValueRGBDecipher, ...
            correlationValueRDecipher, correlationValueGDecipher, ...
            correlationValueBDecipher, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ...
            ~, ~, ~, ~, ~, ~, ~] = correlationRGB(imgDecipher, samples);
        
        
        %% DIFFERENTIAL
        
        % Calculates the differential values for the entire RGB image.
        diffusionValueRGB      = NPCR_and_UACI(imgCipher, imgCipherDiffusion, 0);
        
        % Calculates the differential values for the red channel.
        diffusionValueRed      = NPCR_and_UACI(imgCipher(:,:,1), imgCipherDiffusion(:,:,1), 0);
        
        % Calculates the differential values for the green channel.
        diffusionValueGreen    = NPCR_and_UACI(imgCipher(:,:,2), imgCipherDiffusion(:,:,2), 0);
        
        % Calculates the differential values for the blue channel.
        diffusionValueBlue     = NPCR_and_UACI(imgCipher(:,:,3), imgCipherDiffusion(:,:,3), 0);
        
        
        %% ENTROPY
        
        % Calculates the entropy values for the entire RGB image.
        entropyValueRGB = [entropy(imgPlain) entropy(imgCipher) ...
            entropy(imgDecipher)];
        
        % Calculates the entropy values for the plain image.
        entropyValuePlain = [entropy(imgPlain(:,:,1)) entropy(imgPlain(:,:,2)) ...
            entropy(imgPlain(:,:,3))];
        
        % Calculates the entropy values for the cipher image.
        entropyValueCipher = [entropy(imgCipher(:,:,1)) entropy(imgCipher(:,:,2)) ...
            entropy(imgCipher(:,:,3))];
        
        % Calculates the entropy values for the decipher image.
        entropyValueDecipher = [entropy(imgDecipher(:,:,1)) entropy(imgDecipher(:,:,2)) ...
            entropy(imgDecipher(:,:,3))];
        

    % Otherwise if image is represented by grayscale.
    else
        
        % Reset the matlab random number generator.
        rng(seed);
        
        %% CORRELATION
        
        % Calculates the correlation for key sensitivity analysis.
        corrKeySensitivityCipher    = corr2(imgCipher, imgCipherSensitivity);
        corrKeySensitivityDecipher  = corr2(imgDecipher, imgDecipherSensitivity);
        
        
        % Calculates de correlation coeficient for the plain image.
        [correlationValuePlain,  xHorzPlain,  yHorzPlain,  xVertPlain,  ...
            yVertPlain, xDiagPlain,  yDiagPlain, updateSamplesPlain] ...
            = correlationGray(imgPlain, samples);
        
        % Reset the matlab random number generator.
        % Set the seed for the same used on the plain correlation above.
        rng(seed);
        
        % Calculates de correlation coeficient for the cipher image.
        [correlationValueCipher, xHorzCipher, yHorzCipher, xVertCipher, ...
            yVertCipher, xDiagCipher, yDiagCipher, ~] ...
            = correlationGray(imgCipher, samples);

        % Reset the matlab random number generator.
        % Set the seed for the same used on the plain correlation above.
        rng(seed);
        
        % Calculates de correlation coeficient for the Decipher image.
        [correlationValueDecipher,  ~,  ~,  ~, ~, ~,  ~, ~] ...
            = correlationGray(imgDecipher, samples);
        
        
        %% DIFFERENTIAL
        
        % Calculates the differential values for the image.
        diffusionValue = NPCR_and_UACI(imgCipher, imgCipherDiffusion, 0);
        
        %% ENTROPY
        
        % Calculates the entropy values for the image.
        entropyValue = [entropy(imgPlain) entropy(imgCipher) ...
            entropy(imgDecipher)];        
        
    end
    
    % Save the random seed for future use.
    save([pathSEED '/seed.mat'], 'seed');
   
    
    %% -----------------------------------------------------------------
    % ----------------------------- PLOTS ------------------------------ 
    % ------------------------------------------------------------------

    % If image is RGB color format, that is, 3 different image planes.
    if strcmp(color, 'rgb')

        % Call the script to make the plots.
        printPlotsRGB(imgPlain, imgCipher, imgDecipher, ...
                      imgCipherSensitivity, imgDecipherSensitivity, ...
                      ...
                      corrKeySensitivityCipher, corrKeySensitivityDecipher, ...
                      ...    
                      entropyValueRGB,    entropyValuePlain, ...
                      entropyValueCipher, entropyValueDecipher, ...
                      ...
                      diffusionValueRGB,   diffusionValueRed, ...
                      diffusionValueGreen, diffusionValueBlue, ...
                      ...
                      correlationValueRGBPlain, correlationValueRGBCipher, ...
                      correlationValueRGBDecipher, ...
                      correlationValueRPlain, correlationValueRCipher, ...
                      correlationValueGPlain, correlationValueGCipher, ...
                      correlationValueBPlain, correlationValueBCipher, ...
                      xHorzRPlain,  yHorzRPlain,  xVertRPlain,  yVertRPlain, ...
                      xDiagRPlain,  yDiagRPlain,  xHorzGPlain,  yHorzGPlain, ...
                      xVertGPlain,  yVertGPlain,  xDiagGPlain,  yDiagGPlain, ...
                      xHorzBPlain,  yHorzBPlain,  xVertBPlain,  yVertBPlain, ...
                      xDiagBPlain,  yDiagBPlain,  xHorzRCipher, yHorzRCipher, ...
                      xVertRCipher, yVertRCipher, xDiagRCipher, yDiagRCipher, ...
                      xHorzGCipher, yHorzGCipher, xVertGCipher, yVertGCipher, ...
                      xDiagGCipher, yDiagGCipher, xHorzBCipher, yHorzBCipher, ...
                      xVertBCipher, yVertBCipher, xDiagBCipher, yDiagBCipher, ...
                      ...
                      paths, updateSamplesPlain); 

    % Otherwise if image is represented by shades of gray.
    else

        % Call the script to make the plots.
        printPlotsGray(imgPlain, imgCipher, imgDecipher, ...
                       imgCipherSensitivity, imgDecipherSensitivity, ...
                       corrKeySensitivityCipher, corrKeySensitivityDecipher, ...    
                       entropyValue, diffusionValue, ...
                       correlationValuePlain,   correlationValueCipher, ...
                       xHorzPlain,  yHorzPlain,  xVertPlain,  yVertPlain, ...
                       xDiagPlain,  yDiagPlain,  xHorzCipher, yHorzCipher, ...
                       xVertCipher, yVertCipher, xDiagCipher, yDiagCipher, ...
                       paths, updateSamplesPlain); 

    end

    

    %% -----------------------------------------------------------------
    % ------------------------ PIXEL INTENSITY ------------------------- 
    % ------------------------------------------------------------------
    
    % If image is RGB color format, that is, 3 different image planes.
    if strcmp(color, 'rgb')
    
        redIntensityPlain       = mean2(imgPlain(:, :, 1));
        greenIntensityPlain     = mean2(imgPlain(:, :, 2));
        blueIntensityPlain      = mean2(imgPlain(:, :, 3));

        redIntensityCipher      = mean2(imgCipher(:, :, 1));
        greenIntensityCipher    = mean2(imgCipher(:, :, 2));
        blueIntensityCipher     = mean2(imgCipher(:, :, 3));
        
        redIntensityDecipher    = mean2(imgDecipher(:, :, 1));
        greenIntensityDecipher  = mean2(imgDecipher(:, :, 2));
        blueIntensityDecipher   = mean2(imgDecipher(:, :, 3));
                
        
        % Outputs to GUI.
        entropyOUT      = entropyValueRGB;
        intensityOUT    = [redIntensityPlain greenIntensityPlain blueIntensityPlain redIntensityCipher greenIntensityCipher blueIntensityCipher redIntensityDecipher greenIntensityDecipher blueIntensityDecipher];
        correlationOUT  = [correlationValueRGBPlain(1) correlationValueRGBPlain(2) correlationValueRGBPlain(3) correlationValueRGBCipher(1) correlationValueRGBCipher(2) correlationValueRGBCipher(3) correlationValueRGBDecipher(1) correlationValueRGBDecipher(2) correlationValueRGBDecipher(3)];
        diffusionOUT    = [diffusionValueRGB.npcr_score diffusionValueRGB.uaci_score];
        sensitivityOUT  = [corrKeySensitivityCipherRGB corrKeySensitivityDecipherRGB];
        
    else
        
        intensityPlain      = mean2(imgPlain);
        intensityCipher     = mean2(imgCipher);
        intensityDecipher   = mean2(imgDecipher);
        
        
        % Outputs to GUI.
        entropyOUT      = entropyValue;
        intensityOUT    = [intensityPlain intensityCipher intensityDecipher];
        correlationOUT  = [correlationValuePlain correlationValueCipher correlationValueDecipher];
        diffusionOUT    = [diffusionValue.npcr_score diffusionValue.uaci_score];
        sensitivityOUT  = [corrKeySensitivityCipher corrKeySensitivityDecipher];
                       
    end
    
    
    
    
    
    
    %% -----------------------------------------------------------------
    % ------------------------ EXPORT KEYSTREAM ------------------------ 
    % ------------------------------------------------------------------
        
    % Checks if is necessary to generate a new keystream, or this was
    % informed in the parameters of the script.
    if keystreamRead == 0

        % Copy the keystream files to the experimenter path.
        copyfile('keystream.txt', [pathKEY '/keystream.txt']);
        copyfile('keystreamSensitivity.txt', [pathKEY '/keystreamSensitivity.txt']);

        % Delete the keystream file from the root path.
        delete('keystream.txt', 'keystreamSensitivity.txt');
    
    else
        
        % Copy the parameter informed keystream files to the experimenter path.
        copyfile(keystreamFileName, [pathKEY '/keystream.txt']);
        copyfile(keystreamSensitivityFileName, [pathKEY '/keystreamSensitivity.txt']);
        
    end
    
    %% -----------------------------------------------------------------
    % -------------------------- VERBOSE CSV --------------------------- 
    % ------------------------------------------------------------------

    % If "verbose" parameter is enable write on terminal informations about
    % the processing.
    if csv == 1
        
        % Checks the current generator and change the csv file path to the
        % correct folder.
        if strcmp(generator, 'trivium')
            
            tempPath = [pathCSV '/trivium/'];
            
        elseif strcmp(generator, 'triviumFPGA')

            tempPath = [pathCSV '/triviumFPGA/'];
            
        elseif strcmp(generator, 'grain')
            
            tempPath = [pathCSV '/grain/'];
            
        elseif strcmp(generator, 'grainFPGA')

            tempPath = [pathCSV '/grainFPGA/'];
            
        elseif strcmp(generator, 'mickey')
            
            tempPath = [pathCSV '/mickey/'];
            
        elseif strcmp(generator, 'mickeyFPGA')
            
            tempPath = [pathCSV '/mickeyFPGA/'];
        
        end
        
        % Check the color format used and completes the path.
        if strcmp(color, 'rgb')
            
            csvFileName = [tempPath '/RGB/' csvFileName];
            
        else
            
            csvFileName = [tempPath '/Gray/' csvFileName];
            
        end
                
        
        % If exists append, otherwise create the file to save statistics in .csv format.
        if exist(csvFileName, 'file') == 2
            
            
            fileCSV = fopen(csvFileName, 'a');
            
        else
            
            fileCSV = fopen(csvFileName, 'w');
            
            % Write the .csv header.
            % If image is RGB color format, that is, 3 different image planes.
            if strcmp(color, 'rgb')
            
                fprintf(fileCSV, '%s \n', ...
                      ...
                      ['script, Key, KeyS, IV, imW, imH, imD, timeKey, ' ...
                       ...
                       'tc_Dec2Bin, tc_ReshArray, tc_XOR, tc_ReshapeMatrix1, ' ...
                       'tcBin2Dec, tc_ReshapeMatrix2, tc_totalTime, ' ...
                       ...
                       'tc_diff_Dec2Bin, tc_diff_ReshArray, tc_diff_XOR, ' ...
                       'tc_diff_ReshapeMatrix1, tc_diff_Bin2Dec, tc_diff_ReshapeMatrix2, ' ...
                       'tc_diff_totalTime, ' ...
                       ...
                       'tc_sens_Dec2Bin, tc_sens_ReshArray, tc_sens_XOR, ' ...
                       'tc_sens_ReshapeMatrix1, tc_sens_Bin2Dec, tc_sens_ReshapeMatrix2, ' ...
                       'tc_sens_totalTime, ' ...
                       ...
                       'td_Dec2Bin, td_ReshArray, td_XOR, td_ReshapeMatrix1, ' ...
                       'tdBin2Dec, td_ReshapeMatrix2, td_totalTime, ' ...
                       ...
                       'td_diff_Dec2Bin, td_diff_ReshArray, td_diff_XOR, ' ...
                       'td_diff_ReshapeMatrix1, td_diff_Bin2Dec, td_diff_ReshapeMatrix2, ' ...
                       'td_diff_totalTime, ' ...
                       ...
                       'totalTime, ' ...
                       ...
                       'redIntensityPlain, greenIntensityPlain, blueIntensityPlain, ' ...
                       'redIntensityCipher, greenIntensityCipher, blueIntensityCipher, ' ...
                       'redIntensityDecipher, greenIntensityDecipher, blueIntensityDecipher, ' ...
                       ...
                       'entropyRGBPlain,    entropyRGBCipher,     entropyRGBDecipher, ' ...
                       'entropyRedPlain,    entropyGreenPlain,    entropyBluePlain, ' ...
                       'entropyRedCipher,   entropyGreenCipher,   entropyBlueCipher, ' ...
                       'entropyRedDecipher, entropyGreenDecipher, entropyBlueDecipher, ' ...
                       ...
                       'diff_RGB_NPCRscore,   diff_RGB_NPCRpval,   diff_RGB_UACIscore,   diff_RGB_UACIpval, ' ...
                       'diff_Red_NPCRscore,   diff_Red_NPCRpval,   diff_Red_UACIscore,   diff_Red_UACIpval, ' ...
                       'diff_Green_NPCRscore, diff_Green_NPCRpval, diff_Green_UACIscore, diff_Green_UACIpval, ' ...
                       'diff_Blue_NPCRscore,  diff_Blue_NPCRpval,  diff_Blue_UACIscore,  diff_Blue_UACIpval, ' ...
                       ...
                       'corr_rgbPlain_H, corr_rgbPlain_V, corr_rgbPlain_D, ' ...
                       'corr_rgbCipher_H, corr_rgbCipher_V, corr_rgbCipher_D, ' ...
                       'corr_rgbDecipher_H, corr_rgbDecipher_V, corr_rgbDecipher_D, ' ...
                       ...
                       'corr_redPlain_H, corr_redPlain_V, corr_redPlain_D, ' ...
                       'corr_greenPlain_H, corr_greenPlain_V, corr_greenPlain_D, ' ...
                       'corr_bluePlain_H, corr_bluePlain_V, corr_bluePlain_D, ' ...
                       ...
                       'corr_redCipher_H, corr_redCipher_V, corr_redCipher_D, ' ...
                       'corr_greenCipher_H, corr_greenCipher_V, corr_greenCipher_D, ' ...
                       'corr_blueCipher_H, corr_blueCipher_V, corr_blueCipher_D, ' ...
                       ...
                       'corr_redDecipher_H, corr_redDecipher_V, corr_redDecipher_D, ' ...
                       'corr_greenDecipher_H, corr_greenDecipher_V, corr_greenDecipher_D, ' ...
                       'corr_blueDecipher_H, corr_blueDecipher_V, corr_blueDecipher_D, ' ...
                       ...
                       'corr_RGBKeySensCipher,' 'corr_redKeySensCipher, corr_greenKeySensCipher, corr_blueKeySensCipher, ' ...
                       ...
                       'corr_RGBKeySensDecipher,' 'corr_redKeySensDecipher, corr_greenKeySensDecipher, corr_blueKeySensDecipher ' ...                   
                     ]);
                 
            else
                
                fprintf(fileCSV, '%s \n', ...
                      ...
                      ['script, Key, KeyS, IV, imW, imH, imD, timeKey, ' ...
                       ...
                       'tc_Dec2Bin, tc_ReshArray, tc_XOR, tc_ReshapeMatrix1, ' ...
                       'tcBin2Dec, tc_ReshapeMatrix2, tc_totalTime, ' ...
                       ...
                       'tc_diff_Dec2Bin, tc_diff_ReshArray, tc_diff_XOR, ' ...
                       'tc_diff_ReshapeMatrix1, tc_diff_Bin2Dec, tc_diff_ReshapeMatrix2, ' ...
                       'tc_diff_totalTime, ' ...
                       ...
                       'tc_sens_Dec2Bin, tc_sens_ReshArray, tc_sens_XOR, ' ...
                       'tc_sens_ReshapeMatrix1, tc_sens_Bin2Dec, tc_sens_ReshapeMatrix2, ' ...
                       'tc_sens_totalTime, ' ...
                       ...
                       'td_Dec2Bin, td_ReshArray, td_XOR, td_ReshapeMatrix1, ' ...
                       'tdBin2Dec, td_ReshapeMatrix2, td_totalTime, ' ...
                       ...
                       'td_diff_Dec2Bin, td_diff_ReshArray, td_diff_XOR, ' ...
                       'td_diff_ReshapeMatrix1, td_diff_Bin2Dec, td_diff_ReshapeMatrix2, ' ...
                       'td_diff_totalTime, ' ...
                       ...
                       'totalTime, ' ...
                       ...
                       'intensityPlain, intensityCipher, intensityDecipher, ' ...
                       ...
                       'entropyPlain, entropyCipher, entropyDecipher, ' ...
                       ...
                       'diff_NPCRscore, diff_NPCRpval, diff_UACIscore, diff_UACIpval, ' ...
                       ...
                       'corr_plain_H, corr_plain_V, corr_plain_D, ' ...
                       ...
                       'corr_cipher_H, corr_cipher_V, corr_cipher_D, ' ...
                       ...
                       'corr_decipher_H, corr_decipher_V, corr_decipher_D, ' ...
                       ...
                       'corr_keySensCipher, corr_keySensDecipher ' ...                  
                     ]);
                 
            end
            
        end
        
        
        % Converts the Key Sensitivity cell to string array.
        tempHexKeySensitivity = '';
        for z = 1:20
            tempHexKeySensitivity = strcat(tempHexKeySensitivity, hexKeySensitivity(z));
        end
        hexKeySensitivity = char(tempHexKeySensitivity);
        sprintf('%s', hexKeySensitivity)
        
        
        % If image is RGB color format, that is, 3 different image planes.
        if strcmp(color, 'rgb')

            fprintf(fileCSV, '%s \n', ...
                  ...
                  [dateSCRIPT ',' sprintf('%s', hexKey) ',' ...
                  sprintf('%s', hexKeySensitivity) ',' sprintf('%s', hexIV) ',' ...
                  ...
                  num2str(w) ',' num2str(h) ',' num2str(d) ',' ...
                  ...
                  num2str(keystreamTime,' %.6f')  ',' num2str(cipherTime(2),' %.6f') ',' ...
                  num2str(cipherTime(3),' %.6f')  ',' num2str(cipherTime(4),' %.6f') ',' ...
                  num2str(cipherTime(5),' %.6f')  ',' num2str(cipherTime(6),' %.6f') ',' ...
                  num2str(cipherTime(7),' %.6f')  ',' num2str(cipherTime(1),' %.6f') ',' ...
                  ...
                  num2str(cipherTime2(2),' %.6f') ',' num2str(cipherTime2(3),' %.6f') ',' ...
                  num2str(cipherTime2(4),' %.6f') ',' num2str(cipherTime2(5),' %.6f') ',' ...
                  num2str(cipherTime2(6),' %.6f') ',' num2str(cipherTime2(7),' %.6f') ',' ...
                  num2str(cipherTime2(1),' %.6f') ',' ...
                  ...
                  num2str(cipherTime3(2),' %.6f') ',' num2str(cipherTime3(3),' %.6f') ',' ...
                  num2str(cipherTime3(4),' %.6f') ',' num2str(cipherTime3(5),' %.6f') ',' ...
                  num2str(cipherTime3(6),' %.6f') ',' num2str(cipherTime3(7),' %.6f') ',' ...
                  num2str(cipherTime3(1),' %.6f') ',' ...
                  ...
                  num2str(decipherTime(2),' %.6f') ',' num2str(decipherTime(3),' %.6f') ',' ...
                  num2str(decipherTime(4),' %.6f') ',' num2str(decipherTime(5),' %.6f') ',' ...
                  num2str(decipherTime(6),' %.6f') ',' num2str(decipherTime(7),' %.6f') ',' ...
                  num2str(decipherTime(1),' %.6f') ',' ...
                  ...
                  num2str(decipherTime2(2),' %.6f') ',' num2str(decipherTime2(3),' %.6f') ',' ...
                  num2str(decipherTime2(4),' %.6f') ',' num2str(decipherTime2(5),' %.6f') ',' ...
                  num2str(decipherTime2(6),' %.6f') ',' num2str(decipherTime2(7),' %.6f') ',' ...
                  num2str(decipherTime2(1),' %.6f') ',' ...
                  ...
                  num2str(totalTime,' %.6f'), ',' ...
                  ...
                  num2str(redIntensityPlain,    '%.6f') ',' num2str(greenIntensityPlain,'%.6f')    ',' ...
                  num2str(blueIntensityPlain,   '%.6f') ',' num2str(redIntensityCipher, '%.6f')    ',' ...
                  num2str(greenIntensityCipher, '%.6f') ',' num2str(blueIntensityCipher,'%.6f')    ',' ...
                  num2str(redIntensityDecipher, '%.6f') ',' num2str(greenIntensityDecipher,'%.6f') ',' ...
                  num2str(blueIntensityDecipher,'%.6f') ',' ...
                  ...
                  num2str(entropyValueRGB(1),'%.6f')      ',' num2str(entropyValueRGB(2),'%.6f')      ',' ...
                  num2str(entropyValueRGB(3),'%.6f')      ',' ...
                  num2str(entropyValuePlain(1),'%.6f')    ',' num2str(entropyValuePlain(2),'%.6f')    ',' ...
                  num2str(entropyValuePlain(3),'%.6f')    ',' ...
                  num2str(entropyValueCipher(1),'%.6f')   ',' num2str(entropyValueCipher(2),'%.6f')   ',' ...
                  num2str(entropyValueCipher(3),'%.6f')   ',' ...
                  num2str(entropyValueDecipher(1),'%.6f') ',' num2str(entropyValueDecipher(2),'%.6f') ',' ...
                  num2str(entropyValueDecipher(3),'%.6f') ',' ...
                  ...
                  num2str(diffusionValueRGB.npcr_score,'%.6f')   ',' num2str(diffusionValueRGB.npcr_pVal,'%.6f')   ',' ...
                  num2str(diffusionValueRGB.uaci_score,'%.6f')   ',' num2str(diffusionValueRGB.uaci_pVal,'%.6f')   ',' ...
                  num2str(diffusionValueRed.npcr_score,'%.6f')   ',' num2str(diffusionValueRed.npcr_pVal,'%.6f')   ',' ...
                  num2str(diffusionValueRed.uaci_score,'%.6f')   ',' num2str(diffusionValueRed.uaci_pVal,'%.6f')   ',' ...
                  num2str(diffusionValueGreen.npcr_score,'%.6f') ',' num2str(diffusionValueGreen.npcr_pVal,'%.6f') ',' ...
                  num2str(diffusionValueGreen.uaci_score,'%.6f') ',' num2str(diffusionValueGreen.uaci_pVal,'%.6f') ',' ...
                  num2str(diffusionValueBlue.npcr_score,'%.6f')  ',' num2str(diffusionValueBlue.npcr_pVal,'%.6f')  ',' ...
                  num2str(diffusionValueBlue.uaci_score,'%.6f')  ',' num2str(diffusionValueBlue.uaci_pVal,'%.6f')  ',' ...
                  ...
                  num2str(correlationValueRGBPlain(1),'%.6f')    ',' num2str(correlationValueRGBPlain(2),'%.6f')    ',' ...
                  num2str(correlationValueRGBPlain(3),'%.6f')    ',' num2str(correlationValueRGBCipher(1),'%.6f')   ',' ...
                  num2str(correlationValueRGBCipher(2),'%.6f')   ',' num2str(correlationValueRGBCipher(3),'%.6f')   ',' ...
                  num2str(correlationValueRGBDecipher(1),'%.6f') ',' num2str(correlationValueRGBDecipher(2),'%.6f') ',' ...
                  num2str(correlationValueRGBDecipher(3),'%.6f') ',' ...
                  ...
                  num2str(correlationValueRPlain(1),'%.6f') ',' num2str(correlationValueGPlain(1),'%.6f') ',' ...
                  num2str(correlationValueBPlain(1),'%.6f') ',' num2str(correlationValueRPlain(2),'%.6f') ',' ...
                  num2str(correlationValueGPlain(2),'%.6f') ',' num2str(correlationValueBPlain(2),'%.6f') ',' ...
                  num2str(correlationValueRPlain(3),'%.6f') ',' num2str(correlationValueGPlain(3),'%.6f') ',' ...
                  num2str(correlationValueBPlain(3),'%.6f') ',' ...
                  ...
                  num2str(correlationValueRCipher(1),'%.6f') ',' num2str(correlationValueGCipher(1),'%.6f') ',' ...
                  num2str(correlationValueBCipher(1),'%.6f') ',' num2str(correlationValueRCipher(2),'%.6f') ',' ...
                  num2str(correlationValueGCipher(2),'%.6f') ',' num2str(correlationValueBCipher(2),'%.6f') ',' ...
                  num2str(correlationValueRCipher(3),'%.6f') ',' num2str(correlationValueGCipher(3),'%.6f') ',' ...
                  num2str(correlationValueBCipher(3),'%.6f') ',' ...
                  ...
                  num2str(correlationValueRDecipher(1),'%.6f') ',' num2str(correlationValueGDecipher(1),'%.6f') ',' ...
                  num2str(correlationValueBDecipher(1),'%.6f') ',' num2str(correlationValueRDecipher(2),'%.6f') ',' ...
                  num2str(correlationValueGDecipher(2),'%.6f') ',' num2str(correlationValueBDecipher(2),'%.6f') ',' ...
                  num2str(correlationValueRDecipher(3),'%.6f') ',' num2str(correlationValueGDecipher(3),'%.6f') ',' ...
                  num2str(correlationValueBDecipher(3),'%.6f') ',' ...
                  ...
                  num2str(corrKeySensitivityCipherRGB,    ' %.6f') ',' num2str(corrKeySensitivityCipher(1),  ' %.6f') ',' ...
                  num2str(corrKeySensitivityCipher(2),    ' %.6f') ',' num2str(corrKeySensitivityCipher(3),  ' %.6f') ',' ...
                  num2str(corrKeySensitivityDecipherRGB,  ' %.6f') ',' num2str(corrKeySensitivityDecipher(1),' %.6f') ',' ...
                  num2str(corrKeySensitivityDecipher(1),  ' %.6f') ',' num2str(corrKeySensitivityDecipher(3),' %.6f')
               ]);
              
        else
           
            
            fprintf(fileCSV, '%s \n', ...
                  [dateSCRIPT ',' sprintf('%s', hexKey) ',' ...
                  sprintf('%s', hexKeySensitivity) ',' sprintf('%s', hexIV) ',' ...
                  ...
                  num2str(w) ',' num2str(h) ',' num2str(d) ',' ...
                  ...
                  num2str(keystreamTime,' %.6f')  ',' num2str(cipherTime(2),' %.6f') ',' ...
                  num2str(cipherTime(3),' %.6f')  ',' num2str(cipherTime(4),' %.6f') ',' ...
                  num2str(cipherTime(5),' %.6f')  ',' num2str(cipherTime(6),' %.6f') ',' ...
                  num2str(cipherTime(7),' %.6f')  ',' num2str(cipherTime(1),' %.6f') ',' ...
                  ...
                  num2str(cipherTime2(2),' %.6f') ',' num2str(cipherTime2(3),' %.6f') ',' ...
                  num2str(cipherTime2(4),' %.6f') ',' num2str(cipherTime2(5),' %.6f') ',' ...
                  num2str(cipherTime2(6),' %.6f') ',' num2str(cipherTime2(7),' %.6f') ',' ...
                  num2str(cipherTime2(1),' %.6f') ',' ...
                  ...
                  num2str(cipherTime3(2),' %.6f') ',' num2str(cipherTime3(3),' %.6f') ',' ...
                  num2str(cipherTime3(4),' %.6f') ',' num2str(cipherTime3(5),' %.6f') ',' ...
                  num2str(cipherTime3(6),' %.6f') ',' num2str(cipherTime3(7),' %.6f') ',' ...
                  num2str(cipherTime3(1),' %.6f') ',' ...
                  ...
                  num2str(decipherTime(2),' %.6f') ',' num2str(decipherTime(3),' %.6f') ',' ...
                  num2str(decipherTime(4),' %.6f') ',' num2str(decipherTime(5),' %.6f') ',' ...
                  num2str(decipherTime(6),' %.6f') ',' num2str(decipherTime(7),' %.6f') ',' ...
                  num2str(decipherTime(1),' %.6f') ',' ...
                  ...
                  num2str(decipherTime2(2),' %.6f') ',' num2str(decipherTime2(3),' %.6f') ',' ...
                  num2str(decipherTime2(4),' %.6f') ',' num2str(decipherTime2(5),' %.6f') ',' ...
                  num2str(decipherTime2(6),' %.6f') ',' num2str(decipherTime2(7),' %.6f') ',' ...
                  num2str(decipherTime2(1),' %.6f') ',' ...
                  ...
                  num2str(totalTime,' %.6f'), ',' ...
                  ...
                  num2str(intensityPlain,    '%.6f') ',' num2str(intensityCipher,'%.6f') ',' ...
                  num2str(intensityDecipher, '%.6f') ',', ...
                  ...
                  num2str(entropyValue(1),'%.6f') ',' num2str(entropyValue(2),'%.6f') ',' ...
                  num2str(entropyValue(2),'%.6f') ',' ...
                  ...
                  num2str(diffusionValue.npcr_score, '%.6f') ',' num2str(diffusionValue.npcr_pVal, '%.6f') ',' ...
                  num2str(diffusionValue.uaci_score, '%.6f') ',' num2str(diffusionValue.uaci_pVal, '%.6f') ',' ...
                  ...
                  num2str(correlationValuePlain(1),   '%.6f') ',' num2str(correlationValuePlain(2),    '%.6f') ',' ...
                  num2str(correlationValuePlain(3),   '%.6f') ',' num2str(correlationValueCipher(1),   '%.6f') ',' ...
                  num2str(correlationValueCipher(2),  '%.6f') ',' num2str(correlationValueCipher(3),   '%.6f') ',' ...
                  num2str(correlationValueDecipher(1),'%.6f') ',' num2str(correlationValueDecipher(2), '%.6f') ',' ...
                  num2str(correlationValueDecipher(3),'%.6f') ',' ...
                  ...
                  num2str(corrKeySensitivityCipher,  ' %.6f') ',' num2str(corrKeySensitivityDecipher,  ' %.6f')
               ]);
           
        end
        
        % Close the file.
        fclose(fileCSV);
        
    end
    
    
    
    %% -----------------------------------------------------------------
    % ---------------------------- VERBOSE ----------------------------- 
    % ------------------------------------------------------------------
    
    % Clear the prompt.
    clc
    
    % If "verbose" parameter is enable write on terminal informations about
    % the processing.
    if verbose == 1
        
        % Creates a file to save the text displayed in the console.
        diary([pathHOME '/outputAnalysis.txt']);
        
        fprintf('\n');
        disp('###############################################');
        fprintf('\n');
        
        %if keystreamRead == 0
        
            fprintf('\n');
            disp('-----------------------------------------------');
            disp('----------------- KEY DETAILS -----------------');
            disp('-----------------------------------------------');
            fprintf('\n');
            disp('Key: ');
            disp(['        ', sprintf('%s', hexKey)]);
            str = mat2str(double(binKey));
            n   = size(str,1);
            str = str(str~=' ');
            str = reshape(str, n, []);
            str = strrep(str,'[','');
            str = strrep(str,']','');
            str = strrep(str,';','');
            disp(['        ', sprintf('%c', str)]);
            fprintf('\n');
            fprintf('\n');
            
            disp('Key Modified: ');
            disp(['        ', sprintf('%s', hexKeySensitivity)]);
            str = mat2str(double(binKeySensitivity));
            n   = size(str,1);
            str = str(str~=' ');
            str = reshape(str, n, []);
            str = strrep(str,'[','');
            str = strrep(str,']','');
            str = strrep(str,';','');
            disp(['        ', sprintf('%c', str)]);
            fprintf('\n');
            fprintf('\n');
            
            disp('IV: ');
            disp(['        ', sprintf('%s', hexIV)]);
            str = mat2str(double(binIV));
            n   = size(str,1);
            str = str(str~=' ');
            str = reshape(str, n, []);
            str = strrep(str,'[','');
            str = strrep(str,']','');
            str = strrep(str,';','');
            disp(['        ', sprintf('%c', str)]);
            fprintf('\n');
        
        %end
        
        fprintf('\n');
        disp('-----------------------------------------------');
        disp('---------------- IMAGE DETAILS ----------------');
        disp('-----------------------------------------------');
        fprintf('\n');
        disp(['Size: ', num2str(w) 'x' num2str(h) 'x' num2str(d)]);
        fprintf('\n');
        
        fprintf('\n');
        disp('-----------------------------------------------');
        disp('---------------- TIME ANALYSIS ----------------');
        disp('-----------------------------------------------');
        fprintf('\n');
        disp(['Keystream Time: ', num2str(keystreamTime, '%.6f'), 's']);
        fprintf('\n');
        
        disp('----------------- Cipher Time -----------------');
        disp(['[Cipher] dec2bin               : ', ...
            num2str(cipherTime(2), '%.6f'), 's']);
        
        disp(['[Cipher] reshape -> array      : ', ...
            num2str(cipherTime(3), '%.6f'), 's']);
        
        disp(['[Cipher] XOR                   : ', ...
            num2str(cipherTime(4), '%.6f'), 's']);
        
        disp(['[Cipher] reshape -> matrix bin : ', ...
            num2str(cipherTime(5), '%.6f'), 's']);
        
        disp(['[Cipher] bin2dec               : ', ...
            num2str(cipherTime(6), '%.6f'), 's']);
        
        disp(['[Cipher] reshape -> matrix dec : ', ...
            num2str(cipherTime(7), '%.6f'), 's']);
        
        disp('-----------------------------------------------');
        disp(['[Cipher]                  TOTAL: ', ...
            num2str(cipherTime(1), '%.6f'), 's']);
        disp('-----------------------------------------------');
        fprintf('\n');
        
        disp('---------- Cipher Time 2 (differential) ----------');
        disp(['[Cipher 2]                 TOTAL: ', ...
            num2str(cipherTime2(1), '%.6f'), 's']);
        disp('-----------------------------------------------');
        fprintf('\n');
        
        disp('------- Cipher Time 3 (KEY SENSITIVITY) -------');
        disp(['[Cipher 3]                 TOTAL: ', ...
            num2str(cipherTime3(1), '%.6f'), 's']);
        disp('-----------------------------------------------');
        fprintf('\n');
        
        disp('---------------- Decipher Time ----------------');
        disp(['[Decipher] dec2bin               : ', ...
            num2str(decipherTime(2), '%.6f'), 's']);
        
        disp(['[Decipher] reshape -> array      : ', ...
            num2str(decipherTime(3), '%.6f'), 's']);
        
        disp(['[Decipher] XOR                   : ', ...
            num2str(decipherTime(4), '%.6f'), 's']);
        
        disp(['[Decipher] reshape -> matrix bin : ', ...
            num2str(decipherTime(5), '%.6f'), 's']);
        
        disp(['[Decipher] bin2dec               : ', ...
            num2str(decipherTime(6), '%.6f'), 's']);
        
        disp(['[Decipher] reshape -> matrix dec : ', ...
            num2str(decipherTime(7), '%.6f'), 's']);
        
        disp('-----------------------------------------------');
        disp(['[Decipher]                  TOTAL: ', ...
            num2str(decipherTime(1), '%.6f'), 's']);
        disp('-----------------------------------------------');
        fprintf('\n');
        
        disp('------ Decipher Time 3 (KEY SENSITIVITY) ------');
        disp(['[Decipher 2]                  TOTAL: ', ...
            num2str(decipherTime2(1), '%.6f'), 's']);
        disp('-----------------------------------------------');
        fprintf('\n');
        
        disp('-----------------------------------------------');
        fprintf('\t\t\t');
        disp(['TOTAL TIME: ', num2str(totalTime, '%.6f'), 's']);
        disp('-----------------------------------------------');
        
        fprintf('\n');
        disp('###############################################');
        fprintf('\n');
        
        fprintf('\n');
        disp('-----------------------------------------------');
        disp('--------------- AVERAGE INTENSITY -------------');
        disp('-----------------------------------------------');
        fprintf('\n');
        
        % If image is RGB color format, that is, 3 different image planes.
        if strcmp(color, 'rgb')
        
            % Plain image
            disp(['Plain:    (R: ', num2str(redIntensityPlain,   '%.6f'), ...
                            ' G: ', num2str(greenIntensityPlain, '%.6f'), ...
                            ' B: ', num2str(blueIntensityPlain,  '%.6f'), ')']);
                  
            % Cipher image
            disp(['Cipher:   (R: ', num2str(redIntensityCipher,  '%.6f'), ...
                            ' G: ', num2str(greenIntensityCipher,'%.6f'), ...
                            ' B: ', num2str(blueIntensityCipher, '%.6f'), ')']);
            
            % Decipher image
            disp(['Decipher: (R: ', num2str(redIntensityDecipher,  '%.6f'), ...
                            ' G: ', num2str(greenIntensityDecipher,'%.6f'), ...
                            ' B: ', num2str(blueIntensityDecipher, '%.6f'), ')']);
            
        else
           
            % Plain image
            disp(['Plain:    ', num2str(intensityPlain,'%.6f')]);
                  
            % Cipher image
            disp(['Cipher:   ', num2str(intensityCipher,'%.6f')]);
            
            % Decipher image
            disp(['Decipher: ', num2str(intensityDecipher,'%.6f')]);
            
        end
        fprintf('\n');
        
        
        fprintf('\n');
        disp('-----------------------------------------------');
        disp('--------------- ENTROPY ANALYSIS --------------');
        disp('-----------------------------------------------');
        fprintf('\n');
        
        % If image is RGB color format, that is, 3 different image planes.
        if strcmp(color, 'rgb')
            
            % RGB
            disp('RGB IMAGE')
            fprintf('\n');
            
            disp(['Plain:    ', num2str(entropyValueRGB(1),'%.6f')]);
            disp(['Cipher:   ', num2str(entropyValueRGB(2),'%.6f')]);
            disp(['Decipher: ', num2str(entropyValueRGB(3),'%.6f')]);
            fprintf('\n');
            
            % Plain
            fprintf('\n');
            disp('PLAIN IMAGE')
            fprintf('\n');
            
            disp(['Red:    ', num2str(entropyValuePlain(1),'%.6f')]);
            disp(['Green:  ', num2str(entropyValuePlain(2),'%.6f')]);
            disp(['Blue:   ', num2str(entropyValuePlain(3),'%.6f')]);
            fprintf('\n');
            
            % Cipher
            fprintf('\n');
            disp('CIPHER IMAGE')
            fprintf('\n');
            
            disp(['Red:    ', num2str(entropyValueCipher(1),'%.6f')]);
            disp(['Green:  ', num2str(entropyValueCipher(2),'%.6f')]);
            disp(['Blue:   ', num2str(entropyValueCipher(3),'%.6f')]);
            fprintf('\n');
            
            % Decipher
            fprintf('\n');
            disp('DECIPHER IMAGE')
            fprintf('\n');
            
            disp(['Red:    ', num2str(entropyValueDecipher(1),'%.6f')]);
            disp(['Green:  ', num2str(entropyValueDecipher(2),'%.6f')]);
            disp(['Blue:   ', num2str(entropyValueDecipher(3),'%.6f')]);
            fprintf('\n');
            
        else
            
            disp(['Plain:    ', num2str(entropyValue(1),'%.6f')]);
            disp(['Cipher:   ', num2str(entropyValue(2),'%.6f')]);
            disp(['Decipher: ', num2str(entropyValue(3),'%.6f')]);
            fprintf('\n');
            
        end
            
            
        
        fprintf('\n');
        disp('###############################################');
        fprintf('\n');
        
        fprintf('\n');
        disp('-----------------------------------------------');
        disp('------------ DIFFERENTIAL ANALYSIS ------------');
        disp('-----------------------------------------------');
        fprintf('\n');
        
        
        % If image is RGB color format, that is, 3 different image planes.
        if strcmp(color, 'rgb')
            
            % RGB
            disp('RGB IMAGE')
            fprintf('\n');
            
            disp(['NPCR Score:    ', num2str(diffusionValueRGB.npcr_score,'%.6f')]);
            disp(['NPCR pValue:   ', num2str(diffusionValueRGB.npcr_pVal, '%.6f')]);
            fprintf('\n');
            disp(['UACI Score:    ', num2str(diffusionValueRGB.uaci_score,'%.6f')]);
            disp(['UACI pValue:   ', num2str(diffusionValueRGB.uaci_pVal, '%.6f')]);
            fprintf('\n');
            
            % Red Channel
            fprintf('\n');
            disp('Red Channel')
            fprintf('\n');
            
            disp(['NPCR Score:    ', num2str(diffusionValueRed.npcr_score,'%.6f')]);
            disp(['NPCR pValue:   ', num2str(diffusionValueRed.npcr_pVal, '%.6f')]);
            fprintf('\n');
            disp(['UACI Score:    ', num2str(diffusionValueRed.uaci_score,'%.6f')]);
            disp(['UACI pValue:   ', num2str(diffusionValueRed.uaci_pVal, '%.6f')]);
            fprintf('\n');
            
            % Cipher
            fprintf('\n');
            disp('Green Channel')
            fprintf('\n');
            
            disp(['NPCR Score:    ', num2str(diffusionValueGreen.npcr_score,'%.6f')]);
            disp(['NPCR pValue:   ', num2str(diffusionValueGreen.npcr_pVal, '%.6f')]);
            fprintf('\n');
            disp(['UACI Score:    ', num2str(diffusionValueGreen.uaci_score,'%.6f')]);
            disp(['UACI pValue:   ', num2str(diffusionValueGreen.uaci_pVal, '%.6f')]);
            fprintf('\n');
            
            % Decipher
            fprintf('\n');
            disp('Blue Channel')
            fprintf('\n');
            
            disp(['NPCR Score:    ', num2str(diffusionValueBlue.npcr_score,'%.6f')]);
            disp(['NPCR pValue:   ', num2str(diffusionValueBlue.npcr_pVal, '%.6f')]);
            fprintf('\n');
            disp(['UACI Score:    ', num2str(diffusionValueBlue.uaci_score,'%.6f')]);
            disp(['UACI pValue:   ', num2str(diffusionValueBlue.uaci_pVal, '%.6f')]);
            fprintf('\n');
            
        else
            
            disp(['NPCR Score:    ', num2str(diffusionValue.npcr_score,'%.6f')]);
            disp(['NPCR pValue:   ', num2str(diffusionValue.npcr_pVal, '%.6f')]);
            fprintf('\n');
            disp(['UACI Score:    ', num2str(diffusionValue.uaci_score,'%.6f')]);
            disp(['UACI pValue:   ', num2str(diffusionValue.uaci_pVal, '%.6f')]);
            fprintf('\n');
            
        end
        
        fprintf('\n');
        disp('###############################################');
        fprintf('\n');
        
        fprintf('\n');
        disp('-----------------------------------------------');
        disp('------------- CORRELATION ANALYSIS ------------');
        disp('-----------------------------------------------');
        fprintf('\n');
        
        % If image is RGB color format, that is, 3 different image planes.
        if strcmp(color, 'rgb')
            
            % All channels together analysis (mean of separated channels).
            disp('---------------- All Channels ----------------');
            fprintf('\n');
            
            % Plain
            disp('PLAIN IMAGE')
            fprintf('\n');
            
            disp(['(H: ',   num2str(correlationValueRGBPlain(1),'%.6f'), ...
                '  V: ',    num2str(correlationValueRGBPlain(2),'%.6f'), ...
                '  D: ',    num2str(correlationValueRGBPlain(3),'%.6f'), ')']);
            
            % Cipher
            fprintf('\n');
            disp('CIPHER IMAGE')
            fprintf('\n');
            
            disp(['(H: ',   num2str(correlationValueRGBCipher(1),'%.6f'), ...
                '  V: ',    num2str(correlationValueRGBCipher(2),'%.6f'), ...
                '  D: ',    num2str(correlationValueRGBCipher(3),'%.6f'), ')']);
            
            % Decipher
            fprintf('\n');
            disp('DECIPHER IMAGE')
            fprintf('\n');
            
            disp(['(H: ',   num2str(correlationValueRGBDecipher(1),'%.6f'), ...
                '  V: ',    num2str(correlationValueRGBDecipher(2),'%.6f'), ...
                '  D: ',    num2str(correlationValueRGBDecipher(3),'%.6f'), ')']);
            
            
            
            % Separated channels analysis.
            fprintf('\n');
            fprintf('\n');
            disp('---------------- Separated Channels ----------------');
            fprintf('\n');
            
            disp('PLAIN IMAGE')
            fprintf('\n');
            
            % Horizontal
            disp(['H (R: ', num2str(correlationValueRPlain(1),'%.6f'), ...
                '  G: ',    num2str(correlationValueGPlain(1),'%.6f'), ...
                '  B: ',    num2str(correlationValueBPlain(1),'%.6f'), ')']);
            
            % Vertical
            disp(['V (R: ', num2str(correlationValueRPlain(2),'%.6f'), ...
                '  G: ',    num2str(correlationValueGPlain(2),'%.6f'), ...
                '  B: ',    num2str(correlationValueBPlain(2),'%.6f'), ')']);
            
            % Diagonal
            disp(['D (R: ', num2str(correlationValueRPlain(3),'%.6f'), ...
                '  G: ',    num2str(correlationValueGPlain(3),'%.6f'), ...
                '  B: ',    num2str(correlationValueBPlain(3),'%.6f'), ')']);
            
            
            fprintf('\n');
            disp('CIPHER IMAGE')
            fprintf('\n');
            
            
            % Horizontal
            disp(['H (R: ', num2str(correlationValueRCipher(1),'%.6f'), ...
                '  G: ',    num2str(correlationValueGCipher(1),'%.6f'), ...
                '  B: ',    num2str(correlationValueBCipher(1),'%.6f'), ')']);
            
            % Vertical
            disp(['V (R: ', num2str(correlationValueRCipher(2),'%.6f'), ...
                '  G: ',    num2str(correlationValueGCipher(2),'%.6f'), ...
                '  B: ',    num2str(correlationValueBCipher(2),'%.6f'), ')']);
            
            % Diagonal
            disp(['D (R: ', num2str(correlationValueRCipher(3),'%.6f'), ...
                '  G: ',    num2str(correlationValueGCipher(3),'%.6f'), ...
                '  B: ',    num2str(correlationValueBCipher(3),'%.6f'), ')']);
            
            
            fprintf('\n');
            disp('DECIPHER IMAGE')
            fprintf('\n');
            
            
            % Horizontal
            disp(['H (R: ', num2str(correlationValueRDecipher(1),'%.6f'), ...
                '  G: ',    num2str(correlationValueGDecipher(1),'%.6f'), ...
                '  B: ',    num2str(correlationValueBDecipher(1),'%.6f'), ')']);
            
            % Vertical
            disp(['V (R: ', num2str(correlationValueRDecipher(2),'%.6f'), ...
                '  G: ',    num2str(correlationValueGDecipher(2),'%.6f'), ...
                '  B: ',    num2str(correlationValueBDecipher(2),'%.6f'), ')']);
            
            % Diagonal
            disp(['D (R: ', num2str(correlationValueRDecipher(3),'%.6f'), ...
                '  G: ',    num2str(correlationValueGDecipher(3),'%.6f'), ...
                '  B: ',    num2str(correlationValueBDecipher(3),'%.6f'), ')']);
            
        % otherwise if the image is represented in gray scale.
        else
            
            % PLAIN IMAGE
            disp('PLAIN IMAGE')
            fprintf('\n');
            
            % Horizontal
            disp(['Horizontal:  ', ...
                num2str(correlationValuePlain(1),'%.6f')]); 
            
            % Vertical
            disp(['Vertical:    ', ...
                num2str(correlationValuePlain(2),'%.6f')]); 
            
            % Diagonal
            disp(['Diagonal:    ', ...
                num2str(correlationValuePlain(3),'%.6f')]); 
            
            
            % CIPHER IMAGE
            fprintf('\n');
            disp('PLAIN IMAGE')
            fprintf('\n');
            
            
            % Horizontal
            disp(['Horizontal:  ', ...
                num2str(correlationValueCipher(1),'%.6f')]); 
            
            % Vertical
            disp(['Vertical:    ', ...
                num2str(correlationValueCipher(2),'%.6f')]); 
            
            % Diagonal
            disp(['Diagonal:    ', ...
                num2str(correlationValueCipher(3),'%.6f')]); 
            
            
            % DECIPHER IMAGE
            fprintf('\n');
            disp('DECIPHER IMAGE')
            fprintf('\n');
            
            
            % Horizontal
            disp(['Horizontal:  ', ...
                num2str(correlationValueDecipher(1),'%.6f')]); 
            
            % Vertical
            disp(['Vertical:    ', ...
                num2str(correlationValueDecipher(2),'%.6f')]); 
            
            % Diagonal
            disp(['Diagonal:    ', ...
                num2str(correlationValueDecipher(3),'%.6f')]);
            
        end
        
        
        % If image is RGB color format, that is, 3 different image planes.
        if strcmp(color, 'rgb')
        
            fprintf('\n');
            disp('-----------------------------------------------');
            disp('----------- KEY SENSITIVITY ANALYSIS ----------');
            disp('-----------------------------------------------');
            fprintf('\n');
            disp(['Cipher K1   -> Cipher K2:    (', num2str(corrKeySensitivityCipher,' %.6f') ')']);
            disp(['Decipher K1 -> Decipher K2:  (', num2str(corrKeySensitivityDecipher,' %.6f') ')']);
            fprintf('\n');
            
        % Otherwise if the image is represented in gray scale.
        else
            
            fprintf('\n');
            disp('-----------------------------------------------');
            disp('----------- KEY SENSITIVITY ANALYSIS ----------');
            disp('-----------------------------------------------');
            fprintf('\n');
            disp(['Cipher K1   -> Cipher K2:    ', num2str(corrKeySensitivityCipher,'%.6f')]);
            disp(['Decipher K1 -> Decipher K2:  ', num2str(corrKeySensitivityDecipher,'%.6f')]);
            fprintf('\n');
            
        end
        
       
        fprintf('\n');
        disp('###############################################');
        fprintf('\n');
        
        % Close the file.
        diary('off');
        
    end
    
    set(groot,'defaultFigureVisible','on');
    
end