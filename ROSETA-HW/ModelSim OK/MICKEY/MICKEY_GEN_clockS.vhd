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
--# File: MICKEY_GEN_clockS.vhd                                           #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User libraSIG_Res.
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


-- Start the MICKEY_GEN_fbS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_clockS IS

	SIGNAL SIG_FB_S : STD_LOGIC;
	SIGNAL SIG_MICKEY_GEN_compS_S_out : t_NFSR_MICKEY;

BEGIN

	
	SIG_FB_S <= S_in(99) XOR inputbit;


	mapCompS: ENTITY WORK.MICKEY_GEN_compS
		PORT MAP
		(
			S_in		=> S_in,
			S_out		=> SIG_MICKEY_GEN_compS_S_out
		);	
		
		
	mapFBS: ENTITY WORK.MICKEY_GEN_fbS
		PORT MAP
		(
			controlBit 	=> controlBit,
			feedback		=> SIG_FB_S,
			S_in			=> SIG_MICKEY_GEN_compS_S_out,
			S_out			=> S_out
		);	

END BEHAVIOR;
