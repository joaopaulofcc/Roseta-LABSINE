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
--# File: MICKEY_GEN_clockS.vhd                                             #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_clockS entity declaration.
ENTITY MICKEY_GEN_clockS IS
	
	PORT 
	(
		inputbit		: IN  STD_LOGIC;
		controlBit 	: IN  STD_LOGIC;
		S_in			: IN 	t_NFSR_MICKEY;
		S_out			: OUT t_NFSR_MICKEY
	);
	
END MICKEY_GEN_clockS;
-- Finish the MICKEY_GEN_clockS entity declaration.


-- Start the MICKEY_GEN_clockS entity declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_clockS IS

	SIGNAL SIG_FB_S : STD_LOGIC;
	SIGNAL SIG_MICKEY_GEN_compS_S_out : t_NFSR_MICKEY;

BEGIN

	
	-- Calculates the feedback bit for S generator.
	SIG_FB_S <= S_in(99) XOR inputbit;

	
	-- Import and map the MICKEY_GEN_compS component.
	mapCompS: ENTITY WORK.MICKEY_GEN_compS
		PORT MAP
		(
			S_in		=> S_in,
			S_out		=> SIG_MICKEY_GEN_compS_S_out
		);	
		
		
	-- Import and map the MICKEY_GEN_fbS component.
	mapFBS: ENTITY WORK.MICKEY_GEN_fbS
		PORT MAP
		(
			controlBit 	=> controlBit,
			feedback		=> SIG_FB_S,
			S_in			=> SIG_MICKEY_GEN_compS_S_out,
			S_out			=> S_out
		);	

END BEHAVIOR;
-- End of the MICKEY_GEN_clockS architecture declaration.