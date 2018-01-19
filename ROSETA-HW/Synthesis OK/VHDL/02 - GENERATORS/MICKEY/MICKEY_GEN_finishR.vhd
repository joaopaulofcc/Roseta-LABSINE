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
--# File: MICKEY_GEN_finishR.vhd                                            #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_finishR entity declaration.
ENTITY MICKEY_GEN_finishR IS
	
	PORT 
	(	
		controlBit	: IN  STD_LOGIC;
		R_in			: IN 	t_LFSR_MICKEY;
		R_orig		: IN 	t_LFSR_MICKEY;
		R_out			: OUT t_LFSR_MICKEY
	);
	
END MICKEY_GEN_finishR;
-- Finish the MICKEY_GEN_finishR entity declaration.


-- Beginning of the MICKEY_GEN_finishR architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_finishR IS
BEGIN
	
	R_out <= R_in WHEN controlBit = '0' ELSE R_in XOR R_orig;

END BEHAVIOR;
-- End of the MICKEY_GEN_finishR architecture declaration.
