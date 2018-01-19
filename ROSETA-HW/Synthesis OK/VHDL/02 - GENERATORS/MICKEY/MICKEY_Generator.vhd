--###########################################################################
--#	 		  Masters Program in Computer Science - UFLA - 2016/1           #
--#                                                                         #
--# 			 		        Hardware Implementations                          #
--#                                                                         #
--#      	       File for mickey generator description.    		  	       #
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
--# File: MICKEY_Generator.vhd                                              #
--#                                                                         #
--# About: This section describes the MICKEY generator, which is respon		 #
--#        sible for controlling the reset process according to the paper   # 
--#        specification, in addition to the generation of 1 pseudorandom   #
--#        bit per clock cycle														    # 
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Imports user libraries.
USE WORK.MICKEY_Functions.ALL;


-- Start the MICKEY_Generator entity declaration.
ENTITY MICKEY_Generator IS
	
	PORT 
	(
		clock			: IN 	STD_LOGIC;		-- Clock signal.
		reset			: IN 	STD_LOGIC;		-- Circuit reset signal.
		readyReset	: OUT STD_LOGIC;		-- (1) reset process is finished (0) otherwise
		key			: IN 	t_KEY_MICKEY;	-- Cipher Key.
		iv				: IN 	t_IV_MICKEY;	-- Cipher IV.
		enable 		: IN  STD_LOGIC;		-- (1) enable bit generation (0) disable.
		bitOut		: OUT STD_LOGIC		-- Pseudorandom bit generated.
	);
	
END MICKEY_Generator;
-- Finish the MICKEY_Generator entity declaration.



-- Beginning of the MICKEY_Generator architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_Generator IS

	-- Counter used in the reset process to control the initialization process.
	SIGNAL COUNTER : INTEGER RANGE 0 TO 260 := 0;

	-- Auxiliar signals for the Key and IV.
	SIGNAL SIG_key	: t_KEY_MICKEY;
	SIGNAL SIG_iv	: t_IV_MICKEY;

	-- The LFSR part.
	SIGNAL SIG_R	 		: t_LFSR_MICKEY := (OTHERS => '0');
	
	-- The NFSR part.
	SIGNAL SIG_S 			: t_NFSR_MICKEY := (OTHERS => '0');
	
	
	-- Signals to inport the MICKEY_GEN_clockKG.
	SIGNAL SIG_MICKEY_GEN_clockKG_S_out	: t_NFSR_MICKEY;
	SIGNAL SIG_MICKEY_GEN_clockKG_R_out	: t_LFSR_MICKEY;
	
	
	-- Intermediare clock signal used for enable control.
	SIGNAL SIG_clock : STD_LOGIC;
	
	-- Internal signals.
	SIGNAL SIG_mixing 	: STD_LOGIC;
	SIGNAL SIG_inputBit 	: STD_LOGIC;
	
	
	-- Finite State Machine for operation control.

		--	state_IDLE: 
		-- 		In this state no operation is performed, the circuit 
		-- 		is waiting in idle mode operation.
		
		
		-- state_RESET: 
		--			Is responsible for sending the IV bits of the key to the 
		-- 		underlying circuits and discarding the first 100 bits.
		
	TYPE controlFSM IS (state_IDLE, state_RESET);
	
	-- Control the next state of the FSM.
	SIGNAL nextState : controlFSM := state_IDLE;
		
		
BEGIN

	-- Enable clock process, when "enable" = '1' the circuit work normally,
	-- otherwise, the circuit will not generate a new pseudorandom bit, because
	-- your clock signal will be drive to low level.
	SIG_clock <= enable AND clock;
	
	-- Returns the pseudorandom bit.
	bitOut <= SIG_R(0) XOR SIG_S(0);
	
	
	-- Import and map the MICKEY_GEN_clockKG component.
	mapClockKG: ENTITY WORK.MICKEY_GEN_clockKG 
		PORT MAP
		(
			S_in 			=> SIG_S,
			R_in			=> SIG_R,
			S_out			=> SIG_MICKEY_GEN_clockKG_S_out,
			R_out			=> SIG_MICKEY_GEN_clockKG_R_out,
			inputBit		=> SIG_inputBit,
			mixing		=> SIG_mixing			
		);

		
	-- Import and map the MICKEY_GEN_sr component.
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
				
				
	-- Start the main process, triggered by changes in the clock signal.				
	PROCESS(SIG_clock)
	BEGIN
	
		-- If the clock signal is in rising edge.
		IF (RISING_EDGE(SIG_clock)) THEN
		
			-- Verifies if the "reset" signal is in high level, in this case,
			-- the reset process start and the FSM goes to the "state_RESET" 
			-- in the next cicle. Here the first bit of the IV is already sent
			--	to the underlying circuits, so it is necessary to disregard this
			-- value in the "stat_Reset" state, ie the "COUNTER" counter is 
			-- incremented to the value 1.
			IF (reset = '1') THEN
		
				SIG_key 	<= key;
				SIG_iv 	<= iv;
			
				-- Send the first bit of the IV.
				SIG_mixing 		<= '1';
				SIG_inputBit 	<= SIG_iv(0);
									
				COUNTER 			<= 1;
				
				-- Go to the "state_STARTRESET" state in the next clock cicle.
				nextState <= state_RESET;
				
			ELSE
	
				-- Verify the next state.
				CASE nextState is
				
					-- In this state no operation is performed, the circuit 
					-- is waiting for idle mode operation.
					WHEN state_IDLE =>
					
						SIG_mixing 		<= '0';
						SIG_inputBit 	<= '0';
						readyReset  	<= '0';
					
						nextState 		<= state_IDLE;
						
					
					
					-- Is responsible for sending the IV bits of the key to the 
					-- underlying circuits and discarding the first 100 bits.
					WHEN state_RESET =>
											
						-- Send the Key.
						IF COUNTER < 80 THEN
						
							SIG_mixing 		<= '1';
							SIG_inputBit 	<= SIG_iv(COUNTER);
							
							readyReset  	<= '0';
							
							COUNTER 			<= COUNTER + 1;
							
							nextState 		<= state_RESET;
						
						
						-- Send the IV.
						ELSIF COUNTER < 160 THEN
						
							SIG_mixing 		<= '1';
							SIG_inputBit 	<= SIG_key(COUNTER - 80);
							
							readyReset  	<= '0';
						
							COUNTER 			<= COUNTER + 1;
							
							nextState 		<= state_RESET;
						
						
						-- Clock 100 times.
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
							
						
						-- The reset process was finished.
						ELSE 
							
							SIG_mixing 		<= '0';
							SIG_inputBit 	<= '0';
							
							COUNTER 			<= 0;
							
							nextState 		<= state_IDLE;
							
						END IF;
						
						
						
					-- Invalid states.
					WHEN OTHERS =>
					
						SIG_mixing 		<= '0';
						SIG_inputBit 	<= '0';
					
				END CASE;
				
			END IF;
			
		END IF;
		
	END PROCESS;
	
END BEHAVIOR;
-- End of the MICKEY_Toplevel architecture declaration.