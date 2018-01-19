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



-- Start the MICKEY_GEN_compS entity declaration.
ENTITY MICKEY_GEN_compS IS
	
	PORT 
	(
		S_in			: IN 	t_NFSR_MICKEY;
		S_out			: OUT t_NFSR_MICKEY
	);
	
END MICKEY_GEN_compS;
-- Finish the MICKEY_GEN_compS entity declaration.


-- Start the MICKEY_GEN_compS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_compS IS

	SIGNAL COMP0  : STD_LOGIC_VECTOR(1 TO 98);
	SIGNAL COMP1  : STD_LOGIC_VECTOR(1 TO 98);
	
BEGIN

	COMP0  <= "00011000101111010010101010101101001000000010101010000101001111001010111111111010111111010100000011";
	COMP1  <= "10110010111100101000110101110111100011010111000010001011100011111101011101111000100001110001001100";

	
	S_out (1 TO 98) <= S_in(0 TO 97) XOR ((S_in(1 TO 98) XOR COMP0) AND (S_in(2 TO 99) XOR COMP1));

	S_out(0)		<= '0'; 
	S_out(99) 	<= S_in(98);
	
		
END BEHAVIOR;
