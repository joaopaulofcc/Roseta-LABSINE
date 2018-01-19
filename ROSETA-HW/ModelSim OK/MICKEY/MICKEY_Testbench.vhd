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
--# File: MICKEY_Testbench.vhd                                            #
--#                                                                       #
--# 23/10/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;
USE STD.TEXTIO.ALL;

-- User libraries.
USE WORK.MICKEY_Functions.ALL;
--USE WORK.ROSETA_Functions.ALL;




-- Start the MICKEY_Testbench entity declaration.
ENTITY MICKEY_Testbench IS


END ENTITY MICKEY_Testbench;
-- Finish the MICKEY_Testbench entity declaration.




-- Start the MICKEY_Testbench architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_Testbench IS
	
	-- Internal signal for comunication with MICKEY top level entity.  
	SIGNAL SIG_clockIN		: STD_LOGIC;
	SIGNAL SIG_reset			: STD_LOGIC;
	SIGNAL SIG_key				: t_KEY_MICKEY;
	SIGNAL SIG_iv				: t_IV_MICKEY;
	SIGNAL SIG_get				: STD_LOGIC;
	SIGNAL SIG_busy			: STD_LOGIC;
	SIGNAL SIG_readyReset	: STD_LOGIC;
	SIGNAL SIG_readyByte		: STD_LOGIC;
	SIGNAL SIG_keystream		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SIG_state_Top		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
BEGIN

	-- Import and map the MICKEY top level entity.
	UUT_MICKEY: ENTITY WORK.MICKEY_Toplevel PORT MAP                                          			    
	(	
		clockIN		=> SIG_clockIN,
		reset			=> SIG_reset,
		key			=> SIG_key,
		iv				=> SIG_iv,
		get			=> SIG_get,
		busy			=> SIG_busy,
		readyReset	=> SIG_readyReset,
		readyByte	=> SIG_readyByte,
		keystream	=> SIG_keystream,
		state_Top	=> SIG_state_Top
		
	);	
	
	
				
	-- Process for clock control
	P_clockGen: PROCESS IS  
	BEGIN
		 	
		-- 10 ns in high and 10 ns low level = 50 MHz
			
		SIG_clockIN <= '0';
		
		WAIT FOR 10 ns; 
		
		SIG_clockIN <= '1';
		
		WAIT FOR 10 ns;
		
	END PROCESS P_clockGen;
	
	
		
	-- Main Process
	P_runMICKEY: PROCESS IS
		VARIABLE	VAR_key : t_KEY_MICKEY := x"f11a5627ce43b61f8912";
		VARIABLE	VAR_iv  : t_IV_MICKEY  := x"9c532f8ac3ea4b2ea0f5";
	BEGIN
	
		
		SIG_key 		<= VAR_key;
	
		SIG_iv 		<= VAR_iv;
		
		SIG_get 		<= '0';	
		
		SIG_reset	<= '1';
		
		WAIT FOR 20 ns;
		
		SIG_reset	<= '0';
		
		WAIT UNTIL SIG_readyReset = '1';
		
		
		WAIT FOR 2000 ns;			

		
		FOR i IN 0 TO 50 LOOP
		
			SIG_get 		<= '1';	
		
			WAIT FOR 20 ns;	
			
			SIG_get 		<= '0';
			
			WAIT UNTIL SIG_readyByte = '1';
		
		END LOOP;
		
				
		-- Wait infinite.
		WAIT;
					
	END PROCESS P_runMICKEY;
	
	
	
END ARCHITECTURE BEHAVIOR;
-- Finish the MICKEY_Testbench architecture declaration.