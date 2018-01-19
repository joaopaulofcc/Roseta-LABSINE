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
--# File: MICKEY_GEN_fbS.vhd                                              #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User libraSIG_Res.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_fbS entity declaration.
ENTITY MICKEY_GEN_fbS IS
	
	PORT 
	(
		controlBit 	: IN STD_LOGIC;
		feedback		: IN 	STD_LOGIC;
		S_in			: IN 	t_NFSR_MICKEY;
		S_out			: OUT t_NFSR_MICKEY
	);
	
END MICKEY_GEN_fbS;
-- Finish the MICKEY_GEN_fbS entity declaration.


-- Start the MICKEY_GEN_fbS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_fbS IS

	SIGNAL FB0    : t_NFSR_MICKEY;
	SIGNAL FB1    : t_NFSR_MICKEY;
	
	SIGNAL FB_VECTOR : t_NFSR_MICKEY;
	
BEGIN

	FB0    <= "1111010111111110010111111111100110000001110010010101001011110101010000000001101000110111001110011000";
	FB1    <= "1110111000011101001100010011001011000110000011011000100010010010110101001010001111011111000000100001";

	FB_VECTOR 	<= (OTHERS => feedback);
	
	S_out <= (S_in XOR (FB0 AND FB_VECTOR)) WHEN controlBit = '0' ELSE (S_in XOR (FB1 AND FB_VECTOR));
		
END BEHAVIOR;
