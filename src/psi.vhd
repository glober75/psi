--############################################
-- PSI - Processador Simples
-- Descrição: projeto de um processador didático 
-- Autor: Otávio Alcântara
-- Data: 23/03/2021
-- Revisão: 01
--############################################


--##################################################################################################
--  Formato de Instruções
--  4 tipos de instruções: lógico/aritméticas, salto condicional, acesso a memória, salto incondicional
--
--
-- 15 14 13 12  11 10 09 08  07 06 05 04 03 02 01 00
--|1  0  0  0 ||RA   | RB  ||ULA OP  | NÃO USADO    | ADD, SUB, AND, OR, SLR, SRR, XNOR, NOT
--|0  0   0  1||RA   | RB  || DESLOCAMENTO   JEQ    | JEQ
--|0  0   1  1||RA   | RB  || DESLOCAMENTO   JEQ    | JNE
--|Opcode     ||RA   | RB  ||OFFSET                 | LD, STR 
--|O  0   0  0||RA   |  IMEDIATO                    | LDI
--|0  0   1  0|| DESLOCAMENTO JMP                   | JMP
--
--################################################################################################

--############################################
-- ADD R1,R2 -> R1 = R1+R2 // TIPO 1
-- JEQ R1,R2,OFFSET -> PC = PC + OFFSET<<1, SE R1=R2, SENAO PC <- PC + 2
-- JNE R1,R2,OFFSET -> PC = PC + OFFSET<<1, SE R1/=R2, SENAO PC <- PC + 2
-- LD R1,OFFSET(R2) -> R1 = MEMORIA[R2+OFFSET]
-- LDI R1, IMEDIATO -> R1 = IMEDIATO
-- STR R1, ENDERECO -> MEMORIA[ENDERECO] = R1
-- JMP OFFSET -> PC = PC + OFFSET<<1
--############################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--##############################################
--
--##############################################
entity psi is

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
end psi;

--##############################################
--
--##############################################

architecture default of psi is

constant MDATA_A_N_BITS : integer:=10;
constant MDATA_D_N_BITS : integer := 16;

constant MINST_A_N_BITS : integer := 12;
constant MINST_D_N_BITS : integer := 16;

--declaraçãodo registrador contador de programa
signal pc_next, pc_reg : std_logic_vector(MINST_A_N_BITS-1 downto 0);
--sinais usados para cálculo do valor que será armazenado em PC
signal pc_oper1, pc_oper2 : unsigned(MINST_A_N_BITS-1 downto 0);


--Sinais de inteface com o banco de registradores
constant REGS_DATA_BITS : integer := 16;
constant REGS_ADDR_BITS : integer := 2;

signal  wr_en :  std_logic;
signal  data_wr :  std_logic_vector( REGS_DATA_BITS-1 downto 0);
signal  data_r1, data_r2 :  std_logic_vector( REGS_DATA_BITS-1 downto 0);

--Sinais de interface com a ULA
constant ULA_WIDTH : integer := 16;
constant ULA_OP : integer := 3;

signal ula_oper : std_logic_vector(ULA_OP-1 downto 0);
signal ula_c :  std_logic_vector(ULA_WIDTH-1 downto 0);
signal zero :  std_logic;
signal data_ula_r1 :  std_logic_vector( REGS_DATA_BITS-1 downto 0);

--#############################################################
--Sinais e constantes relacionados a decoficação da instrução
--#############################################################

--opcode da instrução lógico-aritmética
constant la_opcode : std_logic_vector := "1000";
--opcode da instrução ldi
constant ldi_opcode : std_logic_vector := "0000";
--opcode da instrução store
constant store_opcode : std_logic_vector := "0101";
--opcode da instrução load
constant load_opcode : std_logic_vector := "0100";
-- indica se a instrução é um salto incondicional
constant jmp_opcode : std_logic_vector := "0110";
-- indica se a instrução é um salto condicional JEQ
constant jeq_opcode : std_logic_vector := "0001";
--indica se a instrução é um salto condicional JNE
constant jne_opcode : std_logic_vector := "0011";

