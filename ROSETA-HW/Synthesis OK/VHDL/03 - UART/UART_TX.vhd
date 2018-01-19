--###########################################################################
--#	 		  Masters Program in Computer Science - UFLA - 2016/1           #
--#                                                                         #
--# 			 		        Hardware Implementations                          #
--#                                                                         #
--#   	       File for UART Transmitter component description. 		   	 #
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
--# Taken from NANDLAN:																		 #
--#																							    #
--# Available in: <https://goo.gl/ZabFSQ>. Acess date: 09 dez. 2017.        #
--#                                                                         #
--#-------------------------------------------------------------------------#
--#                                                                         #
--# File: UART_TX.vhd                                                       #
--#                                                                         #
--# About: This file contains the UART Transmitter.  This transmitter is    #
--#        able to transmit 8 bits of serial data, one start bit, one stop  #
--# 		  bit, and no parity bit.  When transmit is complete Done will be  #
--# 		  driven high for one clock cycle. 		   	        					 #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Imports user libraries.
USE WORK.ROSETA_Functions.ALL;
 
 

-- Start the UART_TX entity declaration.
ENTITY UART_TX IS

	PORT
	(
		clockIN  : IN  STD_LOGIC;
		DV     	: IN  STD_LOGIC;
		Byte  	: IN  STD_LOGIC_VECTOR(0 TO 7);
		Act 		: OUT STD_LOGIC;
		TXD 		: OUT STD_LOGIC;
		Done   	: OUT STD_LOGIC
	);
	
END UART_TX;
-- Finish the UART_TX entity declaration.
 
 

 
-- Beginning of the UART_TX architecture declaration. 
ARCHITECTURE BEHAVIOR OF UART_TX IS
 
	-- Finite State Machine.
	TYPE controlFSM IS (state_IDLE, state_START, state_DATA, state_STOP, state_CLEAN);
	SIGNAL nextState : controlFSM := state_IDLE;
 
	-- Internal signals.
	SIGNAL r_Clk_Count : INTEGER RANGE 0 TO CLKBIT - 1 := 0;
	SIGNAL r_Bit_Index : INTEGER RANGE 0 TO 7 := 0;
	SIGNAL r_TX_Data   : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL r_TX_Done   : STD_LOGIC := '0';
   
BEGIN
 
   -- Main Process.
	PROCESS(clockIN)
	BEGIN

		-- Checks whether the clock signal is on the rising edge.
		IF RISING_EDGE(clockIN) THEN
         
			CASE nextState IS 
 
				-- State where the circuit is idle, waiting for operation.
				WHEN state_IDLE =>
					
					Act 			<= '0';
					TXD 			<= '1'; -- Drive Line High for Idle
					
					r_TX_Done   <= '0';
					r_Clk_Count <= 0;
					r_Bit_Index <= 0;
 
					-- If the data send trigger signal is activated, it
					-- directs the data to the correct bus and changes
					-- the FSM to the "state_START".
					IF DV = '1' THEN
					
						r_TX_Data <= Byte;
						nextState <= state_START;
					
					-- Otherwise it remains in the same state.
					ELSE
				
						nextState <= state_IDLE;
					
					END IF;
 
 
           
				-- Send out Start Bit. Start bit = 0
				WHEN state_START =>
					
					Act <= '1';
					TXD <= '0';
 
					-- Wait CLKBIT-1 clock cycles for start bit to finish
					IF r_Clk_Count < CLKBIT-1 THEN
						
						r_Clk_Count <= r_Clk_Count + 1;
						nextState   <= state_START;
					
					ELSE
						
						r_Clk_Count <= 0;
						nextState   <= state_DATA;
						
					END IF;
 
 
           
				-- Wait CLKBIT-1 clock cycles for data bits to finish          
				WHEN state_DATA =>
					
					TXD <= r_TX_Data(r_Bit_Index);
           
					IF r_Clk_Count < CLKBIT - 1 THEN
					
						r_Clk_Count <= r_Clk_Count + 1;
						nextState   <= state_DATA;
					
					ELSE
						
						r_Clk_Count <= 0;
             
						-- Check if we have sent out all bits
						IF r_Bit_Index < 7 THEN
						
							r_Bit_Index <= r_Bit_Index + 1;
							nextState   <= state_DATA;
						
						ELSE
							
							r_Bit_Index <= 0;
							nextState   <= state_STOP;
						
						END IF;
					
					END IF;
 
 
 
				-- Send out Stop bit.  Stop bit = 1
				WHEN state_STOP =>
					
					TXD <= '1';
 
					-- Wait CLKBIT-1 clock cycles for Stop bit to finish
					IF r_Clk_Count < CLKBIT-1 THEN
						
						r_Clk_Count <= r_Clk_Count + 1;
						nextState   <= state_STOP;
					
					ELSE
						
						r_TX_Done   <= '1';
						r_Clk_Count <= 0;
						nextState   <= state_CLEAN;
					
					END IF;
 
            
				
				-- Stay here 1 clock
				WHEN state_CLEAN =>
					
					Act <= '0';
					r_TX_Done   <= '1';
					nextState   <= state_IDLE;
           
             
				-- Invalid state.
				WHEN OTHERS =>
					
					nextState <= state_IDLE;
 
			END CASE;
		
		END IF;
	 
	END PROCESS;
	
	-- Sends signal warning the end of the process.
	Done <= r_TX_Done;
  
END BEHAVIOR;
-- End of the UART_TX architecture declaration.