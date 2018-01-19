--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      	      File for mickey generator description.    		  	     #
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
--# File: MICKEY_Generator.vhd                                            #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User library.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_Generator entity declaration.
ENTITY MICKEY_Generator IS
	
	PORT 
	(
		clock			: IN 	STD_LOGIC;							-- Clock signal.
		reset			: IN 	STD_LOGIC;							-- Circuit reset signal.
		readyReset	: OUT STD_LOGIC;
		key			: IN 	t_KEY_MICKEY;							-- Cipher IV.
		iv				: IN 	t_IV_MICKEY;							-- Cipher IV.
		enable 		: IN  STD_LOGIC;							-- (1) enable bit generation (0) disable.
		
		outputBit 	: OUT STD_LOGIC;
		
		bitOut		: OUT STD_LOGIC							-- Pseudorandom bit generated.
	);
	
END MICKEY_Generator;
-- Finish the MICKEY_Generator entity declaration.



-- Start the MICKEY_Generator architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_Generator IS

	SIGNAL SIG_key	: t_KEY_MICKEY;
	SIGNAL SIG_iv	: t_IV_MICKEY;


	-- The LFSR part.
	SIGNAL SIG_R	 		: t_LFSR_MICKEY := (OTHERS => '0');
	
	-- The NFSR part.
	SIGNAL SIG_S 			: t_NFSR_MICKEY := (OTHERS => '0');
	
	
	SIGNAL SIG_MICKEY_GEN_clockKG_S_out	: t_NFSR_MICKEY;
	SIGNAL SIG_MICKEY_GEN_clockKG_R_out	: t_LFSR_MICKEY;
	
	
	-- Intermediare clock signal used for enable control.
	SIGNAL SIG_clock : STD_LOGIC;
	
	
	SIGNAL SIG_mixing 	: STD_LOGIC;
	SIGNAL SIG_inputBit 	: STD_LOGIC;
	
	
	TYPE controlFSM IS (state_IDLE, state_RESET);
	SIGNAL nextState : controlFSM := state_IDLE;
	
	
	SIGNAL COUNTER 			: INTEGER RANGE 0 TO 260 := 0;
	
BEGIN

	SIG_clock <= enable AND clock;
	
	bitOut <= SIG_R(0) XOR SIG_S(0);
	
	
	
	mapClockKG: ENTITY WORK.MICKEY_GEN_clockKG 
		PORT MAP
		(
			S_in 			=> SIG_S,
			R_in			=> SIG_R,
			S_out			=> SIG_MICKEY_GEN_clockKG_S_out,
			R_out			=> SIG_MICKEY_GEN_clockKG_R_out,
			inputBit		=> SIG_inputBit,
			outputBit	=> outputBit,
			mixing		=> SIG_mixing			
		);

		
	mapSR: ENTITY WORK.MICKEY_GEN_sr
		PORT MAP
		(
			clock			=> SIG_clock,
			reset			=> reset,
			S_in 			=> SIG_MICKEY_GEN_clockKG_S_out,
			R_in			=> SIG_MICKEY_GEN_clockKG_R_out,
			S_out			=> SIG_S,
			R_out			=> SIG_R	
		);
				

				
				
	
	
	
	
	PROCESS(SIG_clock, reset)
	BEGIN
	
		IF (reset = '1') THEN
		
			SIG_key 	<= key;
			SIG_iv 	<= iv;
		
			SIG_mixing 		<= '1';
			SIG_inputBit 	<= SIG_iv(0);
				
			COUNTER 			<= 1;
			
			nextState <= state_RESET;
	
		ELSIF (RISING_EDGE(SIG_clock)) THEN
			
			-- Verify the next state.
			CASE nextState is
			
			
				WHEN state_IDLE =>
				
					SIG_mixing 		<= '0';
					SIG_inputBit 	<= '0';
					readyReset  	<= '0';
				
					nextState 		<= state_IDLE;
				
				
				WHEN state_RESET =>
										
					IF COUNTER < 80 THEN
					
						SIG_mixing 		<= '1';
						SIG_inputBit 	<= SIG_iv(COUNTER);
						
						readyReset  	<= '0';
						
						COUNTER 			<= COUNTER + 1;
						
						nextState 		<= state_RESET;
					
					ELSIF COUNTER < 160 THEN
					
						SIG_mixing 		<= '1';
						SIG_inputBit 	<= SIG_key(COUNTER - 80);
						
						readyReset  	<= '0';
					
						COUNTER 			<= COUNTER + 1;
						
						nextState 		<= state_RESET;
					
					ELSIF COUNTER < 260 THEN
					
						IF COUNTER = 259 THEN
						
							readyReset <= '1';
							
						ELSE
						
							readyReset <= '0';
							
						END IF;
					
						SIG_mixing 		<= '1';
						SIG_inputBit 	<= '0';
						
						COUNTER 			<= COUNTER + 1;
						
						nextState 		<= state_RESET;
						
					ELSE 
						
						SIG_mixing 		<= '0';
						SIG_inputBit 	<= '0';
						
						COUNTER 			<= 0;
						
						nextState 		<= state_IDLE;
						
					END IF;
					
					
				WHEN OTHERS =>
				
					SIG_mixing 		<= '0';
					SIG_inputBit 	<= '0';
				
			END CASE;
			
		END IF;
		
	END PROCESS;
	
END BEHAVIOR;
-- Finish the MICKEY_Generator architecture declaration.