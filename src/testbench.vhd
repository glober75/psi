--############################################
-- PSI - Processador Simples
-- Descrição: projeto de um processador didático 
-- Autor: Otávio Alcântara
-- Data: 23/03/2021
-- Revisão: 01
--############################################

library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;


architecture d of testbench is

component top is
port(clk, rst : in std_logic);
end component;

constant CLOCK_SIM_CYCLES : integer := 100;
signal clk, rst : std_logic;

begin

dut: top port map(clk, rst);

process
variable i : integer := 0;
begin
rst <='1';
clk <='0';
wait for 10 us;
rst<='0';
wait for 10 us;

for i in CLOCK_SIM_CYCLES downto 0 loop
  clk <='1';
  wait for 10 us;
  clk <= '0';
  wait for 10 us;
end loop;

end process;

end d;
