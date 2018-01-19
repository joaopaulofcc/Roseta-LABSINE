--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      		   File for trivium generator descripton. 					  #
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
--# File: TRIVIUM_Generator.vhd                                           #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Imports user libraries.
USE WORK.TRIVIUM_Functions.ALL;


-- Start the TRIVIUM_Generator entity declaration.
ENTITY TRIVIUM_Generator IS
	
	PORT 
	(
		clock		: IN 	STD_LOGIC;		-- Clock signal.
		reset		: IN 	STD_LOGIC;		-- Circuit reset signal.
		key		: IN 	t_KEY_TRIVIUM;	-- Cipher key.
		iv			: IN 	t_IV_TRIVIUM;	-- Cipher IV.
		enable 	: IN  STD_LOGIC;		-- (1) enable bit generation (0) disable.
		bitOut	: OUT STD_LOGIC		-- Pseudorandom bit generated.
	);
	
END TRIVIUM_Generator;
-- Finish the TRIVIUM_Generator entity declaration.




-- Beginning of the TRIVIUM_Generator architecture declaration.
ARCHITECTURE BEHAVIOR OF TRIVIUM_Generator IS

	-- The generator itself (a set of FFs).
	SIGNAL SIG_circLFSR 				: t_TRIVIUM;
	
	-- Auxiliar signals for intermediate calculations. 
	SIGNAL SIG_t1, SIG_t2, SIG_t3 : STD_LOGIC;
	SIGNAL SIG_s1, SIG_s2, SIG_s3 : STD_LOGIC;
	
	-- Intermediare clock signal, used for enable control.
	SIGNAL SIG_clock : STD_LOGIC;
	
BEGIN

	-- Enable clock process, when "enable" = '1' the circuit work normally,
	-- otherwise, the circuit will not generate a new pseudorandom bit, because
	-- your clock signal will be drive to low level.
	SIG_clock <= enable AND clock;

	
	-- Main process.
	PROCESS(SIG_clock)
	BEGIN
	
		IF RISING_EDGE(SIG_clock) THEN
		
			-- Reset the circuit, only reset the FFs values, the full reset is performed in
			-- the TRIVIUM_TopLevel entity.
			IF (reset = '1') THEN
			
				SIG_circLFSR(1   TO 93) 	<= key & "0000000000000";
				SIG_circLFSR(94  TO 177) 	<= iv  & "0000";		
				SIG_circLFSR(178 TO 288) 	<= x"000000000000000000000000000" & "111";
				
			-- Do the feedback process.
			ELSE
		
				SIG_circLFSR(1   TO 93) 	<= SIG_t3 & SIG_circLFSR(1   TO 92);
				SIG_circLFSR(94  TO 177) 	<= SIG_t1 & SIG_circLFSR(94  TO 176);
				SIG_circLFSR(178 TO 288) 	<= SIG_t2 & SIG_circLFSR(178 TO 287);
						
			END IF;
			
		END IF;
		
	END PROCESS;
	
	-- Do the remaining process in parallel.
	SIG_s1 <= SIG_circLFSR(66)  XOR SIG_circLFSR(93) ;
	SIG_s2 <= SIG_circLFSR(162) XOR SIG_circLFSR(177);
	SIG_s3 <= SIG_circLFSR(243) XOR SIG_circLFSR(288);
	
	-- Calculates the pseudorandom bit.
	bitOut <= SIG_s1 XOR SIG_s2 XOR SIG_s3;
	
	SIG_t1 <= SIG_s1 XOR ( SIG_circLFSR(91)  AND SIG_circLFSR(92)  ) XOR SIG_circLFSR(171);
	SIG_t2 <= SIG_s2 XOR ( SIG_circLFSR(175) AND SIG_circLFSR(176) ) XOR SIG_circLFSR(264);
	SIG_t3 <= SIG_s3 XOR ( SIG_circLFSR(286) AND SIG_circLFSR(287) ) XOR SIG_circLFSR(69);
        
END BEHAVIOR;
-- End of the TRIVIUM_Generator architecture declaration.