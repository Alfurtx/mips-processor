----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 07:11:07 PM
-- Design Name: 
-- Module Name: Processor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Processor is
    port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           en_i : in STD_LOGIC;
           mem_addr_i : in STD_LOGIC_VECTOR (9 downto 0);
           mem_dout_o : out STD_LOGIC_VECTOR (31 downto 0);
           mem_en_i : in STD_LOGIC);
end Processor;

architecture Behavioral of Processor is

    constant DATA_SIZE : positive := 32;
    constant ADDRESS_SIZE : positive := 5;
    constant REG_SIZE : positive := 32;
    
    -- señales auxiliares
    signal pc_en : std_logic;
    signal pc_write_cond : std_logic;
    signal pc_write : std_logic;
    signal pc_data_ctrl : std_logic_vector(1 downto 0);
    signal alu_src2_ctrl : std_logic_vector(1 downto 0);
    signal alu_src1_ctrl : std_logic;
    signal alu_op : std_logic_vector(1 downto 0);
    signal reg_file_write_en : std_logic;
    signal reg_file_write_addr_ctrl : std_logic;
    signal ir_en : std_logic;
    signal irreg_en : std_logic;
    signal reg_file_write_data_ctrl : std_logic;
    signal mem_data_reg_en : std_logic;
    signal mem_write_en : std_logic;
    signal mdrreg_en : std_logic;
    signal mem_addr_ctrl : std_logic;
    signal pc : std_logic_vector(REG_SIZE-1 downto 0);
    signal alu_zero : std_logic;
    signal aluout : std_logic_vector(REG_SIZE-1 downto 0);
    signal mem_addra : std_logic_vector(REG_SIZE-1 downto 0);
    signal b : std_logic_vector(REG_SIZE-1 downto 0);
    signal a : std_logic_vector(REG_SIZE-1 downto 0);
    signal mem_data : std_logic_vector(DATA_SIZE-1 downto 0);
    signal instruction : std_logic_vector(REG_SIZE-1 downto 0);
    signal mdr : std_logic_vector(REG_SIZE-1 downto 0);
    signal alu_result : std_logic_vector(DATA_SIZE-1 downto 0);
    signal wreg : std_logic_vector(ADDRESS_SIZE-1 downto 0);
    signal wdata : std_logic_vector(DATA_SIZE-1 downto 0);
    signal alu_data1 : std_logic_vector(DATA_SIZE-1 downto 0);
    signal alu_data2 : std_logic_vector(DATA_SIZE-1 downto 0);
    signal reg_data1 : std_logic_vector(DATA_SIZE-1 downto 0);
    signal reg_data2 : std_logic_vector(DATA_SIZE-1 downto 0);
    signal sign_extend : std_logic_vector(DATA_SIZE-1 downto 0);
    signal sign_shifted : std_logic_vector(DATA_SIZE-1 downto 0);
    signal aluop : std_logic_vector ( 7 downto 0 );
    signal jump_address : std_logic_vector(REG_SIZE-1 downto 0);
    signal new_pc : std_logic_vector(REG_SIZE-1 downto 0);
    
    component blk_mem_gen_0
      port (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
      );
    end component;

    
    component Registro is
        generic ( SIZE : positive );
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               data_i : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
               data_o : out STD_LOGIC_VECTOR (SIZE-1 downto 0));
    end component;

    
    component ALU is
        generic ( PORT_DATA_SIZE : positive );
        port ( data1_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
               data2_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
               op_i : in STD_LOGIC_VECTOR (7 downto 0);
               zero_o : out STD_LOGIC;
               result_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0));
    end component;

    
    component ControlUnit is
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               op_i : in STD_LOGIC_VECTOR (5 downto 0);
               ir_en_o : out STD_LOGIC;
               pc_write_cond_o : out STD_LOGIC;
               pc_write_o : out STD_LOGIC;
               pc_data_ctrl_o : out STD_LOGIC_VECTOR (1 downto 0);
               alu_src2_ctrl_o : out STD_LOGIC_VECTOR (1 downto 0);
               alu_src1_ctrl_o : out STD_LOGIC;
               alu_op_o : out STD_LOGIC_VECTOR (1 downto 0);
               reg_file_write_en_o : out STD_LOGIC;
               reg_file_write_addr_ctrl_o : out STD_LOGIC;
               reg_file_write_data_ctrl_o : out STD_LOGIC;
               mem_data_reg_en_o : out STD_LOGIC;
               mem_write_en_o : out STD_LOGIC;
               mem_addr_ctrl_o : out STD_LOGIC);
    end component;
    
    component RegisterFile is
        generic ( PORT_ADDRESS_SIZE : positive;
                  PORT_DATA_SIZE : positive );
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in std_logic;
               write_en_i : in STD_LOGIC;
               readReg1_i : in STD_LOGIC_VECTOR (PORT_ADDRESS_SIZE-1 downto 0);
               readReg2_i : in STD_LOGIC_VECTOR (PORT_ADDRESS_SIZE-1 downto 0);
               writeReg_i : in STD_LOGIC_VECTOR (PORT_ADDRESS_SIZE-1 downto 0);
               writeData_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
               readData1_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
               readData2_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0));
    end component;
    
