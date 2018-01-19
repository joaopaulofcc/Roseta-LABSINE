--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					      Hardware Implementations                          #
--#                                                                       #
--#    Top Level component responsible to control the GRAIN functions.    #
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
--# File: GRAIN_Toplevel.vhd                                              #
--#                                                                       #
--# About: This file describe a top level architecture of the GRAIN gen   #
--#        erator. Is responsible to control the reset process and also   #
--#        the byte generation by means of call the "GRAIN_Generator"     #
--#        10 times. 																	  #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Imports user libraries.
USE WORK.GRAIN_Functions.ALL;



-- Start the GRAIN_Toplevel entity declaration.
ENTITY GRAIN_Toplevel IS
	
	PORT 
	(
		clockIN		: IN 	STD_LOGIC;							-- Clock signal.
		reset			: IN 	STD_LOGIC;							-- Circuit reset signal.
		key			: IN  t_KEY_GRAIN;						-- Cipher key.
		iv				: IN  t_IV_GRAIN;							-- Cipher iv.
		get			: IN  STD_LOGIC;							-- (1) get a new byte  (0) normal FSM operation.
		busy			: OUT STD_LOGIC;  						-- (1) circuit is busy (0) circuit in IDLE.
		readyReset	: OUT STD_LOGIC;							-- (1) the reset process is ready (0) otherwise.
		readyByte	: OUT STD_LOGIC; 							-- (1) the byte required is ready (0) otherwise.
		keystream	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 	-- the pseudorandom byte generated.
	);
	
END GRAIN_Toplevel;
-- Finish the GRAIN_Toplevel entity declaration.




