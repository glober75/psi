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

entity data_mem is

port (
  clk, rst : in std_logic;
  addr : in std_logic_vector(9 downto 0);
  rd_wr : in std_logic;
  data_in : in std_logic_vector( 15 downto 0);
  data_out : out std_logic_vector( 15 downto 0)
);
end data_mem;

architecture simple of data_mem is
constant MEM_SIZE : integer := 32;
type reg_file_type is array (MEM_SIZE-1  downto 0) of std_logic_vector( 15 downto 0);
signal memo : reg_file_type;
begin

process(addr,memo)
begin
  if ( to_integer(unsigned(addr)) < MEM_SIZE ) then
    data_out <= memo(to_integer(unsigned(addr)));
  else
    data_out <= (others=>'0');
  end if;
end process;

process(clk, rst)
begin
if (clk'event and clk='1') then
  if (rd_wr = '1') then
    memo(to_integer(unsigned(addr))) <= data_in;
  end if;
end if;
end process;
end simple;
