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
--# File: MICKEY_GEN_sr.vhd                                               #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User libraSIG_Res.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_sr entity declaration.
ENTITY MICKEY_GEN_sr IS
	
	PORT 
	(
		clock			: IN 	STD_LOGIC;							-- Clock signal.
		reset			: IN 	STD_LOGIC;							-- Circuit reset signal.
		S_in			: IN 	t_LFSR_MICKEY;
		R_in			: IN 	t_NFSR_MICKEY;
		S_out			: OUT	t_LFSR_MICKEY;
		R_out			: OUT	t_NFSR_MICKEY
	);
	
END MICKEY_GEN_sr;
-- Finish the MICKEY_GEN_sr entity declaration.



-- Start the MICKEY_GEN_sr architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_sr IS

	-- The LFSR part.
	SIGNAL SIG_R	 		: t_LFSR_MICKEY;
	
	-- The NFSR part.
	SIGNAL SIG_S 			: t_NFSR_MICKEY;
	
BEGIN

	-- Main process.
	PROCESS(clock, reset)
	BEGIN
	
		IF (reset = '1') THEN
	
			SIG_R 	<= (OTHERS => '0');
			SIG_S 	<= (OTHERS => '0');
			
		ELSIF RISING_EDGE(clock) THEN
			
			SIG_R <= R_in;
			SIG_S <= S_in;
						
		END IF;
		
	END PROCESS;
	
	
	R_out <= SIG_R;
	S_out <= SIG_S;
	
	
END BEHAVIOR;
-- Finish the MICKEY_GEN_sr architecture declaration.