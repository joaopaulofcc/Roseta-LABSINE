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
--# File: MICKEY_GEN_inputBit.vhd                                           #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_inputBit entity declaration.
ENTITY MICKEY_GEN_inputBit IS
	
	PORT 
	(
		inputbit		: IN  STD_LOGIC;		
		mixing 		: IN  STD_LOGIC;
		S_50			: IN 	STD_LOGIC;
		outputBit_R	: OUT STD_LOGIC;
		outputBit_S	: OUT STD_LOGIC
	);
	
END MICKEY_GEN_inputBit;
-- Finish the MICKEY_GEN_inputBit entity declaration.


-- Beginning of the MICKEY_GEN_inputBit architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_inputBit IS
BEGIN

	-- Defines the values of INPUT_BIT_R and INPUT_BIT_S.
	outputBit_R <= inputBit WHEN mixing = '0' ELSE inputBit XOR S_50;
	outputBit_S <= inputBit;

END BEHAVIOR;
-- End of the MICKEY_GEN_inputBit architecture declaration.
