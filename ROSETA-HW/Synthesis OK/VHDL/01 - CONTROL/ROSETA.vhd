	--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					      Hardware Implementations                          #
--#                                                                       #
--#  Top Level component script responsible for generate keystream from   #
--#  choosed generators (Trivium, MICKEY, Grain) and send/receive data    #
--#  UART bus.                                                            #
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
--# File: ROSETA.vhd                                                      #
--#                                                                       #
--# About: This file describe a top level architecture of a crypto system #
--#        able to receive comands over UART, processing this commands    #
--#        and send processed data over UART. The supported commands are  #
--#        for setup Key/IV, reset the generator and generate a set of    #
--#        pseudorandom bytes, that will be sent over UART.               #
--#                                                                       #
--# 01/02/17 - Lavras - MG                                                #
--#########################################################################
 
 
 
 -- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- User libraries.
USE WORK.ROSETA_Functions.ALL;
USE WORK.TRIVIUM_Functions.ALL;
USE WORK.GRAIN_Functions.ALL;
USE WORK.MICKEY_Functions.ALL;



-- Start the ROSETA entity declaration.
ENTITY ROSETA IS
	
	PORT 
	(		
		CLOCK_50	: IN 	STD_LOGIC;		-- Clock signal.
		UART_TXD	: OUT STD_LOGIC;		-- Pins for send data over UART.
		UART_RXD	: IN 	STD_LOGIC		-- Pins for receive data over UART.
	);
	
END ROSETA;
-- Finish the ROSETA entity declaration.




