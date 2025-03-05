----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 01:11:56 PM
-- Design Name: 
-- Module Name: ControlUnit_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit_tb is
end ControlUnit_tb;

architecture Behavioral of ControlUnit_tb is
    component ControlUnit is
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               op_i : in STD_LOGIC_VECTOR (5 downto 0);
               pc_write_cond_o : out STD_LOGIC;
               pc_write_o : out STD_LOGIC;
               pc_data_ctrl_o : out STD_LOGIC_VECTOR (1 downto 0);
               alu_src2_ctrl_o : out STD_LOGIC_VECTOR (1 downto 0);
               alu_src1_ctrl_o : out STD_LOGIC;
               alu_op_o : out STD_LOGIC_VECTOR (1 downto 0);
               reg_file_write_en_o : out STD_LOGIC;
               reg_file_write_addr_ctrl_o : out STD_LOGIC;
               ir_en_o : out STD_LOGIC;
               reg_file_write_data_ctrl_o : out STD_LOGIC;
               mem_data_reg_en_o : out STD_LOGIC;
               mem_write_en_o : out STD_LOGIC;
               mem_addr_ctrl_o : out STD_LOGIC);
    end component;

    constant CLOCK_PERIOD : time := 10ns;

    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal en : std_logic;
    signal op : std_logic_vector(5 downto 0);
    signal pc_write_cond : std_logic;
    signal pc_write : std_logic;
    signal pc_data_ctrl : std_logic_vector(1 downto 0);
    signal alu_src2_ctrl : std_logic_vector(1 downto 0);
    signal alu_src1_ctrl : std_logic;
    signal alu_op : std_logic_vector(1 downto 0);
    signal reg_file_write_en : std_logic;
    signal reg_file_write_addr_ctrl : std_logic;
    signal ir_en : std_logic;
    signal reg_file_write_data_ctrl : std_logic;
    signal mem_data_reg_en : std_logic;
    signal mem_write_en : std_logic;
    signal mem_addr_ctrl : std_logic;
    signal outputs : std_logic_vector (15 downto 0);
begin
    clk <= not clk after CLOCK_PERIOD / 2;
    outputs <= (15 => ir_en,
                14 => pc_data_ctrl(1),
                13 => pc_data_ctrl(0),
                12 => pc_write_cond,
                11 => pc_write,
                10 => mem_addr_ctrl,
                9 => mem_data_reg_en,
                8 => mem_write_en, 
                7 => reg_file_write_addr_ctrl, 
                6 => reg_file_write_en, 
                5 => reg_file_write_data_ctrl, 
                4 => alu_op(1),
                3 => alu_op(0), 
                2 => alu_src1_ctrl, 
                1 => alu_src2_ctrl(1),
                0 => alu_src2_ctrl(0));
    cu : ControlUnit
    port map ( clk_i                         => clk,
               rst_i                         => rst,
               en_i                          => en,
               op_i                          => op,
               pc_write_cond_o               => pc_write_cond,
               pc_write_o                    => pc_write,
               pc_data_ctrl_o                => pc_data_ctrl,
               alu_src2_ctrl_o               => alu_src2_ctrl,
               alu_src1_ctrl_o               => alu_src1_ctrl,
               alu_op_o                      => alu_op,
               reg_file_write_en_o           => reg_file_write_en,
               reg_file_write_addr_ctrl_o    => reg_file_write_addr_ctrl,
               ir_en_o                       => ir_en,
               reg_file_write_data_ctrl_o    => reg_file_write_data_ctrl,
               mem_data_reg_en_o             => mem_data_reg_en,
               mem_write_en_o                => mem_write_en,
               mem_addr_ctrl_o               => mem_addr_ctrl
           );

    process
    begin
        rst <= '1';
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000000"
            report "ERROR"
            severity failure;
        
        -- LW test
        rst <= '0';
        en <= '1';
        op <= "100011";
        wait for CLOCK_PERIOD;
        assert outputs = "1000100000000001"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000011"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000110"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000010000000000"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000001000000000"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000001100000"
               report "ERROR"
               severity failure;
        wait for CLOCK_PERIOD;
           assert outputs = "0000000000000000"
              report "ERROR"
              severity failure;
              
        -- SW test
        rst <= '0';
        en <= '1';
        op <= "101011";
        wait for CLOCK_PERIOD;
        assert outputs = "1000100000000001"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000011"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000110"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000010100000000"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000000"
                report "ERROR"
                severity failure;
                
        -- ADDI test
        rst <= '0';
        en <= '1';
        op <= "001000";
        wait for CLOCK_PERIOD;
        assert outputs = "1000100000000001"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000011"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000110"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000001000000"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000000"
                report "ERROR"
                severity failure;

        -- BEQ test
        rst <= '0';
        en <= '1';
        op <= "000100";
        wait for CLOCK_PERIOD;
        assert outputs = "1000100000000001"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000011"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0011000000001100"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000000"
                report "ERROR"
                severity failure;

        -- R test
        rst <= '0';
        en <= '1';
        op <= "000000";
        wait for CLOCK_PERIOD;
        assert outputs = "1000100000000001"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000011"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000010100"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000011000000"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000000"
                report "ERROR"
                severity failure;
                
        -- J test
        rst <= '0';
        en <= '1';
        op <= "000010";
        wait for CLOCK_PERIOD;
        assert outputs = "1000100000000001"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
        assert outputs = "0000000000000011"
            report "ERROR"
            severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0100100000000000"
                report "ERROR"
                severity failure;
        wait for CLOCK_PERIOD;
            assert outputs = "0000000000000000"
                report "ERROR"
                severity failure;

        report "DONE!!!";
        wait;
    end process;

end Behavioral;
