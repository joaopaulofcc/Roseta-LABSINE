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
--# File: TRIVIUM_Testbench.vhd                                           #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;

-- Imports user libraries.
LIBRARY WORK;
USE WORK.TRIVIUM_Functions.ALL;
USE STD.TEXTIO.ALL;



-- Start the TRIVIUM_Testbench entity declaration.
ENTITY TRIVIUM_Testbench IS


END ENTITY TRIVIUM_Testbench;
-- Finish the TRIVIUM_Testbench entity declaration.




-- Beginning of the TRIVIUM_Testbench architecture declaration.
ARCHITECTURE BEHAVIOR OF TRIVIUM_Testbench IS
	
	-- Internal signals.
	SIGNAL SIG_clockIN		: STD_LOGIC;							-- Clock signal.
	SIGNAL SIG_reset			: STD_LOGIC;							-- Circuit reset signal.
	SIGNAL SIG_key				: t_KEY_TRIVIUM;						-- Key bus.
	SIGNAL SIG_iv				: t_IV_TRIVIUM;						-- IV bus.
	SIGNAL SIG_get				: STD_LOGIC;							-- Signal to request bytes (1).
	SIGNAL SIG_busy			: STD_LOGIC;							-- (1) Trivium is busy, (0) otherwise.
	SIGNAL SIG_readyReset	: STD_LOGIC;							-- (1) Trivium reset process is done.
	SIGNAL SIG_readyByte		: STD_LOGIC;							-- (1) Trivium byte generation is done.
	SIGNAL SIG_keystream		: STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Pseudorandom byte generated.
  
BEGIN

	-- Import and map TRIVIUM_Toplevel component ports with TestBench signals.
	UUT_TRIVIUM_Toplevel: ENTITY WORK.TRIVIUM_Toplevel PORT MAP                                          			    
	(
		clockIN		=> SIG_clockIN,
		reset			=> SIG_reset,
		key			=> SIG_key,
		iv				=> SIG_iv,
		get			=> SIG_get,
		busy			=> SIG_busy,
		readyReset	=> SIG_readyReset,
		readyByte	=> SIG_readyByte,
		keystream	=> SIG_keystream
	);	
		
				
	-- Start of clock control.	
	P_clockGen: PROCESS IS  
	BEGIN
		 	
		-- 10ns high e 10ns low = 50MHz
			
		SIG_clockIN <= '0';   -- Clock at low level for 10ns.
		
		WAIT FOR 10 ns; 
		
		SIG_clockIN <= '1';   -- Clock at high level for 10ns.
		
		WAIT FOR 10 ns;
		
	END PROCESS P_clockGen;
	-- End of clock control.
	
	
	-- Beginning of the main process.
	P_runGenerator: PROCESS IS  
		VARIABLE	VAR_key : t_KEY_TRIVIUM	:= x"0A5DB00356A9FC4FA2F5";  	-- Key value (20 hexa).
		VARIABLE	VAR_iv  : t_IV_TRIVIUM  := x"1F86ED54BB2289F057BE";	-- IV value  (20 hexa).
	BEGIN
	
		-- Loads the Key and IV in the Trivium toplevel module.
		SIG_key 		<= VAR_key;
		SIG_iv 		<= VAR_iv;
				
		-- Initiates the reset process.
		SIG_reset	<= '1';
		WAIT FOR 40 ns;
		SIG_reset	<= '0';
		WAIT UNTIL SIG_readyReset = '1';
		
		-- Requests the generation of random bytes to Trivium module.
		FOR i IN 0 TO 10 LOOP
		
			SIG_get 		<= '1';	
			WAIT FOR 40 ns;	
			SIG_get 		<= '0';
			WAIT UNTIL SIG_readyByte = '1';
		
		END LOOP;
		
		-- Wait infinite.
		WAIT;
					
	END PROCESS P_runGenerator;
	-- End of the main process.	
	
	
END ARCHITECTURE BEHAVIOR;
-- End of the TRIVIUM_Testbench architecture declaration.