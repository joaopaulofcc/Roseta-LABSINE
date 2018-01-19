--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      File for user definitions utilized in the Trivium components.    #
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
--# File: TRIVIUM_Functions.vhd                                           #
--#                                                                       #
--# 21/12/17 - Lavras - MG                                                #
--#########################################################################



-- Imports system libraries.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- Start the TRIVIUM_Functions package declaration.
PACKAGE TRIVIUM_Functions IS

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||

	-- CONSTANTS DEFINITIONS

	CONSTANT KEY_SIZE_TRIVIUM			: INTEGER := 80;		-- Number of bits for the key.
	CONSTANT IV_SIZE_TRIVIUM			: INTEGER := 80;		-- Number of bits for the iv.
	CONSTANT FF_SIZE_TRIVIUM			: INTEGER := 288; 	-- Number of FF used in trivium generator.
	CONSTANT INIT_CYCLES_TRIVIUM		: INTEGER := 1152; 	-- Number of cycles used in the reset initialization process.
	

	--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||--||
	
	
	-- SUBTYPES DEFINITIONS
	
	SUBTYPE t_KEY_TRIVIUM	IS STD_LOGIC_VECTOR(1 TO KEY_SIZE_TRIVIUM);	-- Used for key declaration.
	SUBTYPE t_IV_TRIVIUM		IS STD_LOGIC_VECTOR(1 TO IV_SIZE_TRIVIUM); 	-- Used for iv declaration.
	SUBTYPE t_TRIVIUM			IS STD_LOGIC_VECTOR(1 TO FF_SIZE_TRIVIUM);	-- Used for trivium generator (LFSR) declaration.
	
END TRIVIUM_Functions;
-- Finish the TRIVIUM_Functions package declaration.