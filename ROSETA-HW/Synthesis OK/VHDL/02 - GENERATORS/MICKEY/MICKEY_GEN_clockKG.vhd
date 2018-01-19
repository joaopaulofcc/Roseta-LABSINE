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
--# File: MICKEY_GEN_clockKG.vhd                                            #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_clockKG entity declaration.
ENTITY MICKEY_GEN_clockKG IS
	
	PORT 
	(
		S_in			: IN 	t_NFSR_MICKEY;
		R_in			: IN 	t_LFSR_MICKEY;
		S_out			: OUT	t_NFSR_MICKEY;
		R_out			: OUT	t_LFSR_MICKEY;
		inputBit		: IN  STD_LOGIC;
		outputBit 	: OUT STD_LOGIC;
		mixing		: IN  STD_LOGIC
	);
	
END MICKEY_GEN_clockKG;
-- Finish the MICKEY_GEN_clockKG entity declaration.



-- Start the MICKEY_GEN_clockKG entity declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_clockKG IS
	
	SIGNAL SIG_CONTROL_R : STD_LOGIC;
	SIGNAL SIG_CONTROL_S : STD_LOGIC;
	
	SIGNAL SIG_outputBit_R	: STD_LOGIC;
	SIGNAL SIG_outputBit_S	: STD_LOGIC;

BEGIN
	
	-- Defines the CONTROL_BIT_R and the CONTROL_BIT_S.
	SIG_CONTROL_R <= S_in(34) XOR R_in(67);
	SIG_CONTROL_S <= S_in(67) XOR R_in(33);
	
	
	-- Import and map the MICKEY_GEN_inputBit component.
	mapInputBit: ENTITY WORK.MICKEY_GEN_inputBit
		PORT MAP
		(
			inputBit		=> inputBit,			
			mixing 		=> mixing,
			S_50			=> S_in(50),
			outputBit_R	=> SIG_outputBit_R,
			outputBit_S	=> SIG_outputBit_S
		);	
		
	
	-- Import and map the MICKEY_GEN_clockR component.
	mapClockR: ENTITY WORK.MICKEY_GEN_clockR
		PORT MAP
		(
			inputBit		=> SIG_outputBit_R,
			controlBit 	=> SIG_CONTROL_R,
			R_in			=> R_in,
			R_out			=> R_out
		);		

		
	-- Import and map the MICKEY_GEN_clockS component.
	mapClockS: ENTITY WORK.MICKEY_GEN_clockS
		PORT MAP
		(
			inputBit		=> SIG_outputBit_S,
			controlBit 	=> SIG_CONTROL_S,
			S_in			=> S_in,
			S_out			=> S_out
		);	
							  
END BEHAVIOR;
-- End of the MICKEY_GEN_clockKG architecture declaration.