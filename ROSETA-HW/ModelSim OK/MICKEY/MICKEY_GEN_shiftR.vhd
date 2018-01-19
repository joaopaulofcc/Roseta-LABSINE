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
--# File: MICKEY_GEN_shiftR.vhd                                           #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User library.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_shiftR entity declaration.
ENTITY MICKEY_GEN_shiftR IS
	
	PORT 
	(	
		inputBit		: IN  STD_LOGIC;
		feedback		: OUT STD_LOGIC;
		R_in			: IN 	t_LFSR_MICKEY;
		R_out			: OUT t_LFSR_MICKEY
	);
	
END MICKEY_GEN_shiftR;
-- Finish the MICKEY_GEN_shiftR entity declaration.


-- Start the MICKEY_GEN_shiftR architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_shiftR IS
BEGIN
	
	R_out 	<= '0' & R_in(0 TO 98);
	feedback <= R_in(99) XOR inputBit;

END BEHAVIOR;