--opcode inst_mem_data[15:12]
alias opcode : std_logic_vector( 3 downto 0 ) is inst_mem_data(MINST_D_N_BITS-1 downto MINST_D_N_BITS-4);
--ula operation inst_mem_data[14:12]
alias ula_opcode : std_logic_vector( 2 downto 0 ) is inst_mem_data(MINST_D_N_BITS-9 downto MINST_D_N_BITS-11);
--endereço do registrador A
alias reg_a_addr : std_logic_vector( 1 downto 0 ) is inst_mem_data(MINST_D_N_BITS-5 downto MINST_D_N_BITS-6);
--endereço do registrador B
alias reg_b_addr : std_logic_vector( 1 downto 0 ) is inst_mem_data(MINST_D_N_BITS-7 downto MINST_D_N_BITS-8);
--offset load and store
alias mem_offset_ld_str : std_logic_vector( 7 downto 0 ) is inst_mem_data(MINST_D_N_BITS-9 downto 0);
--sinal offset load store
alias sinal_offset_ld_str : std_logic is inst_mem_data(MINST_D_N_BITS-9);
--deslocamento memória jmp
alias mem_offset_jmp : std_logic_vector( 11 downto 0 ) is inst_mem_data(MINST_D_N_BITS-5 downto 0);
--deslocamento memória jeq
alias mem_offset_jeq : std_logic_vector( 7 downto 0 ) is inst_mem_data(MINST_D_N_BITS-9 downto 0);
--sinal do offset do jeq
alias sinal_offset_jeq : std_logic is inst_mem_data(MINST_D_N_BITS-9);
--indica o valo imediato da instrução ldi
alias immediate_ldi : std_logic_vector( 9 downto 0 ) is inst_mem_data(MINST_D_N_BITS-7 downto 0);
--indica o sinal do valor imediato da instrução ldi
alias sinal_imm_ldi : std_logic is inst_mem_data(MINST_D_N_BITS-7);

--####################################
--declaração dos componentes
--####################################

--banco de registradores
component regbank is

port (
  clk, rst : in std_logic;
  addr_reg1, addr_reg2 : in std_logic_vector(1 downto 0);
  wr_en : in std_logic;
  data_wr : in std_logic_vector( 15 downto 0);
  data_r1, data_r2 : out std_logic_vector( 15 downto 0)
);
end component;

--unidade lógico aritmética
component ula is
port(
 a, b : in std_logic_vector(15 downto 0);
 op : in std_logic_vector( 2 downto 0);
 c : out std_logic_vector(15 downto 0);
 zero : out std_logic
);
end component;

begin
--
--instanciando a ula
--
ulad: ula 
port map(a => data_ula_r1, b => data_r2, op => ula_oper, c => ula_c, zero => zero );

--
--definindo a operação e operandos feita pela ULA
--
ula_oper <= "001" when opcode=jne_opcode else --usa a ULA para fazer a subtração (001) na instrução jne, soma LD e STR
            "000" when opcode=load_opcode or opcode=store_opcode else ula_opcode; --caso contrário							  
							  --a operação vem codificada na própria instrução

data_ula_r1 <= "00000000"&mem_offset_ld_str when (opcode=load_opcode or opcode=store_opcode) and sinal_offset_ld_str = '0' else
               "11111111"&mem_offset_ld_str when (opcode=load_opcode or opcode=store_opcode) and sinal_offset_ld_str = '1' else
               data_r1;
--
--instanciando o banco de registradores
--
banco_reg: regbank 
port map(clk, rst, reg_a_addr, reg_b_addr, wr_en, data_wr, data_r1, data_r2  );

--
--registrador PC
--
process(clk, rst)
begin
if (rst='1')then
  pc_reg <= (others=>'0');
elsif (clk'event and clk='1' ) then
  pc_reg <= pc_next;
end if;
end process;

--
--endereçamento da memória de dados vem da saída da ULA (10 bits menos significativos)
--
data_mem_addr <= ula_c(MINST_D_N_BITS-7 downto 0);

--
--endereçamento da memória de programa
--
inst_mem_addr <= pc_reg; --
--
--estágio de armazenamento dos resultados instruções Lógico-Aritméticas, LDI e Load
--
data_wr <= ula_c when opcode=la_opcode else --salvar valor que vem da ULA
         "000000"&immediate_ldi when opcode=ldi_opcode and sinal_imm_ldi ='0'  else  --extensão de sinal, número positivo
         "111111"&immediate_ldi when opcode=ldi_opcode else data_mem_dout;  --extensão de sinal, número negativo

wr_en <= '1' when opcode=la_opcode or opcode=load_opcode or opcode=ldi_opcode else '0';

--
--controle da instrução store
--
data_mem_din <= data_r1;
--modo escrita apenas se instrução str
data_mem_rd_wr <= '1' when opcode = store_opcode else '0';

--
-- cálculo do próximo valor do PC
--
--as operações tem que ser feitas com números unsigned
pc_oper1 <= unsigned(pc_reg);
pc_oper2 <= unsigned(mem_offset_jmp) when opcode = jmp_opcode else --pula para o endereço vindo na instrução
           unsigned("0000"&mem_offset_jeq) when opcode = jeq_opcode and zero='1' and  sinal_offset_jeq='0' else --ext de sinal +
           unsigned("1111"&mem_offset_jeq) when opcode = jeq_opcode and zero='1' and  sinal_offset_jeq='1' else --ext de sinal -
           unsigned("0000"&mem_offset_jeq) when opcode = jne_opcode and zero='0' and  sinal_offset_jeq='0' else --ext de sinal +
           unsigned("1111"&mem_offset_jeq) when opcode = jne_opcode and zero='0' and  sinal_offset_jeq='1' else --ext de sinal -
           ("000000000001"); --incrementa o pc

pc_next <= std_logic_vector( pc_oper1 + pc_oper2);

end default;


