--############################################
-- PSI - Processador Simples
-- Descrição: projeto de um processador didático 
-- Autor: Otávio Alcântara
-- Data: 23/03/2021
-- Revisão: 01
--
-- Component: ula
-- Descrição: implementação ingênua de uma ULA
-- com as operações SUM, SUB, AND, OR, NAND, NOR
-- XNOR, NOT
--
--
--############################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is

port(
 a, b : in std_logic_vector(15 downto 0);
 op : in std_logic_vector( 2 downto 0);
 c : out std_logic_vector(15 downto 0);
 zero : out std_logic
);
end ula;

architecture default of ula is
signal oper1, oper2, oper3 : signed(16 downto 0);
signal zeros : signed (15 downto 0);
begin

zeros <= (others=>'0');
oper1 <= signed('0'&a);
oper2 <= signed('0'&b);

with op select
oper3 <= oper1 + oper2 when "000",
         oper1 - oper2 when "001",
         oper1 and oper2 when "010",
         oper1 or oper2 when "011",
         oper1(15 downto 0) &'0' when "100", --deslocamento para esquerda
         '0'&oper1(16 downto 1) when "101", --deslocamento para direita
         oper1 xor oper2 when "110",
         not oper2 when others;

c <= std_logic_vector(oper3(15 downto 0));
zero <= '1' when oper3(15 downto 0)=zeros else '0';
end default;

