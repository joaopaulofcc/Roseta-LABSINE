--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      File for user definitions utilized in the Grain components.      #
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
--# File: Grain_Functions.vhd                                             #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- Start the GRAIN_Functions package declaration.
PACKAGE GRAIN_Functions IS

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||

	-- CONSTANTS DEFINITIONS

	CONSTANT KEY_SIZE_GRAIN				: INTEGER := 80;		-- Number of bits for the key.
	CONSTANT IV_SIZE_GRAIN				: INTEGER := 64;		-- Number of bits for the iv.
	CONSTANT FF_SIZE_GRAIN				: INTEGER := 80; 		-- Number of FF used in LFSR and NFSR.
	CONSTANT INIT_CYCLES_GRAIN			: INTEGER := 160; 	-- Number of cycles used in the reset initialization process.
	

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
	
	-- SUBTYPES DEFINITIONS
	
	SUBTYPE t_KEY_GRAIN			IS STD_LOGIC_VECTOR(0 TO KEY_SIZE_GRAIN - 1);	-- Used for key declaration.
	SUBTYPE t_IV_GRAIN			IS STD_LOGIC_VECTOR(0 TO IV_SIZE_GRAIN  - 1); 	-- Used for iv declaration.
	
	SUBTYPE t_LFSR_GRAIN			IS STD_LOGIC_VECTOR(0 TO FF_SIZE_GRAIN - 1);		-- Used for grain LFSR declaration.
	SUBTYPE t_NFSR_GRAIN			IS STD_LOGIC_VECTOR(0 TO FF_SIZE_GRAIN - 1);		-- Used for grain NFSR declaration.
	
END GRAIN_Functions;
-- Finish the GRAIN_Functions package declaration.