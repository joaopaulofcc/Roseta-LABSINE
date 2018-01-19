 -- Importa as bibliotecas de sistema.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Importa as bibliotecas de usuário.
USE WORK.ROSETA_Functions.ALL;

-- Início da declaração da entidade ROSETA_Clock.
ENTITY ROSETA_Clock IS
	
	PORT
	(
		SIGNAL clockIN    : IN STD_LOGIC;	-- Sinal de clock de entrada.
		SIGNAL clockOUT   : OUT STD_LOGIC	-- Sinal de clock de saída, i.e. pós processamento.
	);
	
END ROSETA_Clock;
-- Fim da declaração da entidade ROSETA_Clock.


-- Início da declaração da arquitetura da entidade ROSETA_Clock.
ARCHITECTURE BEHAVIOR OF ROSETA_Clock IS

	-- Sinal para conexão com barramento externos do circuito, evitando assim que flutuaçoes na entrada propaguem no circuito.
	SIGNAL SIG_clockOUT : STD_LOGIC := '0';

BEGIN

	-- Direciona os sinal do barramento externo para os respectivo sinal interno.
	clockOUT <= SIG_clockOUT;

	-- Process que permite que o circuito seja síncrono, é ativado por alteraçao de valores no sinal "clockIN", vindo do pino externo da FPGA.
	PROCESS(clockIN)
	
		VARIABLE count: NATURAL RANGE 0 TO CLOCK_FACTOR - 1;
		
	BEGIN
	
		IF CLOCK_FACTOR = 1 THEN
			
			SIG_clockOUT <= clockIN;
	
		-- Caso seja borda de subida do sinal "clockIN". Realiza a count, incrementando o contador até
		-- atingir o valor especificado em "CLOCK_FACTOR", aí então gera um pulso de clock para a saída.
		ELSIF RISING_EDGE(clockIN) THEN
		
			IF count = CLOCK_FACTOR / 2 - 1 THEN
			
				SIG_clockOUT <= NOT(SIG_clockOUT);
				count := count + 1;
				
			ELSIF count = CLOCK_FACTOR - 1 THEN
			
				SIG_clockOUT <= NOT(SIG_clockOUT);
				count := 0;
				
			ELSE
			
				count := count + 1;
				
			END IF;
			
		END IF;
		
	END PROCESS; 

END BEHAVIOR;
-- Fim da declaração da arquitetura da entidade ROSETA_Clock.