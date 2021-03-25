--############################################
-- PSI - Processador Simples
-- Descrição: projeto de um processador didático 
-- Autor: Otávio Alcântara
-- Data: 23/03/2021
-- Revisão: 01
--############################################
library ieee;
use ieee.std_logic_1164.all;

entity regbank is

port (
  clk, rst : in std_logic;
  addr_reg1, addr_reg2 : in std_logic_vector(1 downto 0);
  wr_en : in std_logic;
  data_wr : in std_logic_vector( 15 downto 0);
  data_r1, data_r2 : out std_logic_vector( 15 downto 0)
);
end regbank;

architecture simple of regbank is

type reg_file_type is array (3 downto 0) of std_logic_vector( 15 downto 0);
signal array_next, array_reg : reg_file_type;

begin

--
--Processo de atualização do banco de registradores
--
process(clk, rst)
variable i : integer;
begin

 if (rst='1') then
  for i in 3 downto 0 loop
    array_reg(i) <= (others=>'0');
  end loop;
 elsif (clk'event and clk='1') then
   for i in 3 downto 0 loop
     array_reg(i) <= array_next(i);
   end loop;
 end if;
end process;
--
-- leitura dos registradores
--
with addr_reg1 select
 data_r1 <= array_reg(0) when "00",
            array_reg(1) when "01",
            array_reg(2) when "10",
            array_reg(3) when others;

with addr_reg2 select
  data_r2 <= array_reg(0) when "00",
             array_reg(1) when "01",
             array_reg(2) when "10",
             array_reg(3) when others;
--
-- escrita dos registradores
--
process(addr_reg1, wr_en, data_wr)
variable i : integer;
begin
  for i in 3 downto 0 loop
    array_next(i) <= array_reg(i);
  end loop;
  if ( wr_en='1' ) then
    case (addr_reg1) is
       when "00" =>
         array_next(0) <= data_wr;
       when "01" =>
         array_next(1) <= data_wr;
       when "10" => 
         array_next(2) <= data_wr;
       when others =>
         array_next(3) <= data_wr;
       end case;
  end if;
end process;

end simple;
