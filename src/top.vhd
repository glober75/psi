--############################################
-- PSI - Processador Simples
-- Descrição: projeto de um processador didático 
-- Autor: Otávio Alcântara
-- Data: 23/03/2021
-- Revisão: 01
--############################################

library ieee;
use ieee.std_logic_1164.all;

entity top is
port(clk, rst : in std_logic);
end top;


architecture d of top is

 --interface com a memória de dados
signal  data_mem_addr :  std_logic_vector(9 downto 0);
signal  data_mem_rd_wr : std_logic;
signal  data_mem_din :  std_logic_vector( 15 downto 0);
signal  data_mem_dout :  std_logic_vector( 15 downto 0);
--interface com a memória de instruções
signal  inst_mem_addr :  std_logic_vector(11 downto 0);
signal  inst_mem_data :  std_logic_vector(15 downto 0);

--
-- PSI
--
component psi is

port (
  clk, rst : in std_logic;
 --interface com a memória de dados
  data_mem_addr : out std_logic_vector(9 downto 0);
  data_mem_rd_wr : out std_logic;
  data_mem_din : out std_logic_vector( 15 downto 0);
  data_mem_dout : in std_logic_vector( 15 downto 0);
--interface com a memória de instruções
  inst_mem_addr : out std_logic_vector(11 downto 0);
  inst_mem_data : in std_logic_vector(15 downto 0)
);
end component;

--
-- memória de programa
--
component inst_mem is
port (

  addr : in std_logic_vector(11 downto 0);
  data : out std_logic_vector(15 downto 0)

);
end component;

--
-- memória de dados
--
component data_mem is

port (
  clk, rst : in std_logic;
  addr : in std_logic_vector(9 downto 0);
  rd_wr : in std_logic;
  data_in : in std_logic_vector( 15 downto 0);
  data_out : out std_logic_vector( 15 downto 0)
);
end component;

begin

--
-- instanciação dos componentes
--

processador: psi port map(clk, rst,data_mem_addr,data_mem_rd_wr, 
data_mem_din,data_mem_dout,inst_mem_addr,inst_mem_data );

memoria_dados: data_mem port map(clk, rst, data_mem_addr,data_mem_rd_wr, 
data_mem_din,data_mem_dout);

memoria_programa: inst_mem port map ( inst_mem_addr,inst_mem_data );

end d;
