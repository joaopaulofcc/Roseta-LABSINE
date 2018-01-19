--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      	       File for mickey generator descSIG_Rpton. 		  	     #
--#                                                                       #
--#                                                                       #
--# STUDENT                                                               #
--#                                                                       #
--#     João Paulo Fernanades de Cerqueira César                          #
--#                                                                       #
--# ADVISOR                                                               #
--#                                                                       #
--#     Wilian Soares Lacerda                                             #
--#                                                                       #
--#-----------------------------------------------------------------------#
--#                                                                       #
--# File: MICKEY_Generator.vhd                                            #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_clockKG entity declaration.
ENTITY MICKEY_GEN_clockKG IS
	
	PORT 
	(
		S_in			: IN 	t_NFSR_MICKEY;
		R_in			: IN 	t_LFSR_MICKEY;
		S_out			: OUT	t_NFSR_MICKEY;
		R_out			: OUT	t_LFSR_MICKEY;
		inputBit		: IN STD_LOGIC;
		
		outputBit 	: OUT STD_LOGIC;
		
		mixing		: IN STD_LOGIC
	);
	
END MICKEY_GEN_clockKG;
-- Finish the MICKEY_GEN_clockKG entity declaration.



-- Start the MICKEY_GEN_clockKG architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_clockKG IS
	
	SIGNAL SIG_CONTROL_R : STD_LOGIC;
	SIGNAL SIG_CONTROL_S : STD_LOGIC;
	
	SIGNAL SIG_outputBit_R	: STD_LOGIC;
	SIGNAL SIG_outputBit_S	: STD_LOGIC;

BEGIN
	
	SIG_CONTROL_R <= S_in(34) XOR R_in(67);
	SIG_CONTROL_S <= S_in(67) XOR R_in(33);
	
	
	mapInputBit: ENTITY WORK.MICKEY_GEN_inputBit
		PORT MAP
		(
			inputBit		=> inputBit,
			
			outputBit	=> outputBit,
			
			mixing 		=> mixing,
			S_50			=> S_in(50),
			outputBit_R	=> SIG_outputBit_R,
			outputBit_S	=> SIG_outputBit_S
		);	
		
	
	mapClockR: ENTITY WORK.MICKEY_GEN_clockR
		PORT MAP
		(
			inputBit		=> SIG_outputBit_R,
			controlBit 	=> SIG_CONTROL_R,
			R_in			=> R_in,
			R_out			=> R_out
		);		


	mapClockS: ENTITY WORK.MICKEY_GEN_clockS
		PORT MAP
		(
			inputBit		=> SIG_outputBit_S,
			controlBit 	=> SIG_CONTROL_S,
			S_in			=> S_in,
			S_out			=> S_out
		);	
							  
END BEHAVIOR;
-- Finish the MICKEY_GEN_clockKG architecture declaration.