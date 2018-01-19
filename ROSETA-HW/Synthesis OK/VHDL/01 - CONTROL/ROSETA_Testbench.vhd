--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#       File for simulation design over modelsim using testbench.		  #
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
--# File: ROSETA_Testbench.vhd                                            #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;
USE STD.TEXTIO.ALL;

-- Imports user libraries.
USE WORK.TRIVIUM_Functions.ALL;
USE WORK.GRAIN_Functions.ALL;
USE WORK.MICKEY_Functions.ALL;
USE WORK.ROSETA_Functions.ALL;



-- Start the ROSETA_Testbench entity declaration.
ENTITY ROSETA_Testbench IS


END ENTITY ROSETA_Testbench;
-- Finish the ROSETA_Testbench entity declaration.




-- Beginning of the ROSETA_Testbench architecture declaration.
ARCHITECTURE BEHAVIOR OF ROSETA_Testbench IS
	
	-- Internal signal for comunication with ROSETA top level entity.  
	SIGNAL SIG_CLOCK_50		: STD_LOGIC;
	SIGNAL SIG_UART_TXD		: STD_LOGIC;	
	SIGNAL SIG_UART_RXD		: STD_LOGIC;
	
	
	
	----------------------------------------------------------------------------------
	----------------------------------------------------------------------------------
	
	-- This function is responsible for sending data via UART protocol according to a Baud rate
	-- whose period is specified by the value of c_BIT_PERIOD
	-- 	Available in <https://goo.gl/ZabFSQ>
	PROCEDURE UART_WRITE_BYTE
		(
			i_data_in       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			SIGNAL o_serial : OUT STD_LOGIC
		) IS
	BEGIN
 
		-- Send Start Bit
		o_serial <= '0';
		WAIT FOR c_BIT_PERIOD;
	 
		-- Send Data Byte
		FOR ii IN 0 TO 7 LOOP
		 
			o_serial <= i_data_in(ii);
			WAIT FOR c_BIT_PERIOD;
			
		END LOOP;
	 
		-- Send Stop Bit
		o_serial <= '1';
		WAIT FOR c_BIT_PERIOD;
		 
	END UART_WRITE_BYTE;
  
	----------------------------------------------------------------------------------
	----------------------------------------------------------------------------------
  
  
BEGIN

	-- Import and map the ROSETA top level entity.
	UUT_ROSETA: ENTITY WORK.ROSETA PORT MAP                                          			    
	(
		CLOCK_50		=> SIG_CLOCK_50,
		UART_TXD		=> SIG_UART_TXD,
		UART_RXD		=> SIG_UART_RXD
	);	
	
	
	
	-- Start of clock control.	
	P_clockGen: PROCESS IS  
	BEGIN
		 	
		-- 10ns high e 10ns low = 50MHz
			
		SIG_CLOCK_50 <= '0';   -- Clock at low level for 10ns.
		
		WAIT FOR 10 ns; 
		
		SIG_CLOCK_50 <= '1';   -- Clock at high level for 10ns.
		
		WAIT FOR 10 ns;
		
	END PROCESS P_clockGen;
	-- End of clock control.
	
	
	
	-- Main Process
	P_runROSETA: PROCESS IS  
	BEGIN
	
		
		-- Choose the cryptosystem	
		UART_WRITE_BYTE(X"54", SIG_UART_RXD);
		
		-------------------------------------
		
		WAIT FOR 20 ns;
		
		
		-- Start the Key setup.
		UART_WRITE_BYTE(X"4B", SIG_UART_RXD);
		
		WAIT FOR 20 ns;
		
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
	
		-------------------------------------
	
		WAIT FOR 20 ns;
		
	
		-- Start the IV setup.
		UART_WRITE_BYTE(X"49", SIG_UART_RXD);
		
		WAIT FOR 20 ns;
						
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		UART_WRITE_BYTE(X"00", SIG_UART_RXD);
		
		-------------------------------------
		
		WAIT FOR 20 ns;
		
		
		-- Start circuit reset.
		UART_WRITE_BYTE(X"52", SIG_UART_RXD);
		
		
		-- Wait a clock time to ensure that the reset process is completed.
		WAIT FOR 20 ns;
		
		
		-- Start the get bytes process;
		UART_WRITE_BYTE(X"4E", SIG_UART_RXD);
	
		
		-- Wait infinite.
		WAIT;
					
	END PROCESS P_runROSETA;
		
END ARCHITECTURE BEHAVIOR;
-- End of the ROSETA_Testbench architecture declaration.