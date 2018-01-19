--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#        		    File for Grain generator descripton. 					     #
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
--# File: GRAIN_Generator.vhd                                             #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Imports user libraries.
USE WORK.GRAIN_Functions.ALL;



-- Start the GRAIN_Generator entity declaration.
ENTITY GRAIN_Generator IS
	
	PORT 
	(
		clock		: IN 	STD_LOGIC;		-- Clock signal.
		reset		: IN 	STD_LOGIC;		-- Circuit reset signal.
		key		: IN 	t_KEY_GRAIN;	-- Cipher key.
		iv			: IN 	t_IV_GRAIN;		-- Cipher IV.
		enable 	: IN  STD_LOGIC;		-- (1) enable bit generation (0) disable.
		init 		: IN  STD_LOGIC;		-- (1) start the initialization process (0) otherwise.
		bitOut	: OUT STD_LOGIC		-- Pseudorandom bit generated.
	);
	
END GRAIN_Generator;
-- Finish the GRAIN_Generator entity declaration.




-- Beginning of the GRAIN_Generator architecture declaration.
ARCHITECTURE BEHAVIOR OF GRAIN_Generator IS

	-- The LFSR part.
	SIGNAL SIG_LFSR : t_LFSR_GRAIN;
	
	-- The NFSR part.
	SIGNAL SIG_NFSR : t_NFSR_GRAIN;

	-- Auxiliar signals for intermediate calculations. 
	SIGNAL SIG_FX, SIG_GX, SIG_HX, SIG_bitOut : STD_LOGIC;
	
	-- Intermediare clock signal, used for enable control.
	SIGNAL SIG_clock : STD_LOGIC;
	
BEGIN

	-- Enable clock process, when "enable" = '1' the circuit work normally,
	-- otherwise, the circuit will not generate a new pseudorandom bit, because
	-- your clock signal will be drive to low level.
	SIG_clock <= enable AND clock;


	
	-- Main process.
	PROCESS(SIG_clock)
	BEGIN
	
		IF RISING_EDGE(SIG_clock) THEN
		
			-- Reset the circuit, only reset the FFs values, the full reset is performed in
			-- the TRIVIUM_TopLevel entity.
			IF (reset = '1') THEN
				
				SIG_NFSR <= key;
				SIG_LFSR <= iv & "1111111111111111";
		
			-- Do the feedback process.
			ELSE
		
				SIG_LFSR <= SIG_LFSR(1 TO 79) & '0';
				SIG_NFSR <= SIG_NFSR(1 TO 79) & '0';
						
				-- Checks if the circuit is in initialization process. In this case,
				-- the output function (bitOut) is fedback and xored with the input,
				-- both to the LFSR and to the NFSR.
				SIG_LFSR(79) 		<= SIG_FX XOR (SIG_bitOut AND init);
				SIG_NFSR(79) 		<= SIG_GX XOR (SIG_bitOut AND init);
				
			END IF;
			
		END IF;
		
	END PROCESS;
	
	
	-- Calculates the f(x) function.
	SIG_FX <= SIG_LFSR(62) XOR SIG_LFSR(51) XOR SIG_LFSR(38) XOR 
				 SIG_LFSR(23) XOR SIG_LFSR(13) XOR SIG_LFSR(0);
	
	
	-- Calculates the g(x) function.	
	SIG_GX <= SIG_LFSR(0)  XOR SIG_NFSR(62)  XOR 
				 SIG_NFSR(60) XOR SIG_NFSR(52)  XOR 
				 SIG_NFSR(45) XOR SIG_NFSR(37)  XOR 
				 SIG_NFSR(33) XOR SIG_NFSR(28)  XOR 
				 SIG_NFSR(21) XOR SIG_NFSR(14)  XOR 
				 SIG_NFSR(9)  XOR SIG_NFSR(0)   XOR
				(SIG_NFSR(63) AND SIG_NFSR(60)) XOR  
				(SIG_NFSR(37) AND SIG_NFSR(33)) XOR  
				(SIG_NFSR(15) AND SIG_NFSR(9))  XOR 
				(SIG_NFSR(60) AND SIG_NFSR(52)  AND SIG_NFSR(45)) XOR  
				(SIG_NFSR(33) AND SIG_NFSR(28)  AND SIG_NFSR(21)) XOR  
				(SIG_NFSR(63) AND SIG_NFSR(45)  AND SIG_NFSR(28)  AND SIG_NFSR(9))  XOR 
				(SIG_NFSR(60) AND SIG_NFSR(52)  AND SIG_NFSR(37)  AND SIG_NFSR(33)) XOR  
				(SIG_NFSR(63) AND SIG_NFSR(60)  AND SIG_NFSR(21)  AND SIG_NFSR(15)) XOR 
				(SIG_NFSR(63) AND SIG_NFSR(60)  AND SIG_NFSR(52)  AND SIG_NFSR(45)  AND SIG_NFSR(37)) XOR  
				(SIG_NFSR(33) AND SIG_NFSR(28)  AND SIG_NFSR(21)  AND SIG_NFSR(15)  AND SIG_NFSR(9))  XOR 
				(SIG_NFSR(52) AND SIG_NFSR(45)  AND SIG_NFSR(37)  AND SIG_NFSR(33)  AND SIG_NFSR(28)  AND SIG_NFSR(21));
			
	
	-- Calculates the h(x) function.
	SIG_HX <=   SIG_LFSR(25) XOR 
					SIG_NFSR(63) XOR
				 ( SIG_LFSR(3)  AND SIG_LFSR(64) ) XOR 
				 ( SIG_LFSR(46) AND SIG_LFSR(64) ) XOR 
		       ( SIG_LFSR(64) AND SIG_NFSR(63) ) XOR 
				 ( SIG_LFSR(3)  AND SIG_LFSR(25)   AND SIG_LFSR(46) ) XOR 
				 ( SIG_LFSR(3)  AND SIG_LFSR(46)   AND SIG_LFSR(64) ) XOR 
				 ( SIG_LFSR(3)  AND SIG_LFSR(46)   AND SIG_NFSR(63) ) XOR 
				 ( SIG_LFSR(25) AND SIG_LFSR(46)   AND SIG_NFSR(63) ) XOR 
				 ( SIG_LFSR(46) AND SIG_LFSR(64)   AND SIG_NFSR(63) );
	        
			  
   -- Calculates the pseudorandom bit and store this value into a signal.
	SIG_bitOut <= 	SIG_NFSR(1)  XOR SIG_NFSR(2)  XOR 
						SIG_NFSR(4)  XOR SIG_NFSR(10) XOR 
						SIG_NFSR(31) XOR SIG_NFSR(43) XOR 
						SIG_NFSR(56) XOR SIG_HX;
					  
					  
	-- The circuit will be ready to send the pseudorandom bit when the "init" signal is low.
	bitOut <= SIG_bitOut AND NOT init;
				  
			  
END BEHAVIOR;
-- End of the GRAIN_Testbench architecture declaration.