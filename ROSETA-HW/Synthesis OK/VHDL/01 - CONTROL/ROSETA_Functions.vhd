--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      File for user definitions utilized in the Roseta components.     #
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
--# File: ROSETA_Functions.vhd                                            #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################

 
 
-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- Start the ROSETA_Functions package declaration.
PACKAGE ROSETA_Functions IS

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
	-- Defines the clock speed for UART BAUD.
	--
	-- Ex: Using 50 MHz and 460800 baud (max suported)
	--
	-- 		-> 50.000.000 / 460800 = ~108
	--
	-- Ex: Using 50 MHz and 230400 baud
	--
	-- 		-> 50.000.000 / 230400 = ~216
	--
	CONSTANT CLKBIT : NATURAL := 216;
	
	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
	
	-- Defines the limits for bytes generations 
	CONSTANT BYTES_TO_GEN 					: NATURAL := 76800; 	-- Pseudorandom bytes.
	
	-- Trivium
	CONSTANT KEY_BYTES_TO_GEN_TRIVIUM 	: NATURAL := 10; 		-- Key bytes.
	CONSTANT IV_BYTES_TO_GEN_TRIVIUM 	: NATURAL := 10;		-- IV bytes.
	
	-- Grain
	CONSTANT KEY_BYTES_TO_GEN_GRAIN 		: NATURAL := 10; 		-- Key bytes.
	CONSTANT IV_BYTES_TO_GEN_GRAIN 		: NATURAL := 8;		-- IV bytes.
	
	-- MICKEY
	CONSTANT KEY_BYTES_TO_GEN_MICKEY 	: NATURAL := 10; 		-- Key bytes.
	CONSTANT IV_BYTES_TO_GEN_MICKEY 		: NATURAL := 10;		-- IV bytes.
	
	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
	-- For testbench only -> c_BIT_PERIOD = CLKBIT * 2 * 10.
	CONSTANT c_BIT_PERIOD : TIME := 4340 ns;

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
END ROSETA_Functions;
-- Finish the ROSETA_Functions package declaration.