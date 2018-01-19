 %#########################################################################
 %#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
 %#                                                                       #
 %# 					Analysis Implementations                          #
 %#                                                                       #
 %#   Script responsible for converting each byte of the bit string into  # 
 %#            its corresponding little endian representation.            #
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
 %# File: littleEndian.m                                                  #
 %#                                                                       #
 %# About: This file describe a script which realize a little endian byte #
 %#		   conversion to adequate some values, as the keystream and Key/  #
 %#        IV to the test vectors formats, like <https://goo.gl/QNjreG>   #
 %#                                                                       #
 %# INPUTS                                                                #
 %#                                                                       #
 %#     k: an string of bits ('0' or '1' characters).                     #
 %#                                                                       #
 %# RETURN                                                                #
 %#                                                                       #
 %#     out: a string representing the input "k" converted in little      #
 %#          endian. Example:                                             #
 %#                                                                       #
 %#         k   = '1101011010100011', that is, 'D6A3' - results in        #
 %#         out = '0110101111000101', that is, '6BC5'                     #
 %#                                                                       #
 %#                                                                       #
 %# 21/12/17 - Lavras - MG                                                #
 %#########################################################################
 

function out = littleEndian(k)

    % Get the number of bytes in the string.
    n = (length(k)/8) - 1;
    
    % For each byte do a horizontal flip in your values.
    for i = 0:n
       
       k( (i*8+1):(i*8+8) ) = fliplr(k( (i*8+1):(i*8+8) ));
       
    end
    
    % Update the retunt value.
    out = k;
    
    % Old version -a lternative without "filplr" command.
    % out((((i*8) + 8) : -1 : (i*8) + 1)) = horzcat( k((i*8) + 1), k((i*8) + 2), k((i*8) + 3), k((i*8) + 4), k((i*8) + 5), k((i*8) + 6), k((i*8) + 7), k((i*8) + 8));

end


