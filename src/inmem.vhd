--############################################
-- PSI - Processador Simples
-- Descrição: projeto de um processador didático 
-- Autor: Otávio Alcântara
-- Data: 23/03/2021
-- Revisão: 01
--############################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inst_mem is
port (

  addr : in std_logic_vector(11 downto 0);
  data : out std_logic_vector(15 downto 0)

);
end inst_mem;

architecture sim of inst_mem is
type reg_file_type is array (31 downto 0) of std_logic_vector( 15 downto 0);
signal memo : reg_file_type;
begin 

data <= memo(to_integer(unsigned(addr)));

memo(0) <= "0000000000000110"; --LDI R0, 6
memo(1) <= "0000010000000001"; --LDI R1, 1
memo(2) <= "1000000100000000"; --ADD R0, R1
memo(3) <= "1000000100000000"; --ADD R0, R1
memo(4) <= "1000000100100000"; --SUB R0, R1
memo(5) <= "1000000100100000"; --SUB R0, R1
memo(6) <= "0000110000000100"; --LDI R3, 4
memo(7) <= "0000100000000001"; --LDI R2, 1
memo(8) <= "1000111011000000"; --XOR R3, R2
memo(9) <= "0000000000000000"; --LDI R0, 0
memo(10) <= "1000001000000000"; --ADD R0, R2
memo(11) <= "1000001000000000"; --ADD R0, R2
memo(12) <= "1000001000000000"; --ADD R0, R2
memo(13) <= "0000010000000110"; --LDI R1, 6
memo(14) <= "0011000111111100"; --JNE R0, R1, -4
memo(15) <= "0101110000000000"; --STR R3, (0+R0)
memo(16) <= "0100110100000000"; --LD R3, (0+R1)
memo(17) <= "0101111000000000"; --STR R3, 0+R2
memo(18) <= "1000000100000000"; --ADD R0, R1
memo(19) <= "1000000100000000"; --ADD R0, R1
end architecture;