-- Start the ROSETA architecture declaration.
ARCHITECTURE BEHAVIOR OF ROSETA IS

	-- Declare signals to perform connection with TRIVIUM Top Level.
	SIGNAL SIG_TRIVIUM_clockIN			: STD_LOGIC;
	SIGNAL SIG_TRIVIUM_reset			: STD_LOGIC;
	SIGNAL SIG_TRIVIUM_key				: t_KEY_TRIVIUM;
	SIGNAL SIG_TRIVIUM_iv				: t_IV_TRIVIUM;
	SIGNAL SIG_TRIVIUM_get				: STD_LOGIC;
	SIGNAL SIG_TRIVIUM_readyReset		: STD_LOGIC;
	SIGNAL SIG_TRIVIUM_readyByte		: STD_LOGIC;
	SIGNAL SIG_TRIVIUM_keystream		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	
	-- Declare signals to perform connection with GRAIN Top Level.
	SIGNAL SIG_GRAIN_clockIN			: STD_LOGIC;
	SIGNAL SIG_GRAIN_reset				: STD_LOGIC;
	SIGNAL SIG_GRAIN_key					: t_KEY_GRAIN;
	SIGNAL SIG_GRAIN_iv					: t_IV_GRAIN;
	SIGNAL SIG_GRAIN_get					: STD_LOGIC;
	SIGNAL SIG_GRAIN_readyReset		: STD_LOGIC;
	SIGNAL SIG_GRAIN_readyByte			: STD_LOGIC;
	SIGNAL SIG_GRAIN_keystream			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	
	-- Declare signals to perform connection with MICKEY Top Level.
	SIGNAL SIG_MICKEY_clockIN			: STD_LOGIC;
	SIGNAL SIG_MICKEY_reset				: STD_LOGIC;
	SIGNAL SIG_MICKEY_key				: t_KEY_MICKEY;
	SIGNAL SIG_MICKEY_iv					: t_IV_MICKEY;
	SIGNAL SIG_MICKEY_get				: STD_LOGIC;
	SIGNAL SIG_MICKEY_readyReset		: STD_LOGIC;
	SIGNAL SIG_MICKEY_readyByte		: STD_LOGIC;
	SIGNAL SIG_MICKEY_keystream		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	
	-- Declare signals to perform connection with UART RX module.
	SIGNAL SIG_RX_clockIN				: STD_LOGIC;
	SIGNAL SIG_RX_RXD						: STD_LOGIC;
	SIGNAL SIG_RX_DV						: STD_LOGIC;
	SIGNAL SIG_RX_Byte 					: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	
	-- Declare signals to perform connection with UART TX module.
	SIGNAL SIG_TX_clockIN				: STD_LOGIC;
	SIGNAL SIG_TX_DV						: STD_LOGIC;
	SIGNAL SIG_TX_Byte 					: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SIG_TX_TXD						: STD_LOGIC;
	SIGNAL SIG_TX_Done					: STD_LOGIC;
	
	
	-- Temporary signals to keep the received bytes of Key and IV.
	SIGNAL TEMP_KEY_TRIVIUM : t_KEY_TRIVIUM;
	SIGNAL TEMP_IV_TRIVIUM  : t_IV_TRIVIUM;
	SIGNAL TEMP_KEY_GRAIN 	: t_KEY_GRAIN;
	SIGNAL TEMP_IV_GRAIN  	: t_IV_GRAIN;
	SIGNAL TEMP_KEY_MICKEY 	: t_KEY_MICKEY;
	SIGNAL TEMP_IV_MICKEY  	: t_IV_MICKEY;
	
	
	-- Counters
	SIGNAL BYTES_GEN 			: INTEGER RANGE 0 TO BYTES_TO_GEN := 0; -- Count the quantity of pseudorandom bytes generated.
	SIGNAL KEY_BYTES_RECV	: INTEGER RANGE 0 TO 10 := 0;	 	 		 -- Count the quantity of key bytes received.
	SIGNAL IV_BYTES_RECV		: INTEGER RANGE 0 TO 10 := 0;		 		 -- Count the quantity of IV bytes received.
	
	
	-- Selects the criptosystem to be used.
	SIGNAL SIG_system	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	-- Finite State Machine for operation control.
	
		--	state_Control_IDLE: 
		-- 		state called when the hardware don't need to operate. In this,
		--		 	constantly verifies if there are some data incoming over UART RX.
		
		
		-- state_Control_STARTRESET: 
		--			state called when the hardware enter in reset mode. In this, the transmission
		--       over UART is disabled, the key and iv signals of selected criptosystem are 
		-- 		refreshed and his reset signal is turned on.
		-- 		The next FSM state is "state_Control_WAITBYTE".	
		
		
		-- state_Control_FINISHRESET:
		-- 		state called when the hardware exit from STARTRESET state one clock cicle ago,
		-- 		then is necessary to turn off the reset signal of selected criptosystem, so that
		-- 		the this hardware starts the reset operation. The FSM stay in this state,
		-- 		while the signal "readyReset" not turn on, indicating that the process of reset
		-- 		is finished. When this occurs the next FSM state is "state_Control_IDLE".
		
		
		-- state_Control_WAITBYTE: 
		--			state responsible for manage the pseudorandom bytes generation.
	
	
		-- state_Control_NewByte:
		-- 		state responsible for request a new pseudorandom byte to the selected criptosystem.
		
		
		-- state_Control_KEY:
		--			state responsible for coordinate the key setup. The key bits will be received over
		-- 		UART in "KEY_BYTES_TO_GEN" steps, each one receiving a total of 8 bits. After all 
		-- 		the bytes have been received, the signal "TEMP_KEY" will contain the new key.
		
		
		-- state_Control_IV:
		--			state responsible for coordinate the iv setup. The iv bits will be received over
		-- 		UART in "IV_BYTES_TO_GEN" steps, each one receiving a total of 8 bits. After all 
		-- 		the bytes have been received, the signal "TEMP_IV" will contain the new iv.
		
	TYPE controlFSM IS ( state_Control_IDLE,     state_Control_STARTRESET,  state_Control_DUMMYRESET, state_Control_FINISHRESET, 
								state_Control_NEWBYTE,  state_Control_DUMMYBYTE,   state_Control_WAITBYTE,   state_Control_SENDBYTE, 
								state_Control_KEY, 		state_Control_CONFIRMSEND, state_Control_IV);
							  
	-- Control the next state of the FSM.
	SIGNAL nextControl : controlFSM := state_Control_IDLE; 
	
	
	SIGNAL SIG_BYTE : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	
	
	