begin
    irreg_en <= ir_en and en_i;
    mdrreg_en <= mem_data_reg_en and en_i;
    pc_en <= ( ( pc_write_cond and alu_zero ) or pc_write ) and en_i;
    
    with mem_addr_ctrl select
        mem_addra <= pc when '0',
                     aluout when '1',
                     (others => '0') when others;
    
    with reg_file_write_addr_ctrl select
        wreg <= instruction(20 downto 16) when '0',
                instruction(15 downto 11) when '1',
                (others => '0') when others;
                
    with reg_file_write_data_ctrl select
        wdata <= aluout when '0',
                 mdr when '1',
                 (others => '0') when others;
    
    with alu_src1_ctrl select
        alu_data1 <= pc when '0',
                     a when '1',
                     (others => '0') when others;
    
    with alu_src2_ctrl select
        alu_data2 <= b when "00",
                     x"00000004" when "01",
                     sign_extend when "10",
                     sign_shifted when "11",
                     (others => '0') when others;
     
    sign_extend <= (31 downto 16 => instruction(15)) & instruction(15 downto 0);             
    sign_shifted <= sign_extend(29 downto 0) & "00";
    
    aluop <= alu_op & instruction(5 downto 0);
    
    jump_address <= pc(31 downto 28) & ( instruction(25 downto 0) & "00" );
    
    with pc_data_ctrl select
        new_pc <= alu_result when "00",
                        aluout when "01",
                        jump_address when "10",
                        (others => '0') when others;
                 
    memory : blk_mem_gen_0
      port map (
        clka => clk_i,
        ena => en_i,
        wea(0) => mem_write_en,
        addra => mem_addra(11 downto 2),
        dina => b,
        douta => mem_data,
        clkb => clk_i,
        enb => mem_en_i,
        web => "0",
        addrb => mem_addr_i,
        dinb => x"00000000",
        doutb => mem_dout_o
      );
  
    pcreg : Registro
    generic map ( SIZE => REG_SIZE )
    port map (clk_i => clk_i,
              rst_i => rst_i,
              en_i => pc_en,
              data_i => new_pc,
              data_o => pc);
    
    irreg : Registro
    generic map ( SIZE => REG_SIZE )
    port map (clk_i => clk_i,
              rst_i => rst_i,
              en_i => irreg_en,
              data_i => mem_data,
              data_o => instruction);
    
    mdrreg : Registro
    generic map ( SIZE => REG_SIZE )
    port map (clk_i => clk_i,
              rst_i => rst_i,
              en_i => mdrreg_en,
              data_i => mem_data,
              data_o => mdr);
    
    regfile : RegisterFile
    generic map ( PORT_ADDRESS_SIZE => ADDRESS_SIZE,
                  PORT_DATA_SIZE => DATA_SIZE)
    port map ( clk_i => clk_i,
               rst_i => rst_i,
               en_i => en_i,
               write_en_i => reg_file_write_en,
               readReg1_i => instruction(25 downto 21),
               readReg2_i => instruction(20 downto 16),
               writeReg_i => wreg,
               writeData_i => wdata,
               readData1_o => reg_data1,
               readData2_o => reg_data2);
    
    areg : Registro
    generic map ( SIZE => REG_SIZE )
    port map (clk_i => clk_i,
              rst_i => rst_i,
              en_i => en_i,
              data_i => reg_data1,
              data_o => a);
    
    breg : Registro
    generic map ( SIZE => REG_SIZE )
    port map (clk_i => clk_i,
              rst_i => rst_i,
              en_i => en_i,
              data_i => reg_data2,
              data_o => b);
    
    aluoutreg : Registro
    generic map ( SIZE => REG_SIZE )
    port map (clk_i => clk_i,
              rst_i => rst_i,
              en_i => en_i,
              data_i => alu_result,
              data_o => aluout);
    
    alu_uut : ALU
    generic map ( PORT_DATA_SIZE => DATA_SIZE )
    port map (data1_i => alu_data1,
              data2_i => alu_data2,
              op_i => aluop,
              zero_o => alu_zero,
              result_o => alu_result);
    
    control : ControlUnit
    port map ( clk_i => clk_i,
               rst_i => rst_i,
               en_i => en_i,
               op_i => instruction(31 downto 26),
               pc_write_cond_o => pc_write_cond,
               pc_write_o => pc_write,
               pc_data_ctrl_o => pc_data_ctrl,
               alu_src2_ctrl_o => alu_src2_ctrl,
               alu_src1_ctrl_o => alu_src1_ctrl,
               alu_op_o => alu_op,
               reg_file_write_en_o => reg_file_write_en,
               reg_file_write_addr_ctrl_o => reg_file_write_addr_ctrl,
               ir_en_o => ir_en,
               reg_file_write_data_ctrl_o => reg_file_write_data_ctrl,
               mem_data_reg_en_o => mem_data_reg_en,
               mem_write_en_o => mem_write_en,
               mem_addr_ctrl_o => mem_addr_ctrl);

end Behavioral;
