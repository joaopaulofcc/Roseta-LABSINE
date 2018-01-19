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
--# File: MICKEY_Generator_Testbench.vhd                                  #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################


-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;
USE STD.TEXTIO.ALL;

-- User libraries.
USE WORK.MICKEY_Functions.ALL;




-- Start the MICKEY_Generator_Testbench entity declaration.
ENTITY MICKEY_Generator_Testbench IS


END ENTITY MICKEY_Generator_Testbench;
-- Finish the MICKEY_Generator_Testbench entity declaration.




-- Start the MICKEY_Generator_Testbench architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_Generator_Testbench IS
	
	-- Internal signal for comunication with MICKEY Generator entity.  
	SIGNAL SIG_clock			: STD_LOGIC;
	SIGNAL SIG_reset			: STD_LOGIC;
	SIGNAL SIG_readyReset	: STD_LOGIC;
	SIGNAL SIG_key				: t_KEY_MICKEY;
	SIGNAL SIG_iv				: t_IV_MICKEY;
	SIGNAL SIG_enable			: STD_LOGIC;
	SIGNAL SIG_bitOut			: STD_LOGIC;
	
BEGIN

	-- Import and map the MICKEY Generator entity.
	UUT_MICKEY_Generator: ENTITY WORK.MICKEY_Generator PORT MAP                                          			    
	(			
		clock			=> SIG_clock,
		reset			=> SIG_reset,
		readyReset	=> SIG_readyReset,
		key			=> SIG_key,
		iv				=> SIG_iv,
		enable 		=> SIG_enable,
		bitOut		=> SIG_bitOut
		
	);	
	
	
				
	-- Process for clock control
	P_clockGen: PROCESS IS  
	BEGIN
		 	
		-- 10 ns in high and 10 ns low level = 50 MHz
			
		SIG_clock <= '0';
		
		WAIT FOR 10 ns; 
		
		SIG_clock <= '1';
		
		WAIT FOR 10 ns;
		
	END PROCESS P_clockGen;
	
	
	
	-- Main Process
	P_runMICKEY: PROCESS IS  
	BEGIN
		
		SIG_key 	<= x"10000000000000000000";
		SIG_iv 	<= x"10000000000000000000";
		
		SIG_enable	<= '1';
		SIG_reset	<= '1';
		
		WAIT FOR 20 ns;
		
		SIG_reset	<= '0';
		
		WAIT UNTIL SIG_readyReset = '1';
		
		SIG_enable		<= '0';
		
		WAIT FOR 400 ns;
		
		SIG_enable		<= '1';
		
		WAIT;
					
	END PROCESS P_runMICKEY;
	
	
	
END ARCHITECTURE BEHAVIOR;
-- Finish the MICKEY_Generator_Testbench architecture declaration.