BEGIN

	-- Import and map the Trivium top level entity.
	mapTRIVIUM: ENTITY WORK.TRIVIUM_Toplevel 
		PORT MAP                                          			    
		(
			clockIN		=> SIG_TRIVIUM_clockIN,
			reset			=> SIG_TRIVIUM_reset,
			key			=> SIG_TRIVIUM_key,
			iv				=> SIG_TRIVIUM_iv,
			get			=> SIG_TRIVIUM_get,
			readyReset	=> SIG_TRIVIUM_readyReset,
			readyByte	=> SIG_TRIVIUM_readyByte,
			keystream	=> SIG_TRIVIUM_keystream
		);	
		
		
	-- Import and map the GRAIN top level entity.
	mapGRAIN: ENTITY WORK.GRAIN_Toplevel 
		PORT MAP                                          			    
		(
			clockIN		=> SIG_GRAIN_clockIN,
			reset			=> SIG_GRAIN_reset,
			key			=> SIG_GRAIN_key,
			iv				=> SIG_GRAIN_iv,
			get			=> SIG_GRAIN_get,
			readyReset	=> SIG_GRAIN_readyReset,
			readyByte	=> SIG_GRAIN_readyByte,
			keystream	=> SIG_GRAIN_keystream
		);
		
	
	-- Import and map the MICKEY top level entity.
	mapMICKEY: ENTITY WORK.MICKEY_Toplevel 
		PORT MAP                                          			    
		(
			clockIN		=> SIG_MICKEY_clockIN,
			reset			=> SIG_MICKEY_reset,
			key			=> SIG_MICKEY_key,
			iv				=> SIG_MICKEY_iv,
			get			=> SIG_MICKEY_get,
			readyReset	=> SIG_MICKEY_readyReset,
			readyByte	=> SIG_MICKEY_readyByte,
			keystream	=> SIG_MICKEY_keystream
		);
		
		
	-- Import and map the UART RX entity.
	mapUART_RX: ENTITY WORK.UART_RX
		PORT MAP
		(
			clockIN	=> SIG_RX_clockIN,
			RXD		=> UART_RXD,
			DV			=> SIG_RX_DV,
			Byte		=> SIG_RX_Byte
		);
		
		
	-- Import and map the UART TX entity.	
	mapUART_TX: ENTITY WORK.UART_TX
		PORT MAP
		(
			clockIN	=> SIG_TX_clockIN,
			DV			=> SIG_TX_DV,
			Byte		=> SIG_TX_Byte,
			TXD		=> UART_TXD,
			Done		=> SIG_TX_Done
		);
		
	
	-- Carries the external clock signal to all entities.
	SIG_TRIVIUM_clockIN 		<= CLOCK_50;
	SIG_GRAIN_clockIN 		<= CLOCK_50;
	SIG_MICKEY_clockIN 		<= CLOCK_50;
	SIG_RX_clockIN				<= CLOCK_50;
	SIG_TX_clockIN				<= CLOCK_50;
		
	
	-- Start the main process, triggered by changes in the clock signal.
	PROCESS(CLOCK_50) 
	BEGIN
	
		-- Check if is the rising edge of the clock.
		IF RISING_EDGE(CLOCK_50) THEN

		
			-- Verify the next state.
			CASE nextControl IS
		
				-- State called when the hardware don't need to operate. In this,
				-- constantly verifies if there are some data incoming over UART RX.
				WHEN state_Control_IDLE		=>
				
					-- Disable the transmission over UART.
					SIG_TX_DV			 	<= '0';	
					
					-- Inject low level in Trivium control signals.
					SIG_TRIVIUM_reset 	<= '0';
					SIG_TRIVIUM_get 		<= '0';
					
					-- Inject low level in Grain control signals.
					SIG_GRAIN_reset 		<= '0';
					SIG_GRAIN_get 			<= '0';
					
					-- Inject low level in MICKEY control signals.
					SIG_MICKEY_reset 		<= '0';
					SIG_MICKEY_get			<= '0';
					
					-- Reset the counters.
					KEY_BYTES_RECV 		<= 0;
					IV_BYTES_RECV 			<= 0;
					BYTES_GEN 				<= 0;
					
					
					-- Check if there are incoming data in UART RX.
					IF SIG_RX_DV = '1' THEN
					
					
						CASE SIG_RX_Byte IS
					
					
							-- If the incoming data is the command for select the Trivium criptosystem.
							-- Change the value of "SIG_system" signal.     OBS: x"54" = 'T'.
							WHEN x"54" =>
							
								SIG_system <= "00";
								nextControl <= state_Control_IDLE;
							
							
							
							-- If the incoming data is the command for select the Grain criptosystem.
							-- Change the value of "SIG_system" signal.     OBS: x"47" = 'G'.
							WHEN x"47" =>
							
								SIG_system <= "01";
								nextControl <= state_Control_IDLE;
							
							
							
							-- If the incoming data is the command for select the Mickey criptosystem.
							-- Change the value of "SIG_system" signal.     OBS: x"4D" = 'M'.
							WHEN x"4D" =>
								
								SIG_system <= "10";
								nextControl <= state_Control_IDLE;
								
								
								
							-- If the incoming data is the command for reset the circuits do to 
							-- the FSM state "state_Control_STARTRESET".    OBS: x"52" = 'R'.
							WHEN x"52" =>
							
								nextControl <= state_Control_STARTRESET;
								
								
								
							-- If the incoming data is the command for generate pseudorandom 
							-- bytes, turn on the cryptosystem get signal. 	OBS: x"4E" = 'N'.
							WHEN x"4E" =>
							
								nextControl <= state_Control_NEWBYTE;
								
								
								
							-- If the incoming data is the command for set the key value go to
							-- the FSM state "state_Control_KEY". 			   OBS: x"4B" = 'K'.
							WHEN x"4B" =>
								
								nextControl <= state_Control_KEY;
								
								
								
							-- If the incoming data is the command for set the key value go to
							-- the FSM state "state_Control_IV". 			   OBS: x"49" = 'I'.
							WHEN x"49" =>
							
								nextControl <= state_Control_IV;
								
								
								
							-- Default
							WHEN OTHERS => 
							
								nextControl <= state_Control_IDLE;
							
						END CASE;
					
					
					-- Otherwise, if there are none incoming data, stay in this same FSM state.
					ELSE
					
						nextControl	<= state_Control_IDLE;
						
					END IF;
			
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------		
			
			
			
				-- State called when the hardware enter in reset mode. In this,
				-- the transmission over UART is disabled, the key and iv signals
				-- of Trivium component are refreshed and his reset signal is turned on.
				-- The next FSM state is "state_Control_WAITBYTE".	
				WHEN state_Control_STARTRESET =>					
					
					CASE SIG_system IS
					
					
						-- Trivium
						WHEN "00" =>
						
							SIG_TRIVIUM_get		<= '0';
							SIG_TRIVIUM_key		<= TEMP_KEY_TRIVIUM;
							SIG_TRIVIUM_iv 		<= TEMP_IV_TRIVIUM;
							SIG_TRIVIUM_reset 	<= '1';
							
							nextControl 			<= state_Control_DUMMYRESET;
						
						
						-- Grain
						WHEN "01" =>
						
							SIG_GRAIN_get			<= '0';
							SIG_GRAIN_key			<= TEMP_KEY_GRAIN;
							SIG_GRAIN_iv 			<= TEMP_IV_GRAIN;
							SIG_GRAIN_reset 		<= '1';
							
							nextControl 			<= state_Control_DUMMYRESET;
						
						
						-- MICKEY
						WHEN "10" =>
						
							SIG_MICKEY_get			<= '0';
							SIG_MICKEY_key			<= TEMP_KEY_MICKEY;
							SIG_MICKEY_iv 			<= TEMP_IV_MICKEY;
							SIG_MICKEY_reset 		<= '1';
							
							nextControl 			<= state_Control_DUMMYRESET;
							
							
						-- Default
						WHEN OTHERS => 
						
							nextControl <= state_Control_IDLE;
						
					END CASE;
					
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------
			
			
			
				WHEN state_Control_DUMMYRESET =>
				
					nextControl <= state_Control_FINISHRESET;
			
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------
				
			
			
				-- State called when the hardware exit from STARTRESET state one clock cicle
				-- ago, then is necessary to turn off the reset signal of selected criptosystem,
				-- so that the this hardware starts the reset operation. The FSM stay in this state,
				-- while the signal "readyReset" not turn on, indicating that the process of reset
				-- is finished. When this occurs the next FSM state is "state_Control_IDLE".
				WHEN state_Control_FINISHRESET =>
				
					SIG_TRIVIUM_reset <= '0';
					SIG_GRAIN_reset 	<= '0';
					SIG_MICKEY_reset 	<= '0';				
				
					IF (SIG_TRIVIUM_readyReset = '1') OR 
						(SIG_GRAIN_readyReset 	= '1') OR 
						(SIG_MICKEY_readyReset 	= '1') THEN
						
						nextControl <= state_Control_IDLE;
					
					ELSE
					
						nextControl <= state_Control_FINISHRESET;
					
					END IF;
				
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------
				
				
				
				-- State responsible for request a new pseudorandom byte to the Trivium component.
				WHEN state_Control_NEWBYTE =>				
				
					CASE SIG_system IS
					
						-- Trivium
						WHEN "00" =>
						
							SIG_TRIVIUM_get 	<= '1';	
							nextControl 		<= state_Control_DUMMYBYTE;
						
						
						-- Grain
						WHEN "01" =>
						
							SIG_GRAIN_get 		<= '1';	
							nextControl 		<= state_Control_DUMMYBYTE;
						
						
						-- MICKEY
						WHEN "10" =>
						
							SIG_MICKEY_get 	<= '1';
							nextControl 		<= state_Control_DUMMYBYTE;
							
						
						-- Default
						WHEN OTHERS => 
						
							nextControl <= state_Control_IDLE;
						
					END CASE;
					
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------	
				
				
				
				WHEN state_Control_DUMMYBYTE =>
				
					nextControl 	<= state_Control_WAITBYTE;
					
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------	
				
				
				
				WHEN state_Control_WAITBYTE =>
				
					SIG_TRIVIUM_get	<= '0';
					SIG_GRAIN_get		<= '0';
					SIG_MICKEY_get		<= '0';
					
					IF (SIG_TRIVIUM_readyByte 	= '1') OR 
						(SIG_GRAIN_readyByte 	= '1') OR 
						(SIG_MICKEY_readyByte 	= '1') THEN
					
						nextControl <= state_Control_SENDBYTE;
					
					ELSE
					
						nextControl <= state_Control_WAITBYTE;
					
					END IF;
					
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------	
			
			
					
				-- State responsible for manage the pseudorandom bytes generation.
				WHEN state_Control_SENDBYTE =>
					
					SIG_TX_DV		<= '1';
					
					CASE SIG_system IS
				
						-- Trivium
						WHEN "00" =>
						
							BYTES_GEN 		<= BYTES_GEN + 1;
							SIG_TX_Byte		<= SIG_TRIVIUM_keystream;
							nextControl 	<= state_Control_CONFIRMSEND;	
						
						
						-- Grain
						WHEN "01" =>
						
							BYTES_GEN 		<= BYTES_GEN + 1;
							SIG_TX_Byte		<= SIG_GRAIN_keystream;	
							nextControl 	<= state_Control_CONFIRMSEND;
						
						
						-- MICKEY
						WHEN "10" =>
						
							BYTES_GEN 		<= BYTES_GEN + 1;
							SIG_TX_Byte		<= SIG_MICKEY_keystream;
							nextControl 	<= state_Control_CONFIRMSEND;
							
						
						-- Default
						WHEN OTHERS =>
						
							nextControl <= state_Control_IDLE;
						
					END CASE;
					
					--------------------------------------------------------------------------
					--------------------------------------------------------------------------	
					
					
					
					WHEN state_Control_CONFIRMSEND =>
							
						SIG_TX_DV <= '0';
				
				
						IF SIG_TX_Done = '1' THEN
						
							-- Checks if the quantity of bytes generated is less then the target,
							IF BYTES_GEN < BYTES_TO_GEN THEN
						
								nextControl <= state_Control_NEWBYTE;
								
							ELSE
							
								nextControl <= state_Control_IDLE;
								
							END IF;
						
						ELSE
						
							nextControl <= state_Control_CONFIRMSEND;
						
						END IF;
					
					--------------------------------------------------------------------------
					--------------------------------------------------------------------------

		
		
					--	State responsible for coordinate the key setup. The key bits will be 
					-- received over UART in "KEY_BYTES_TO_GEN" steps, each one receiving a
					-- total of 8 bits. After all the bytes have been received, the signal 
					-- "TEMP_KEY" will contain the new key.
					WHEN	state_Control_KEY =>
									
						CASE SIG_system IS
				
							-- Trivium
							WHEN "00" =>
							
								-- Checks if the number of bytes received is less then the target.
								IF KEY_BYTES_RECV < KEY_BYTES_TO_GEN_TRIVIUM THEN
																	
									-- Verifies if there is some incoming data.
									IF SIG_RX_DV = '1' THEN
									
										-- Filters according to the current byte index received.
										CASE KEY_BYTES_RECV IS
					
											WHEN 0 => TEMP_KEY_TRIVIUM(1  TO 8)  <= SIG_RX_Byte;
											WHEN 1 => TEMP_KEY_TRIVIUM(9  TO 16) <= SIG_RX_Byte;
											WHEN 2 => TEMP_KEY_TRIVIUM(17 TO 24) <= SIG_RX_Byte;
											WHEN 3 => TEMP_KEY_TRIVIUM(25 TO 32) <= SIG_RX_Byte;
											WHEN 4 => TEMP_KEY_TRIVIUM(33 TO 40) <= SIG_RX_Byte;
											WHEN 5 => TEMP_KEY_TRIVIUM(41 TO 48) <= SIG_RX_Byte;
											WHEN 6 => TEMP_KEY_TRIVIUM(49 TO 56) <= SIG_RX_Byte;
											WHEN 7 => TEMP_KEY_TRIVIUM(57 TO 64) <= SIG_RX_Byte;
											WHEN 8 => TEMP_KEY_TRIVIUM(65 TO 72) <= SIG_RX_Byte;
											WHEN 9 => TEMP_KEY_TRIVIUM(73 TO 80) <= SIG_RX_Byte;
											
											WHEN OTHERS => nextControl <= state_Control_IDLE;
											
										END CASE;
									
										-- Increment the byte counter.
										KEY_BYTES_RECV <= KEY_BYTES_RECV + 1;
									
										-- Stay in the same state to receive the next byte.
										nextControl <= state_Control_KEY;
									
									
									-- If there are none incoming byte over UART RX, stay in this same
									-- state in the next clock cicle.
									ELSE
									
										nextControl <= state_Control_KEY;
									
									END IF;
									
								
								-- If all the 10 bytes are loaded, go to the "state_Control_IDLE" state.
								ELSE
																						
									nextControl <= state_Control_IDLE;
								
								END IF;	
							
							
							-- Grain
							WHEN "01" =>
							
								IF KEY_BYTES_RECV < KEY_BYTES_TO_GEN_GRAIN THEN
								
									IF SIG_RX_DV = '1' THEN
									
										CASE KEY_BYTES_RECV IS
					
											WHEN 0 => TEMP_KEY_GRAIN(0  TO 7)  <= SIG_RX_Byte;
											WHEN 1 => TEMP_KEY_GRAIN(8  TO 15) <= SIG_RX_Byte;
											WHEN 2 => TEMP_KEY_GRAIN(16 TO 23) <= SIG_RX_Byte;
											WHEN 3 => TEMP_KEY_GRAIN(24 TO 31) <= SIG_RX_Byte;
											WHEN 4 => TEMP_KEY_GRAIN(32 TO 39) <= SIG_RX_Byte;
											WHEN 5 => TEMP_KEY_GRAIN(40 TO 47) <= SIG_RX_Byte;
											WHEN 6 => TEMP_KEY_GRAIN(48 TO 55) <= SIG_RX_Byte;
											WHEN 7 => TEMP_KEY_GRAIN(56 TO 63) <= SIG_RX_Byte;
											WHEN 8 => TEMP_KEY_GRAIN(64 TO 71) <= SIG_RX_Byte;
											WHEN 9 => TEMP_KEY_GRAIN(72 TO 79) <= SIG_RX_Byte;
											
											WHEN OTHERS => nextControl <= state_Control_IDLE;
											
										END CASE;
									
										KEY_BYTES_RECV <= KEY_BYTES_RECV + 1;
									
										nextControl <= state_Control_KEY;
									
									ELSE
									
										nextControl <= state_Control_KEY;
									
									END IF;
									
								-- If all the 10 bytes are loaded, go to the "state_Control_IDLE" state.
								ELSE
								
									nextControl <= state_Control_IDLE;
								
								END IF;
							
							
							-- MICKEY
							WHEN "10" =>
							
								IF KEY_BYTES_RECV < KEY_BYTES_TO_GEN_MICKEY THEN
								
									IF SIG_RX_DV = '1' THEN
									
										CASE KEY_BYTES_RECV IS
					
											WHEN 0 => TEMP_KEY_MICKEY(0  TO 7)  <= SIG_RX_Byte;
											WHEN 1 => TEMP_KEY_MICKEY(8  TO 15) <= SIG_RX_Byte;
											WHEN 2 => TEMP_KEY_MICKEY(16 TO 23) <= SIG_RX_Byte;
											WHEN 3 => TEMP_KEY_MICKEY(24 TO 31) <= SIG_RX_Byte;
											WHEN 4 => TEMP_KEY_MICKEY(32 TO 39) <= SIG_RX_Byte;
											WHEN 5 => TEMP_KEY_MICKEY(40 TO 47) <= SIG_RX_Byte;
											WHEN 6 => TEMP_KEY_MICKEY(48 TO 55) <= SIG_RX_Byte;
											WHEN 7 => TEMP_KEY_MICKEY(56 TO 63) <= SIG_RX_Byte;
											WHEN 8 => TEMP_KEY_MICKEY(64 TO 71) <= SIG_RX_Byte;
											WHEN 9 => TEMP_KEY_MICKEY(72 TO 79) <= SIG_RX_Byte;
											
											WHEN OTHERS => nextControl <= state_Control_IDLE;
											
										END CASE;
									
										KEY_BYTES_RECV <= KEY_BYTES_RECV + 1;
									
										nextControl <= state_Control_KEY;
									
									
									ELSE
									
										nextControl <= state_Control_KEY;
									
									END IF;
									
								
								ELSE
								
									nextControl <= state_Control_IDLE;
								
								END IF;
								
							
							-- Default
							WHEN OTHERS =>
							
								nextControl <= state_Control_IDLE;
							
						END CASE;
					
					--------------------------------------------------------------------------
					--------------------------------------------------------------------------	
						
						
					
					--	State responsible for coordinate the iv setup. The iv bits will be 
					-- received over UART in "IV_BYTES_TO_GEN" steps, each one receiving a
					-- total of 8 bits. After all the bytes have been received, the signal
				   --	"TEMP_IV" will contain the new iv.
					WHEN	state_Control_IV =>
					
						CASE SIG_system IS
				
							-- Trivium
							WHEN "00" =>
							
								-- Checks if the number of bytes received is less then the target.
								IF IV_BYTES_RECV < IV_BYTES_TO_GEN_TRIVIUM THEN
								
									-- Verifies if there is some incoming data.
									IF SIG_RX_DV = '1' THEN
									
										-- Filters according to the current byte index received.
										CASE IV_BYTES_RECV IS
					
											WHEN 0 => TEMP_IV_TRIVIUM(1  TO 8)  <= SIG_RX_Byte;
											WHEN 1 => TEMP_IV_TRIVIUM(9  TO 16) <= SIG_RX_Byte;
											WHEN 2 => TEMP_IV_TRIVIUM(17 TO 24) <= SIG_RX_Byte;
											WHEN 3 => TEMP_IV_TRIVIUM(25 TO 32) <= SIG_RX_Byte;
											WHEN 4 => TEMP_IV_TRIVIUM(33 TO 40) <= SIG_RX_Byte;
											WHEN 5 => TEMP_IV_TRIVIUM(41 TO 48) <= SIG_RX_Byte;
											WHEN 6 => TEMP_IV_TRIVIUM(49 TO 56) <= SIG_RX_Byte;
											WHEN 7 => TEMP_IV_TRIVIUM(57 TO 64) <= SIG_RX_Byte;
											WHEN 8 => TEMP_IV_TRIVIUM(65 TO 72) <= SIG_RX_Byte;
											WHEN 9 => TEMP_IV_TRIVIUM(73 TO 80) <= SIG_RX_Byte;
											
											WHEN OTHERS => nextControl <= state_Control_IDLE;
											
										END CASE;
									
										-- Increment the byte counter.
										IV_BYTES_RECV <= IV_BYTES_RECV + 1;
									
										-- Stay in the same state to receive the next byte.
										nextControl <= state_Control_IV;
									
									
									-- If there are none incoming byte over UART RX, stay in this same
									-- state in the next clock cicle.
									ELSE
										
										nextControl <= state_Control_IV;
									
									END IF;
									
									
								-- If all the 10 bytes are loaded, go to the "state_Control_IDLE" state.
								ELSE
																							
									nextControl <= state_Control_IDLE;
								
								END IF;	
							
							
							-- Grain
							WHEN "01" =>
							
								IF IV_BYTES_RECV < IV_BYTES_TO_GEN_GRAIN THEN
							
									IF SIG_RX_DV = '1' THEN
									
										CASE IV_BYTES_RECV IS
					
											WHEN 0 => TEMP_IV_GRAIN(0  TO 7)  <= SIG_RX_Byte;
											WHEN 1 => TEMP_IV_GRAIN(8  TO 15) <= SIG_RX_Byte;
											WHEN 2 => TEMP_IV_GRAIN(16 TO 23) <= SIG_RX_Byte;
											WHEN 3 => TEMP_IV_GRAIN(24 TO 31) <= SIG_RX_Byte;
											WHEN 4 => TEMP_IV_GRAIN(32 TO 39) <= SIG_RX_Byte;
											WHEN 5 => TEMP_IV_GRAIN(40 TO 47) <= SIG_RX_Byte;
											WHEN 6 => TEMP_IV_GRAIN(48 TO 55) <= SIG_RX_Byte;
											WHEN 7 => TEMP_IV_GRAIN(56 TO 63) <= SIG_RX_Byte;
											
											WHEN OTHERS => nextControl <= state_Control_IDLE;
											
										END CASE;
									
										IV_BYTES_RECV <= IV_BYTES_RECV + 1;
									
										nextControl <= state_Control_IV;
									
									
									ELSE
									
										nextControl <= state_Control_IV;
									
									END IF;
									
									
								ELSE
															
									nextControl <= state_Control_IDLE;
								
								END IF;
							
							
							-- MICKEY
							WHEN "10" =>
							
								IF IV_BYTES_RECV < IV_BYTES_TO_GEN_MICKEY THEN
								
									IF SIG_RX_DV = '1' THEN
									
										CASE IV_BYTES_RECV IS
					
											WHEN 0 => TEMP_IV_MICKEY(0  TO 7)  <= SIG_RX_Byte;
											WHEN 1 => TEMP_IV_MICKEY(8  TO 15) <= SIG_RX_Byte;
											WHEN 2 => TEMP_IV_MICKEY(16 TO 23) <= SIG_RX_Byte;
											WHEN 3 => TEMP_IV_MICKEY(24 TO 31) <= SIG_RX_Byte;
											WHEN 4 => TEMP_IV_MICKEY(32 TO 39) <= SIG_RX_Byte;
											WHEN 5 => TEMP_IV_MICKEY(40 TO 47) <= SIG_RX_Byte;
											WHEN 6 => TEMP_IV_MICKEY(48 TO 55) <= SIG_RX_Byte;
											WHEN 7 => TEMP_IV_MICKEY(56 TO 63) <= SIG_RX_Byte;
											WHEN 8 => TEMP_IV_MICKEY(64 TO 71) <= SIG_RX_Byte;
											WHEN 9 => TEMP_IV_MICKEY(72 TO 79) <= SIG_RX_Byte;
											
											WHEN OTHERS => nextControl <= state_Control_IDLE;
											
										END CASE;
									
										IV_BYTES_RECV <= IV_BYTES_RECV + 1;
									
										nextControl <= state_Control_IV;
									
									
									ELSE
									
										nextControl <= state_Control_IV;
									
									END IF;
									
									
								ELSE
								
									nextControl <= state_Control_IDLE;
								
								END IF;
								
							
							-- Default
							WHEN OTHERS =>
							
								nextControl <= state_Control_IDLE;
							
						END CASE;
					
				--------------------------------------------------------------------------
				--------------------------------------------------------------------------	
				
				
					
				-- Invalid states.	
				WHEN OTHERS => nextControl <= state_Control_IDLE;
				
				
			END CASE;
					
			
		END IF;
		
		
	END PROCESS;
	
	
END BEHAVIOR;