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
--# File: MICKEY_GEN_clockR.vhd                                           #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User libraSIG_Res.
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


-- Start the MICKEY_GEN_fbS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_clockR IS
		
	SIGNAL SIG_feedback	: STD_LOGIC;
	SIGNAL SIG_R			: t_LFSR_MICKEY;	
	
	SIGNAL SIG_MICKEY_GEN_tapsR_R_out 		: t_LFSR_MICKEY;

BEGIN
	
	SIG_R 		<= '0' & R_in(0 TO 98);
	SIG_feedback <= R_in(99) XOR inputBit;
		
	

	mapTapsR: ENTITY WORK.MICKEY_GEN_tapsR 
		PORT MAP
		(
			FB 			=> SIG_feedback,
			R_in			=> SIG_R,
			R_out			=> SIG_MICKEY_GEN_tapsR_R_out
		);

	mapFinishR: ENTITY WORK.MICKEY_GEN_finishR 
		PORT MAP
		(
			controlBit 	=> controlBit,
			R_in			=> SIG_MICKEY_GEN_tapsR_R_out,
			R_orig		=> R_in,
			R_out			=> R_out
		);

END BEHAVIOR;
