--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					      Hardware Implementations                          #
--#                                                                       #
--#    Top Level component responsible to control the MICKEY functions.   #
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
--# File: MICKEY_Toplevel.vhd                                             #
--#                                                                       #
--# About: This file describe a top level architecture of the MICKEY gen  #
--#        erator. Is responsible to control the reset process and also   #
--#        the byte generation by means of call the "MICKEY_Generator"    #
--#        10 times. 																	  #
--#                                                                       #
--# 13/07/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- User libraries.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_Toplevel entity declaration.
ENTITY MICKEY_Toplevel IS
	
	PORT 
	(
		clockIN		: IN 	STD_LOGIC;							-- Clock signal.
		reset			: IN 	STD_LOGIC;							-- Circuit reset signal.
		key			: IN  t_KEY_MICKEY;						-- Cipher key.
		iv				: IN  t_IV_MICKEY;						-- Cipher iv.
		get			: IN  STD_LOGIC;							-- (1) get a new byte  (0) normal FSM operation.
		busy			: OUT STD_LOGIC;  						-- (1) circuit is busy (0) circuit in IDLE.
		readyReset	: OUT STD_LOGIC;							-- (1) the reset process is ready (0) otherwise.
		readyByte	: OUT STD_LOGIC; 							-- (1) the byte required is ready (0) otherwise.
		keystream	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- the pseudorandom byte generated.
		state_Top	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
	
END MICKEY_Toplevel;
-- Finish the MICKEY_Toplevel entity declaration.




-- Start the MICKEY_Toplevel architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_Toplevel IS
	
	
	-- Counter to byte generation process.
	SIGNAL RUN_COUNTER 			: INTEGER RANGE 0 TO 8 := 0;
	
	-- Auxiliar signal used to store the 8 bits generated.
	SIGNAL SIG_keystream			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	

	-- Signals to inport the MICKEY_Generator.
	SIGNAL SIG_GEN_clock			: STD_LOGIC;
	SIGNAL SIG_GEN_reset			: STD_LOGIC;
	SIGNAL SIG_GEN_readyReset	: STD_LOGIC;
	SIGNAL SIG_GEN_key			: t_KEY_MICKEY;
	SIGNAL SIG_GEN_iv				: t_IV_MICKEY;
	SIGNAL SIG_GEN_enable		: STD_LOGIC;
	SIGNAL SIG_GEN_outputBit	: STD_LOGIC;
	SIGNAL SIG_GEN_bitOut		: STD_LOGIC;
	
	
	-- FSM
	TYPE controlFSM IS (state_IDLE, state_RESET, state_RUN);
	
	-- Control the next state of the FSM.
	SIGNAL nextState : controlFSM := state_IDLE;
	
	
BEGIN

	-- Import and map the MICKEY generator.
	mapGENERATOR: ENTITY WORK.MICKEY_Generator 
		PORT MAP
		(
			clock			=> SIG_GEN_clock,
			reset			=> SIG_GEN_reset,
			readyReset  => SIG_GEN_readyReset,
			key 			=> SIG_GEN_key,
			iv				=> SIG_GEN_iv,
			enable		=> SIG_GEN_enable,
			outputBit	=> SIG_GEN_outputBit,
			bitOut		=> SIG_GEN_bitOut
		);

		
	-- Carries the external clock to the generator.
	SIG_GEN_clock 		<= clockIN;

	
	
	-- Start the main process, triggered by changes in the clock,
	-- reset and get signals.
	PROCESS(clockIN, reset, get) 
	BEGIN
	
		IF (get = '1') THEN
					
			nextState <= state_RUN;
					

		-- Asynchronous verifies if the "reset" signal is in high level,
		-- in this case, the reset process start.
 		ELSIF (reset = '1') THEN
		
			
			SIG_GEN_reset 		<= '1';
			
			
			SIG_GEN_key <= key;
			SIG_GEN_iv <= iv;
			
			keystream 		<= (OTHERS => 'Z');
		
			nextState 		<= state_RESET;
	
			
			
		-- Otherwise, if there are none asynchronous interruptions, go on to the
		-- normal FSM normal operation.
		ELSIF (RISING_EDGE(clockIN)) THEN
			
		
			-- Verify the next state.
			CASE nextState is
		
		
				WHEN state_IDLE =>
				
					state_Top 			<= "000";
					
					busy 					<= '0';
					
					readyByte 			<= '0';
					readyReset			<= '1';
					
					SIG_GEN_enable 	<= '0';
					SIG_GEN_reset 		<= '0';
					
					nextState <= state_IDLE;
						
					
				WHEN state_RESET =>
				
					state_Top 			<= "010";
					
					busy 					<= '1';
					
					SIG_GEN_enable 	<= '1';
					SIG_GEN_reset 		<= '0';
					
					readyByte 			<= '0';
										
					
					IF SIG_GEN_readyReset = '1' THEN
						
						readyReset <= '1';
					
						nextState <= state_IDLE;
						
					ELSE
					
						readyReset <= '0';
						
						nextState <= state_RESET;
						
					END IF;
										
							
								
				
				WHEN state_RUN =>	
				
					busy 					<= '1';
						
					readyByte 			<= '0';
					
					SIG_GEN_enable 	<= '1';
					
					SIG_GEN_reset 		<= '0';
					
					readyReset			<= '0';
					
					
					-- If the counter is equal to 8, drive the auxilar keystream to the output signal,
					-- reset the counter and turn on the signal "readyByte".
					IF (RUN_COUNTER = 8) THEN
					
						keystream 		<= SIG_Keystream;
						
						RUN_COUNTER 	<= 0;
						
						SIG_GEN_enable <= '0';
						
						readyByte 		<= '1';
						
						-- Go to the "state_IDLE" state.
						nextState		<=  state_IDLE;
						
						
					-- Otherwise, if the counter is less then 8, drive the output bit from generator to
					-- the correct byte position and increment the counter.
					ELSE
					
						SIG_Keystream(7 - RUN_COUNTER) <= SIG_GEN_bitOut;
					
						RUN_COUNTER <= RUN_COUNTER + 1;
						
						
						-- Keep on the "state_RUN" state in the next cicle.
						nextState <= state_RUN;
						
					END IF;
					
					
				-- Invalid states - do nothing.		
				WHEN OTHERS =>
					
					
			END CASE;
	
	
		END IF;
	
	
	END PROCESS;
	
	
END BEHAVIOR;
-- Finish the MICKEY_Toplevel architecture declaration.