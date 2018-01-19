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
--# File: MICKEY_Testbench.vhd 	                                         #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################


-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;

-- Imports user libraries.
LIBRARY WORK;
USE WORK.MICKEY_Functions.ALL;
USE STD.TEXTIO.ALL;



-- Start the MICKEY_Testbench entity declaration.
ENTITY MICKEY_Testbench IS


END ENTITY MICKEY_Testbench;
-- Finish the MICKEY_Testbench entity declaration.



-- Beginning of the MICKEY_Testbench architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_Testbench IS
	
	-- Internal signals.
	SIGNAL SIG_clockIN		: STD_LOGIC;							-- Clock signal.
	SIGNAL SIG_reset			: STD_LOGIC;							-- Circuit reset signal.
	SIGNAL SIG_key				: t_KEY_MICKEY;						-- Key bus.
	SIGNAL SIG_iv				: t_IV_MICKEY;							-- IV bus.
	SIGNAL SIG_get				: STD_LOGIC;							-- Signal to request bytes (1).
	SIGNAL SIG_busy			: STD_LOGIC;							-- (1) MICKEY is busy, (0) otherwise.
	SIGNAL SIG_readyReset	: STD_LOGIC;							-- (1) MICKEY reset process is done.
	SIGNAL SIG_readyByte		: STD_LOGIC;							-- (1) MICKEY byte generation is done.
	SIGNAL SIG_keystream		: STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Pseudorandom byte generated.
  
BEGIN

	-- Import and map MICKEY_Toplevel component ports with TestBench signals.
	UUT_MICKEY_Toplevel: ENTITY WORK.MICKEY_Toplevel PORT MAP                                          			    
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
		VARIABLE	VAR_key : t_KEY_MICKEY	:= x"00000000000000000000";  	-- Key value (20 hexa).
		VARIABLE	VAR_iv  : t_IV_MICKEY  	:= x"00000000000000000000";	-- IV value  (20 hexa).
	BEGIN
	
		-- Loads the Key and IV in the MICKEY toplevel module.
		SIG_key 		<= x"00000000000000000000";
		SIG_iv 		<= x"00000000000000000000";
				
		-- Initiates the reset process.
		SIG_reset	<= '1';
		WAIT FOR 40 ns;
		SIG_reset	<= '0';
		WAIT UNTIL SIG_readyReset = '1';
		
		-- Requests the generation of random bytes to MICKEY module.
		FOR i IN 0 TO 10 LOOP
		
			SIG_get 		<= '1';	
			WAIT FOR 40 ns;	
			SIG_get 		<= '0';
			WAIT UNTIL SIG_readyByte = '1';
		
		END LOOP;
		
		
		
		-- Loads the Key and IV in the MICKEY toplevel module.
		SIG_key 		<= x"10000000000000000000";
		SIG_iv 		<= x"00000000000000000000";
		
		-- Initiates the reset process.
		SIG_reset	<= '1';
		WAIT FOR 40 ns;
		SIG_reset	<= '0';
		WAIT UNTIL SIG_readyReset = '1';
		
		-- Requests the generation of random bytes to MICKEY module.
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
-- End of the MICKEY_Testbench architecture declaration.