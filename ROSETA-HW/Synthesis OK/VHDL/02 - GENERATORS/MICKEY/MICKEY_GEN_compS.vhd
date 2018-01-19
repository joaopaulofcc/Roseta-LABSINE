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
--# File: MICKEY_GEN_compS.vhd                                              #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
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


-- Beginning of the MICKEY_GEN_compS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_compS IS

	SIGNAL COMP0  : STD_LOGIC_VECTOR(1 TO 98);
	SIGNAL COMP1  : STD_LOGIC_VECTOR(1 TO 98);
	
BEGIN

	-- Define four sequences COMP0 and COMP1.
	COMP0  <= "00011000101111010010101010101101001000000010101010000101001111001010111111111010111111010100000011";
	COMP1  <= "10110010111100101000110101110111100011010111000010001011100011111101011101111000100001110001001100";

	
	-- For 1 ≤ i ≤ 98, ~S_i = S_i-1 XOR ((S_i XOR COMP0) AND (S_i+1 XOR COMP1));
	-- ~S_0 = 0; ~S_99 = S_98
	
	S_out (1 TO 98) <= S_in(0 TO 97) XOR ((S_in(1 TO 98) XOR COMP0) AND (S_in(2 TO 99) XOR COMP1));
	S_out(0)			<= '0'; 
	S_out(99) 		<= S_in(98);
		
END BEHAVIOR;
-- End of the MICKEY_GEN_compS architecture declaration.