--###########################################################################
--#	 		  Masters Program in Computer Science - UFLA - 2016/1           #
--#                                                                         #
--# 			 		        Hardware Implementations                          #
--#                                                                         #
--#   	        File for UART Receiver component description. 		   	 #
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
--# File: UART_RX.vhd                                                       #
--#                                                                         #
--# About: This file contains the UART Receiver. This receiver is able to   #
--#        receive 8 bits of serial data, one start bit, one stop bit, and  #
--# 		  bit, no parity bit.  When receive is complete DV will be driven  #
--# 		  high for one clock cycle.      		   	        					 #
--#                                                                         #
--# 21/12/17 - Lavras - MG                                                  #
--###########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
-- Imports user libraries.
USE WORK.ROSETA_Functions.ALL; 


-- Start the UART_RX entity declaration.
ENTITY UART_RX IS

	PORT
	(
		clockIN 	: IN  STD_LOGIC;
		RXD 		: IN  STD_LOGIC;
		DV     	: OUT STD_LOGIC;
		Byte   	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	
END UART_RX;
-- Finish the UART_RX entity declaration.
 
 
 
 
-- Beginning of the UART_RX architecture declaration. 
ARCHITECTURE BEHAVIOR OF UART_RX IS
 
	-- Finite State Machine.
	TYPE controlFSM IS (state_IDLE, state_START, state_DATA, state_STOP, state_CLEAN);							
	SIGNAL nextState : controlFSM := state_IDLE;

	-- Internal signals.
	SIGNAL r_RX_Data_R : STD_LOGIC := '0';
	SIGNAL r_RX_Data   : STD_LOGIC := '0';
	SIGNAL r_Clk_Count : integer RANGE 0 to CLKBIT - 1 := 0;
	SIGNAL r_Bit_Index : integer RANGE 0 to 7 := 0;
	SIGNAL r_RX_Byte   : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL r_RX_DV     : STD_LOGIC := '0';
	
   
BEGIN
 
	-- Purpose: Double-register the incoming data.
	-- This allows it to be used in the UART RX Clock Domain.
	-- (It removes problems caused by metastabiliy)
  	PROCESS(clockIN)
	BEGIN
  
		IF RISING_EDGE(clockIN) THEN
	 
			r_RX_Data_R <= RXD;
			r_RX_Data   <= r_RX_Data_R;
		
		END IF;
	 
	END PROCESS;
   
	
 
	-- Purpose: Control RX state machine
	PROCESS (clockIN)
	BEGIN
  
  
		IF RISING_EDGE(clockIN) THEN
         
			CASE nextState IS
 
				WHEN state_IDLE =>
			  
					r_RX_DV     	<= '0';
					r_Clk_Count 	<= 0;
					r_Bit_Index 	<= 0;
	 
					-- Start bit was detected.
					IF r_RX_Data = '0' THEN

						nextState 	<= state_START;
				
					ELSE
					
						nextState 	<= state_IDLE;
						
					END IF;
	 
				  
				  
				-- Check middle of start bit to make sure it's still low
				WHEN state_START =>
			  
					IF r_Clk_Count = (CLKBIT - 1) / 2 THEN
					
						IF r_RX_Data = '0' THEN
						
							r_Clk_Count <= 0;  				-- reset counter since we found the middle
							nextState   <= state_DATA;
							
						ELSE
						
							nextState   <= state_IDLE;
						
						END IF;
						
					ELSE
					
						r_Clk_Count 	<= r_Clk_Count + 1;
						nextState   	<= state_START;
					
					END IF;
 
           
			  
				-- Wait CLKBIT - 1 clock cycles to sample serial data
				WHEN state_DATA =>
				
					-- If CLK counter is less then CLKBIT, increment CLK counter.
					IF r_Clk_Count < CLKBIT - 1 THEN
					
						r_Clk_Count <= r_Clk_Count + 1;
						nextState   <= state_DATA;
						
					-- Otherwise
					ELSE
						
						-- Reset counter.
						r_Clk_Count            <= 0;
						
						-- Receive the 0th bit from the input.
						r_RX_Byte(r_Bit_Index) <= r_RX_Data;
             
				 
						-- Receive all bits.
						IF r_Bit_Index < 7 THEN
						
							r_Bit_Index <= r_Bit_Index + 1;
							nextState   <= state_DATA;
							
						-- When finish, reset the index counter and go to
						-- STOP state in FSM.
						ELSE
						
							r_Bit_Index <= 0;
							nextState   <= state_STOP;
							
						END IF;
						
					END IF;
 
 
 
				-- Receive Stop bit. Stop bit = 1
				WHEN state_STOP =>
				
					-- Wait CLKBIT - 1 clock cycles for Stop bit to finish
					IF r_Clk_Count < CLKBIT - 1 THEN
					
						r_Clk_Count <= r_Clk_Count + 1;
						nextState   <= state_STOP;
					
					--	 Finish the receiving process and go to the exit state.
					ELSE
					
						-- Put HIGH value in the receive flag.
						r_RX_DV     <= '1';
						r_Clk_Count <= 0;
						nextState   <= state_CLEAN;
						
					END IF;
 
                   
						 
				-- Stay here 1 clock
				WHEN state_CLEAN =>
					
					-- Go to IDLE state.
					nextState <= state_IDLE;
					
					-- Put LOW value in the receive flag.
					r_RX_DV   <= '0';
 
 
            -- Invalid state. 
				WHEN OTHERS =>
				
					nextState <= state_IDLE;
 
			END CASE;
		
		END IF;
		
	END PROCESS;
 
	-- Redirect values from signals to the correspondent output buses.
	DV   <= r_RX_DV;
	Byte <= r_RX_Byte;
   
END BEHAVIOR;
-- End of the UART_RX architecture declaration.