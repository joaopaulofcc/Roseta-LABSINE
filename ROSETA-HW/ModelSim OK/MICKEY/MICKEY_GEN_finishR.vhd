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
--# File: MICKEY_GEN_finishR.vhd                                          #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User library.
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


-- Start the MICKEY_GEN_finishR architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_finishR IS
BEGIN
	
	
	R_out <= R_in WHEN controlBit = '0' ELSE R_in XOR R_orig;
	

END BEHAVIOR;
