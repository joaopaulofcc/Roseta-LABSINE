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
--# File: MICKEY_GEN_clockR.vhd                                             #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_clockR entity declaration.
ENTITY MICKEY_GEN_clockR IS
	
	PORT 
	(
		inputBit		: IN STD_LOGIC;
		controlBit 	: IN STD_LOGIC;
		R_in			: IN 	t_LFSR_MICKEY;
		R_out			: OUT t_LFSR_MICKEY
	);
	
END MICKEY_GEN_clockR;
-- Finish the MICKEY_GEN_clockR entity declaration.


-- Start the MICKEY_GEN_clockR entity declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_clockR IS
		
	SIGNAL SIG_feedback	: STD_LOGIC;
	SIGNAL SIG_R			: t_LFSR_MICKEY;	
	
	SIGNAL SIG_MICKEY_GEN_tapsR_R_out 		: t_LFSR_MICKEY;

BEGIN
	
	-- Calculates the feedback bit for R generator.
	SIG_R 			<= '0' & R_in(0 TO 98);
	
	-- Calculates the feedback bit for taps processing.
	SIG_feedback 	<= R_in(99) XOR inputBit;
	
	
	-- Import and map the MICKEY_GEN_tapsR component.
	mapTapsR: ENTITY WORK.MICKEY_GEN_tapsR 
		PORT MAP
		(
			FB 			=> SIG_feedback,
			R_in			=> SIG_R,
			R_out			=> SIG_MICKEY_GEN_tapsR_R_out
		);

	-- Import and map the MICKEY_GEN_finishR component.
	mapFinishR: ENTITY WORK.MICKEY_GEN_finishR 
		PORT MAP
		(
			controlBit 	=> controlBit,
			R_in			=> SIG_MICKEY_GEN_tapsR_R_out,
			R_orig		=> R_in,
			R_out			=> R_out
		);

END BEHAVIOR;
-- End of the MICKEY_GEN_clockR architecture declaration.