--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      File for user definitions utilized in the mickey components.     #
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
--# File: MICKEY_Functions.vhd                                            #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- Start the MICKEY_Functions package declaration.
PACKAGE MICKEY_Functions IS

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||

	-- CONSTANTS DEFINITIONS

	CONSTANT KEY_SIZE_MICKEY		: INTEGER := 80;		-- Number of bits for the key.
	CONSTANT IV_SIZE_MICKEY			: INTEGER := 80;		-- Number of bits for the iv.
	CONSTANT FF_SIZE_MICKEY			: INTEGER := 100; 	-- Number of FF used in LFSR and NFSR.
	CONSTANT INIT_CYCLES_MICKEY	: INTEGER := 100; 	-- Number of cycles used in the reset initialization process.
	

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
	
	-- SUBTYPES DEFINITIONS
	
	SUBTYPE t_KEY_MICKEY			IS STD_LOGIC_VECTOR(0 TO KEY_SIZE_MICKEY - 1);	-- Used for key declaration.
	SUBTYPE t_IV_MICKEY			IS STD_LOGIC_VECTOR(0 TO IV_SIZE_MICKEY  - 1); 	-- Used for iv declaration.
	
	SUBTYPE t_LFSR_MICKEY		IS STD_LOGIC_VECTOR(0 TO FF_SIZE_MICKEY - 1);	-- Used for MICKEY LFSR declaration.
	SUBTYPE t_NFSR_MICKEY		IS STD_LOGIC_VECTOR(0 TO FF_SIZE_MICKEY - 1);	-- Used for MICKEY NFSR declaration.
	
END MICKEY_Functions;
-- Finish the MICKEY_Functions package declaration.