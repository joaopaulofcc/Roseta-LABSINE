--###########################################################################
--#	 		  Masters Program in Computer Science - UFLA - 2016/1           #
--#                                                                         #
--# 			 		        Hardware Implementations                          #
--#                                                                         #
--#    Top Level component responsible to control the MICKEY functions.     #
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
--# File: MICKEY_Toplevel.vhd                                               #
--#                                                                         #
--# About: This file describe a top level architecture of the MICKEY gen    #
--#        erator. Is responsible to call the generator reset process and   #
--# 		  also the byte generation by means of call the "MICKEY_Generator" #
--#        10 times. 																	    #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Imports user libraries.
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




-- Beginning of the MICKEY_Toplevel architecture declaration.
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
	SIGNAL SIG_GEN_bitOut		: STD_LOGIC;
	
	
	-- Finite State Machine for operation control.
	
		--	state_IDLE: 
		-- 		In this state no operation is performed, the circuit 
		-- 		is waiting for idle mode operation.
		
		
		-- state_STARTRESET: 
		--			In this state the reset process is initiated, ie the 
		-- 		"MICKEY_Generator" circuit is enabled to activate the 
		-- 		reset process.
		
		
		-- state_DUMYRESET:
		--			State used only to keep the generator reset signal at
		-- 		a high level for a further clock cycle, because this 
		-- 		signal is synchronous.
		
		
		-- state_FINISHRESET:
		--			State of completion of the generator reset process, in this state is 
		-- 		checked if the generator has already finished the reset process, if 
		-- 		have finished the next state of the FSM will be the IDLE state, otherwise
		-- 		the WSF will remain in this same state in the next cycle.
		
		
		-- state_PRERUN: 
		-- State executed after this circuit receives the request for generating new 
		-- byte. It is of fundamental importance because it will be responsible for 
		-- activating the generator, receive the first pseudorandom bit and forwarding
		-- the FSM to the state of byte generation. This state is required because the
		--	"get" signal is synchronous.
		
		
		-- state_RUN: 
		-- 		State of completion of the generator reset process, in this state the 
		-- 		generator has already finished the reset process, so the circuit can 
		-- 		be disabled (interrupt clock) and the signal "SIG_GEN_reset" set to 
		-- 		logic level 0.	
		
		
		-- state_SEND: 
		-- 		Upon completion of receiving the 8 pseudorandom bits, this 
		-- 		state is called to then send the byte via the serial interface.
		
	TYPE controlFSM IS (state_IDLE,state_STARTRESET, state_DUMYRESET, state_FINISHRESET, state_PRERUN, state_RUN, state_SEND);
	
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
			bitOut		=> SIG_GEN_bitOut
		);

		
	-- Carries the external clock to the generator.
	SIG_GEN_clock 		<= clockIN;

	
	
	-- Start the main process, triggered by changes in the clock signal.
	PROCESS(clockIN) 
	BEGIN
	
		-- If the clock signal is in rising edge.
		IF (RISING_EDGE(clockIN)) THEN
		
		
			-- Verifies if the "get" signal is in high level, in this case, 
			-- the FSM go to the "state_RUN" in the next cicle.
			IF (get = '1') THEN
				
				-- Disable the generator.
				SIG_GEN_enable <= '0';
						
				nextState <= state_PRERUN;
						

			-- Verifies if the "reset" signal is in high level, in this case,
			-- the reset process start and the FSM goes to the "state_RUN" 
			-- in the next cicle.
			ELSIF (reset = '1') THEN
			
				-- The "reversed" key and iv values are drive to the generator.
				SIG_GEN_key 	<= key;
				SIG_GEN_iv  	<= iv;
			
				-- Reset the counters.
				RUN_COUNTER		<= 0;
								
				-- Reset the flag pins.
				readyReset		<= '0';
				readyByte 		<= '0';
				
				-- Disable the generator.
				SIG_GEN_enable <= '0';
				
				-- Initialize the keystream with high impedance values.
				keystream 		<= (OTHERS => 'Z');
			
				-- Go to the "state_STARTRESET" state in the next clock cicle.
				nextState 		<= state_STARTRESET;
				
				
			ELSE

				-- Verify the next state.
				CASE nextState IS
			
					-- In this state no operation is performed, the circuit 
					-- is waiting for idle mode operation.
					WHEN state_IDLE =>
					
						busy 					<= '0';
						
						readyByte 			<= '0';
						readyReset			<= '0';
						
						SIG_GEN_enable 	<= '0';
						SIG_GEN_reset 		<= '0';
						
						-- Still in the same state.
						nextState 			<= state_IDLE;
						
						
					
					-- In this state the reset process is initiated, ie the 
					-- "MICKEY_Generator" circuit is enabled to activate the 
					-- reset process.	
					WHEN state_STARTRESET =>
					
						busy 					<= '1';
						
						SIG_GEN_enable 	<= '1';
						SIG_GEN_reset 		<= '1';
						
						readyByte 			<= '0';
						
						nextState 			<= state_DUMYRESET;
							
				
		
					-- State used only to keep the generator reset signal at
					-- a high level for a further clock cycle, because this 
					-- signal is synchronous.
					WHEN state_DUMYRESET =>
						
						busy 					<= '1';
						
						SIG_GEN_enable 	<= '1';
						SIG_GEN_reset 		<= '1';
						
						readyByte 			<= '0';
					
						nextState 			<= state_FINISHRESET;

		
						
					-- State of completion of the generator reset process, in this state is 
					-- checked if the generator has already finished the reset process, if 
					-- have finished the next state of the FSM will be the IDLE state, otherwise
					-- the FSM will remain in this same state in the next cycle.
					WHEN state_FINISHRESET =>
					
						busy 					<= '1';
						
						-- Enable the generator.
						SIG_GEN_enable 	<= '1';
						
						-- Disable the generator reset signal.
						SIG_GEN_reset 		<= '0';
						
						readyByte 			<= '0';
							
							
						-- Verifies that the "MICKEY_Generator" has finished the reset process.
						IF SIG_GEN_readyReset = '1' THEN
							
							-- Signals that the reset process has been completed.
							readyReset 		<= '1';
							
							-- Disable the generator circuit.
							SIG_GEN_enable <= '0';
						
							-- Redirects the FSM to the "state_IDLE".
							nextState 		<= state_IDLE;
							
						ELSE
							
							-- The reset process is not completed.
							readyReset 		<= '0';
							
							-- Redirects the FSM to the "state_FINISHRESET".
							nextState 		<= state_FINISHRESET;
							
						END IF;
						
						
						
					-- State executed after this circuit receives the request for generating new 
					-- byte. It is of fundamental importance because it will be responsible for 
					-- activating the generator, receive the first pseudorandom bit and forwarding
					-- the FSM to the state of byte generation. This state is required because the
					--	"get" signal is synchronous.
					WHEN state_PRERUN => 
					
						-- Enables the generator circuit.
						SIG_GEN_enable 	<= '1';
						
						-- Reset ready flags.
						readyByte 			<= '0';
						readyReset			<= '0';
						
						-- Receive the first byte from generator.
						SIG_Keystream(7) 	<= SIG_GEN_bitOut;
						RUN_COUNTER 		<= 1;
						
						-- Redirects the FSM to the "state_RUN".
						nextState 			<= state_RUN;
						
						
						
					-- In this state the generator is called 8 times so that the pseudorandom byte
					-- is ready. While the "RUN_COUNTER" is not equal to 8, the FSM stay in this 
					-- same state in the next clock cicle, otherwise the FSM go to the "state_IDLE".
					WHEN state_RUN =>	
					
						busy 					<= '1';
							
						readyByte 			<= '0';
						readyReset			<= '0';
						
						SIG_GEN_reset 		<= '0';
						
						
						
						-- If the counter is equal to 8 redirects the FSM to the "state_SEND".
						IF RUN_COUNTER = 8 THEN
					
							readyByte 						<= '0';
							SIG_GEN_enable 				<= '0';
							
							nextState <= state_SEND;
								
								
						-- Otherwise, if the counter is less then 8, drive the output bit from generator to
						-- the correct byte position and increment the counter.
						ELSE
						
							readyByte 								<= '0';
							SIG_Keystream(7 - RUN_COUNTER) 	<= SIG_GEN_bitOut;
							RUN_COUNTER 							<= RUN_COUNTER + 1;
							
							-- If it is equal to 7 it disables the generator circuit, so that in the next clock 
							-- cycle it does not generate another bit
							IF RUN_COUNTER = 7 THEN
							
								SIG_GEN_enable <= '0';
								
							ELSE
							
								SIG_GEN_enable <= '1';
								
							END IF;
							
							-- Redirects the FSM to the "state_RUN".
							nextState <= state_RUN;
							
						END IF;
						
						
						
					-- Upon completion of receiving the 8 pseudorandom bits, this 
					-- state is called to then send the byte generated for the "ROSETA" 
					-- top level circuit and with this send the byte via the serial interface.	
					WHEN state_SEND =>
					
						-- Send the byte generated for the "ROSETA" top level circuit.
						keystream 		<= SIG_Keystream;
								
						-- Reset the byte counter.
						RUN_COUNTER 	<= 0;
						
						-- Disable the generator circuit.
						SIG_GEN_enable <= '0';
						
						-- Signals that the generator byte is ready.
						readyByte 		<= '1';
						
						-- Go to the "state_IDLE" state.
						nextState		<=  state_IDLE;
						
						
						
					-- Invalid states.
					WHEN OTHERS =>
						
						nextState <= STATE_IDLE;
						
						
				END CASE;
				
			END IF;
	
		END IF;
	
	END PROCESS;
	
	
END BEHAVIOR;
-- End of the MICKEY_Toplevel architecture declaration.