-- Beginning of the GRAIN_Toplevel architecture declaration.
ARCHITECTURE BEHAVIOR OF GRAIN_Toplevel IS


	-- Function responsible for change the endianess of the values of a STD_LOGIC_VECTOR.
	-- 	Available in: <https://goo.gl/RELXQz> e <https://goo.gl/rq7NYh>
	FUNCTION reverse (a: IN STD_LOGIC_VECTOR)
	RETURN STD_LOGIC_VECTOR IS
	  VARIABLE result: STD_LOGIC_VECTOR(a'RANGE);
	  CONSTANT numBytes : NATURAL := a'length / 8;
	BEGIN
	
		-- Change Endianess.
		FOR i IN 0 to numBytes-1 LOOP
	
			FOR j IN 7 DOWNTO 0 LOOP
			
				result(8*i + j) := a(8*i + (7 - j));
				
			END LOOP;
		
		END LOOP;
		
	  RETURN result;
	  
	END;


	-- Counter to reset process.
	SIGNAL INIT_COUNTER 			: INTEGER RANGE 0 TO INIT_CYCLES_GRAIN := 0;
	
	-- Counter to byte generation process.
	SIGNAL RUN_COUNTER 			: INTEGER RANGE 0 TO 8 := 0;
	
	-- Auxiliar signal used to store the 8 bits generated.
	SIGNAL SIG_keystream			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	

	-- Signals to inport the GRAIN_Generator.
	SIGNAL SIG_GEN_clock			: STD_LOGIC;
	SIGNAL SIG_GEN_reset			: STD_LOGIC;
	SIGNAL SIG_GEN_key			: t_KEY_GRAIN;
	SIGNAL SIG_GEN_iv				: t_IV_GRAIN;	
	SIGNAL SIG_GEN_enable		: STD_LOGIC;
	SIGNAL SIG_GEN_init			: STD_LOGIC;
	SIGNAL SIG_GEN_bitOut		: STD_LOGIC;
	
	
	
	-- Finite State Machine for operation control.
	
		--	state_IDLE: 
		-- 		In this state no operation is performed, the circuit 
		-- 		is waiting for idle mode operation.
		
		
		-- state_STARTRESET: 
		--			In this state the reset process is initiated, ie the 
		-- 		"GRAIN_Generator" circuit is enabled to activate the 
		-- 		reset process.
		
		
		-- state_DUMYRESET:
		--			State used only to keep the generator reset signal at
		-- 		a high level for a further clock cycle, because this 
		-- 		signal is synchronous.
		
		
		-- state_FINISHRESET: 
		-- 		State of completion of the generator reset process, in this state the 
		-- 		generator has already finished the reset process, so the circuit can 
		-- 		be disabled (interrupt clock) and the signal "SIG_GEN_reset" set to 
		-- 		logic level 0.		
		
		
		-- state_CICLE: 
		--			in this state the generator delivery 160 pseudorandom bits that are
		-- 		discarded due to Grain recommendations. After finishing this cycle 
		-- 		the next state of FSM s "state_IDLE".
		
		
		-- state_RUN: 
		--			in this state the generator is called 8 times so that the pseudorandom byte
		-- 		is ready. While the "RUN_COUNTER" is not equal to 8, the FSM stay in this 
		-- 		same state in the next clock cicle, otherwise the FSM go to the "state_IDLE".
	
	TYPE controlFSM IS (state_IDLE, state_STARTRESET, state_DUMYRESET, state_FINISHRESET, state_CICLE, state_RUN);
	
	-- Control the next state of the FSM.
	SIGNAL nextState : controlFSM := state_IDLE;
	
	
BEGIN

	-- Import and map the Grain generator.
	mapGENERATOR: ENTITY WORK.Grain_Generator 
		PORT MAP
		(
			clock		=> SIG_GEN_clock,
			reset		=> SIG_GEN_reset,
			key		=> SIG_GEN_key,
			iv			=> SIG_GEN_iv,
			enable	=> SIG_GEN_enable,
			init		=> SIG_GEN_init,
			bitOut	=> SIG_GEN_bitOut
		);

		
	-- Carries the external clock to the generator.
	SIG_GEN_clock 		<= clockIN;


	-- Start the main process, triggered by changes in the clock,
	-- reset and get signals.
	PROCESS(clockIN) 
	BEGIN
			
		-- If the clock signal is in rising edge.
		IF (RISING_EDGE(clockIN)) THEN

			
			-- Verifies if the "get" signal is in high level, in this case, 
			-- the FSM go to the "state_RUN" in the next cicle.
			IF (get = '1') THEN
			
				-- Disable the generator.
				SIG_GEN_enable <= '0';
			
				nextState 		<= state_RUN;
			
			
			-- Verifies if the "reset" signal is in high level, in this case,
			-- the reset process start and the FSM goes to the "state_STARTRESET" 
			-- in the next cicle.
			ELSIF (reset = '1') THEN
			
				-- The "reversed" key and iv values are drive to the generator.
				SIG_GEN_key 	<= reverse(key);
				SIG_GEN_iv  	<= reverse(iv);
			
				-- Reset the counters.
				INIT_COUNTER 	<= 0;
				RUN_COUNTER		<= 0;
				
				-- Reset the flag pins.
				readyReset		<= '0';
				readyByte 		<= '0';
				
				-- Enable the generator.
				SIG_GEN_enable <= '0';
				
				-- Initialize the keystream auxiliar signal.
				keystream 		<= (OTHERS => 'Z');
			
				-- Go to the "state_STARTRESET" stte in the next clock cicle.
				nextState 		<= state_STARTRESET;
	
			ELSE
	
				-- Verify the next state.
				CASE nextState is
			
			
					-- State called when the hardware don't need to operate. In this, turn off
					--	the "busy" signal, also the "readyByte" flag and disable the enable signal 
					-- of generator component. The next FSM state is "state_IDLE".	
					WHEN state_IDLE =>
						
						busy 					<= '0';
						
						readyByte 			<= '0';
						readyReset			<= '0';
						
						SIG_GEN_enable 	<= '0';
						SIG_GEN_reset 		<= '0';
						
						-- Still in the same state.
						nextState 			<= state_IDLE;
						

						
					-- In this state the reset process is initiated, ie the 
					-- "GRAIN_Generator" circuit is enabled to activate the 
					-- reset process.	
					WHEN state_STARTRESET =>
					
						busy 					<= '1';
						
						SIG_GEN_enable 	<= '1';
						SIG_GEN_reset 		<= '1';
						
						readyByte 			<= '0';
					
						nextState <= state_DUMYRESET;
						
						
					
					-- State used only to keep the generator reset signal at
					-- a high level for a further clock cycle, because this 
					-- signal is synchronous.	
					WHEN state_DUMYRESET =>
					
						busy 					<= '1';
						
						SIG_GEN_enable 	<= '1';
						SIG_GEN_reset 		<= '1';
						
						readyByte 			<= '0';
					
						nextState 			<= state_FINISHRESET;
						
						
						
					-- State of completion of the generator reset process, in this state the 
					-- generator has already finished the reset process, so the circuit can 
					-- be disabled (interrupt clock) and the signal "SIG_GEN_reset" set to 
					-- logic level 0.	
					WHEN state_FINISHRESET =>
						
						busy 				<= '1';
					
						SIG_GEN_reset 	<= '0';
						SIG_GEN_enable <= '1';
						SIG_GEN_init 	<= '1';
						
						readyByte 		<= '0';
						
						nextState <= state_CICLE;
					
				
				
					-- In this state the generator delivery 160 pseudorandom bits that are
					-- discarded due to Grain recommendations. After finishing this cycle 
					-- the next state of FSM s "state_IDLE".
					WHEN state_CICLE =>
					
						busy <= '1';
						
						
						-- Vefifies if the generator delivery the 160 bits. If it finish, stop the
						-- generator and go to the IDLE state.
						IF (INIT_COUNTER = (INIT_CYCLES_GRAIN - 1)) THEN
						
							readyReset		<= '1';
							
							SIG_GEN_init 	<= '0';
						
							SIG_GEN_enable <= '0';
					
					
							nextState	<=  state_IDLE;
														
														
						-- Otherwise, if still have bits to generate, keep on this same state in 
						-- the next cicle.
						ELSE
						
							SIG_GEN_enable <= '1';
						
							INIT_COUNTER 	<= INIT_COUNTER + 1;
						
							nextState <= state_CICLE;
							
						END IF;
						
						
				
					-- In this state the generator is called 8 times so that the pseudorandom byte
					-- is ready. While the "RUN_COUNTER" is not equal to 8, the FSM stay in this 
					-- same state in the next clock cicle, otherwise the FSM go to the "state_IDLE".
					WHEN state_RUN =>	
					
						busy 					<= '1';
							
						readyByte 			<= '0';
						
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

							IF RUN_COUNTER = 7 THEN
						
								SIG_GEN_enable 	<= '0';
								
							ELSE
							
								SIG_GEN_enable 	<= '1';
								
							END IF;
													
							readyByte 			<= '0';
							
							SIG_Keystream(RUN_COUNTER) <= SIG_GEN_bitOut;
						
							RUN_COUNTER <= RUN_COUNTER + 1;
							
							
							-- Keep on the "state_RUN" state in the next cicle.
							nextState <= state_RUN;
							
						END IF;

						
						
					-- Invalid states - do nothing.		
					WHEN OTHERS =>
					
						nextState <= STATE_IDLE;
						
						
				END CASE;
			
			END IF;	
	
		END IF;
	
	
	END PROCESS;
	
	
END BEHAVIOR;
-- End of the GRAIN_Toplevel architecture declaration.