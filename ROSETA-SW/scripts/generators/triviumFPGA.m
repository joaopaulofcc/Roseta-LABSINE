%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#    Script responsible to communicate with Trivium (ROSETA) in FPGA.   #
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
%# File: triviumFPGA.m                                                   #
%#                                                                       #
%# About: This file describe a script which handle with the trivium in   #
%#        FPGA, it reset the circuit, configure the key and iv, and run  #
%#        the generator capturing the pseudorandom bytes over UART and   #
%#        saving the final sequence in a text file wich will be used for #
%#        image cipher/decipher later.                                   #
%#                                                                       #
%# INPUTS                                                                #
%#                                                                       #
%#     reset: (1) if the user wants to reload the system                 #
%#            (0) if the user dont want.                                 #
%#                                                                       #
%#            OBS: is necessary runs this script at once to initiate the #
%#            bytes generation.                                          #
%#                                                                       #
%#     Key: the 80 bits cipher key in hexadecimal format.                #
%#                                                                       #
%#     IV: the 80 bits iv in hexadecimal format.                         #
%#                                                                       #
%#     w, h, d: width, height and bit deepness of the processed image.   #
%#                                                                       #
%#     output: path for the file where will be write the bytes.          #
%#                                                                       #
%#     baud: baud rate used in serial communication.                     #
%#                                                                       #
%#     com: serial COM port where FPGA is connected.                     #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################

function triviumFPGA(reset, Key, IV, w, h, d, output, baud, com)

    % Set the UART buffer size, that is, the number of bytes readed for
    % requisition.
    bytesRECV = 76800;
    
    % Based on the image dimensions, calculates the number of requisitions
    % necessary to FPGA.
    bytesRequired = (w * h * d * 2)/ bytesRECV;
    subITER = ceil(bytesRequired);
    
    % The requisition to FPGA will be make in 8 in 8 times with a two-second
    % between each one. So, "ITER" calculates the number of 8 requisitions
    % will be necessary.
    ITER =  ceil(subITER / 8);
    
    % The remaining ( < 8) iterations. 
    remainingITER = (subITER / 8) - floor(subITER / 8);

   
    
    % Open the serial port with.
    ROSETA = serial(com, 'BaudRate', baud, 'DataBits', 8, 'InputBufferSize', bytesRECV, 'Timeout', 20);
    fopen(ROSETA);

    
    % If the user want to make a circuit reset and load new key/iv.
    if reset == 1
        
        % Select the Trivium generator.
        fwrite(ROSETA, 'T');
        
        % Operator to start the key transmission.
        fwrite(ROSETA, 'K');

        % Send each byte of the key over UART.
        fwrite(ROSETA, Key(1));
        fwrite(ROSETA, Key(2));
        fwrite(ROSETA, Key(3));
        fwrite(ROSETA, Key(4));
        fwrite(ROSETA, Key(5));
        fwrite(ROSETA, Key(6));
        fwrite(ROSETA, Key(7));
        fwrite(ROSETA, Key(8));
        fwrite(ROSETA, Key(9));
        fwrite(ROSETA, Key(10));


        % Operator to start the IV transmission.
        fwrite(ROSETA, 'I');

        % Send each byte of the IV over UART.
        fwrite(ROSETA, IV(1));
        fwrite(ROSETA, IV(2));
        fwrite(ROSETA, IV(3));
        fwrite(ROSETA, IV(4));
        fwrite(ROSETA, IV(5));
        fwrite(ROSETA, IV(6));
        fwrite(ROSETA, IV(7));
        fwrite(ROSETA, IV(8));
        fwrite(ROSETA, IV(9));
        fwrite(ROSETA, IV(10));
        
        % Send a reset requisition.
        fwrite(ROSETA, 'R');
        
    end

    % Open a text file to save the keystream generated.
    file = fopen(output,'w');

    
    % Run the requisition.
    for i = 1:ITER

        for j = 1:8
            
            % Send a get requisition.
            fwrite(ROSETA, 'N');

            % Read a "bytesRECV" bytes.
            keystream = fread(ROSETA, bytesRECV);
            
            % Save the readed bytes in the text file.
            fprintf(file, '%02X', keystream);

        end;
    
        % Pause between 8 requisitions.
        pause(2);
    
    end;
    
    % Run the remaining requisitions.
    for j = 1:remainingITER

        % Send a get requisition.
        fwrite(ROSETA, 2);

        % Read a "bytesRECV" bytes.
        keystream = fread(ROSETA, bytesRECV);

        % Save the readed bytes in the text file.
        fprintf(file, '%02X', keystream);

    end;

    % Close the text file.
    fclose(file);

    % Close the serial port.
    fclose(ROSETA);
    
end