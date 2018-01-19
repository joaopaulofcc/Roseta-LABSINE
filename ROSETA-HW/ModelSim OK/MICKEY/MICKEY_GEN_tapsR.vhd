--#########################################################################
--#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
--#                                                                       #
--# 					       Hardware Implementations                         #
--#                                                                       #
--#      	       File for mickey generator description. 		   	     #
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
--# File: MICKEY_GEN_tapsR.vhd                                            #
--#                                                                       #
--# 14/09/17 - Lavras - MG                                                #
--#########################################################################



-- Library import.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- User library.
USE WORK.MICKEY_Functions.ALL;



-- Start the MICKEY_GEN_tapsR entity declaration.
ENTITY MICKEY_GEN_tapsR IS
	
	PORT 
	(
		FB				: STD_LOGIC;
		R_in			: IN 	t_LFSR_MICKEY;
		R_out			: OUT t_LFSR_MICKEY
	);
	
END MICKEY_GEN_tapsR;
-- Finish the MICKEY_GEN_tapsR entity declaration.


-- Start the MICKEY_GEN_tapsR architecture declaration.
ARCHITECTURE BEHAVIOR OF MICKEY_GEN_tapsR IS

BEGIN
	
	R_out(0)		<= R_in(0)		XOR FB; 
	R_out(1)		<= R_in(1)		XOR FB; 
	R_out(2)		<= R_in(2); 
	R_out(3)		<= R_in(3)		XOR FB;
	R_out(4)		<= R_in(4) 		XOR FB; 
	R_out(5)		<= R_in(5)		XOR FB;
	R_out(6)		<= R_in(6)		XOR FB;  
	R_out(7)		<= R_in(7);
	R_out(8)		<= R_in(8);
	R_out(9)		<= R_in(9)		XOR FB; 
	R_out(10)	<= R_in(10);
	R_out(11)	<= R_in(11);
	R_out(12)	<= R_in(12)		XOR FB;  
	R_out(13)	<= R_in(13)		XOR FB;  
	R_out(14)	<= R_in(14);
	R_out(15)	<= R_in(15);
	R_out(16)	<= R_in(16)		XOR FB; 
	R_out(17)	<= R_in(17);
	R_out(18)	<= R_in(18); 
	R_out(19)	<= R_in(19)		XOR FB;  
	R_out(20)	<= R_in(20)		XOR FB; 
	R_out(21)	<= R_in(21)		XOR FB;  
	R_out(22)	<= R_in(22)		XOR FB;   
	R_out(23)	<= R_in(23);
	R_out(24)	<= R_in(24); 
	R_out(25)	<= R_in(25)		XOR FB;
	R_out(26)	<= R_in(26); 
	R_out(27)	<= R_in(27);
	R_out(28)	<= R_in(28)		XOR FB;   
	R_out(29)	<= R_in(29);
	R_out(30)	<= R_in(30);
	R_out(31)	<= R_in(31);
	R_out(32)	<= R_in(32);
	R_out(33)	<= R_in(33);
	R_out(34)	<= R_in(34); 
	R_out(35)	<= R_in(35);
	R_out(36)	<= R_in(36);
	R_out(37)	<= R_in(37)		XOR FB;
	R_out(38)	<= R_in(38)		XOR FB;
	R_out(39)	<= R_in(39);
	R_out(40)	<= R_in(40); 
	R_out(41)	<= R_in(41)		XOR FB;  
	R_out(42)	<= R_in(42)		XOR FB; 
	R_out(43)	<= R_in(43);
	R_out(44)	<= R_in(44); 
	R_out(45)	<= R_in(45)		XOR FB;  
	R_out(46)	<= R_in(46)		XOR FB; 
	R_out(47)	<= R_in(47);
	R_out(48)	<= R_in(48); 
	R_out(49)	<= R_in(49);
	R_out(50)	<= R_in(50)		XOR FB; 
	R_out(51)	<= R_in(51);
	R_out(52)	<= R_in(52)		XOR FB; 
	R_out(53)	<= R_in(53);
	R_out(54)	<= R_in(54)		XOR FB; 
	R_out(55)	<= R_in(55);
	R_out(56)	<= R_in(56)		XOR FB; 
	R_out(57)	<= R_in(57);
	R_out(58)	<= R_in(58)		XOR FB;   
	R_out(59)	<= R_in(59);
	R_out(60)	<= R_in(60)		XOR FB; 
	R_out(61)	<= R_in(61)		XOR FB;
	R_out(62)	<= R_in(62);
	R_out(63)	<= R_in(63)		XOR FB;
	R_out(64)	<= R_in(64)		XOR FB;   
	R_out(65)	<= R_in(65)		XOR FB;
	R_out(66)	<= R_in(66)		XOR FB; 
	R_out(67)	<= R_in(67)		XOR FB;
	R_out(68)	<= R_in(68); 
	R_out(69)	<= R_in(69);
	R_out(70)	<= R_in(70); 
	R_out(71)	<= R_in(71)		XOR FB;
	R_out(72)	<= R_in(72)		XOR FB;  
	R_out(73)	<= R_in(73);
	R_out(74)	<= R_in(74);
	R_out(75)	<= R_in(75);
	R_out(76)	<= R_in(76);
	R_out(77)	<= R_in(77);
	R_out(78)	<= R_in(78); 
	R_out(79)	<= R_in(79)		XOR FB;
	R_out(80)	<= R_in(80)		XOR FB; 
	R_out(81)	<= R_in(81)		XOR FB;
	R_out(82)	<= R_in(82)		XOR FB; 
	R_out(83)	<= R_in(83);
	R_out(84)	<= R_in(84); 
	R_out(85)	<= R_in(85);
	R_out(86)	<= R_in(86);
	R_out(87)	<= R_in(87)		XOR FB;  
	R_out(88)	<= R_in(88)		XOR FB; 
	R_out(89)	<= R_in(89)		XOR FB;  
	R_out(90)	<= R_in(90)		XOR FB; 
	R_out(91)	<= R_in(91)		XOR FB; 
	R_out(92)	<= R_in(92)		XOR FB; 
	R_out(93)	<= R_in(93);
	R_out(94)	<= R_in(94)		XOR FB; 
	R_out(95)	<= R_in(95)		XOR FB;
	R_out(96)	<= R_in(96)		XOR FB; 
	R_out(97)	<= R_in(97)		XOR FB;
	R_out(98)	<= R_in(98); 
	R_out(99)	<= R_in(99);	
		
	
END BEHAVIOR;
