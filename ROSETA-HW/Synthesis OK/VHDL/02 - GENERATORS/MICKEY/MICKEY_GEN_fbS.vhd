--###########################################################################
--#	 		  Masters Program in Computer Science - UFLA - 2016/1           #
--#                                                                         #
--# 			 		        Hardware Implementations                          #
--#                                                                         #
--#      	       File for mickey generator description. 		   	       #
--#                                                                         #
--#                                                                         #
--# STUDENT                                                                 #
--#                                                                         #
--#     João Paulo Fernanades de Cerqueira César                            #
--#                                                                         #
--# ADVISOR                                                                 #
--#                                                                         #
--#     Wilian Soares Lacerda                                               #
--#                                                                         #
--#-------------------------------------------------------------------------#
--#                                                                         #
--# Adapted from: 																			 #
--#																							    #
--# NYDIA, Pérez Camacho Blanca. Comparación de la Eficiencia en Hardware   #
--# de los Cifradores de Flujo GRAIN, MICKEY-128 y TRIVIUM de ECRYPT. 2008. #
--# 152 f. Dissertação (Mestrado) - Curso de Ciencias Computacionales, 		 #
--# Departamento de Ciencias Computacionales, Instituto Nacional de Astro-  #
--# física, Óptica y Electrónica, Tonantzintla, Puebla. México, 2008. 		 #
--# Available in: <https://goo.gl/ocvm3o>. Acess date: 09 dez. 2017.        #
--#                                                                         #
--#-------------------------------------------------------------------------#
--#                                                                         #
--# File: MICKEY_GEN_fbS.vhd    	 	                                        #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_fbS entity declaration.
ENTITY MICKEY_GEN_fbS IS
	
	PORT 
	(
		controlBit 	: IN STD_LOGIC;
		feedback		: IN 	STD_LOGIC;
		S_in			: IN 	t_NFSR_MICKEY;
		S_out			: OUT t_NFSR_MICKEY
	);
	
END MICKEY_GEN_fbS;
-- Finish the MICKEY_GEN_fbS entity declaration.


-- Beginning of the MICKEY_GEN_fbS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_fbS IS

	SIGNAL FB0    : t_NFSR_MICKEY;
	SIGNAL FB1    : t_NFSR_MICKEY;
	
	SIGNAL FB_VECTOR : t_NFSR_MICKEY;
	
BEGIN

	-- Defines the value of FB0 and FB1.
	FB0    <= "1111010111111110010111111111100110000001110010010101001011110101010000000001101000110111001110011000";
	FB1    <= "1110111000011101001100010011001011000110000011011000100010010010110101001010001111011111000000100001";

	FB_VECTOR 	<= (OTHERS => feedback);
	
	-- Defines the ~S_i value.
	S_out <= (S_in XOR (FB0 AND FB_VECTOR)) WHEN controlBit = '0' ELSE (S_in XOR (FB1 AND FB_VECTOR));
		
END BEHAVIOR;
-- End of the MICKEY_GEN_fbS architecture declaration.
