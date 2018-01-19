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
--# File: MICKEY_GEN_sr.vhd	                                              #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_sr entity declaration.
ENTITY MICKEY_GEN_sr IS
	
	PORT 
	(
		clock			: IN 	STD_LOGIC;			-- Clock signal.
		reset			: IN 	STD_LOGIC;			-- Circuit reset signal.
		S_in			: IN 	t_LFSR_MICKEY;
		R_in			: IN 	t_NFSR_MICKEY;
		S_out			: OUT	t_LFSR_MICKEY;
		R_out			: OUT	t_NFSR_MICKEY
	);
	
END MICKEY_GEN_sr;
-- Finish the MICKEY_GEN_sr entity declaration.


-- Beginning of the MICKEY_GEN_tapsR architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_sr IS

	-- The LFSR part.
	SIGNAL SIG_R	 		: t_LFSR_MICKEY;
	
	-- The NFSR part.
	SIGNAL SIG_S 			: t_NFSR_MICKEY;
	
BEGIN

	-- Main process.
	PROCESS(clock)
	BEGIN
	
		-- If the clock signal is in rising edge.
		IF RISING_EDGE(clock) THEN
	
			-- Resets the R and S values.
			IF (reset = '1') THEN
		
				SIG_R 	<= (OTHERS => '0');
				SIG_S 	<= (OTHERS => '0');
				
			-- Directs the input vectors to their respective outputs.
			ELSE
				
				SIG_R <= R_in;
				SIG_S <= S_in;
							
			END IF;
			
		END IF;
		
	END PROCESS;
	
	
	R_out <= SIG_R;
	S_out <= SIG_S;
	
END BEHAVIOR;
-- End of the MICKEY_GEN_sr architecture declaration.