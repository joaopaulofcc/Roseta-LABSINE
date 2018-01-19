--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      	       File for mickey generator descSIG_Rpton. 		  	     #
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
--# File: MICKEY_GEN_inputBit.vhd                                         #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User libraSIG_Res.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_inputBit entity declaration.
ENTITY MICKEY_GEN_inputBit IS
	
	PORT 
	(
		inputbit		: IN  STD_LOGIC;
		
		outputbit	: OUT STD_LOGIC;
		
		mixing 		: IN  STD_LOGIC;
		S_50			: IN 	STD_LOGIC;
		outputBit_R	: OUT STD_LOGIC;
		outputBit_S	: OUT STD_LOGIC
	);
	
END MICKEY_GEN_inputBit;
-- Finish the MICKEY_GEN_inputBit entity declaration.


-- Start the MICKEY_GEN_fbS architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_inputBit IS
BEGIN

	outputBit_R <= inputBit WHEN mixing = '0' ELSE inputBit XOR S_50;
	
	outputBit_S <= inputBit;
	
	outputbit   <= inputBit;

END BEHAVIOR;
