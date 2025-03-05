----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 12:26:15 AM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

entity ControlUnit is
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
end ControlUnit;

architecture Behavioral of ControlUnit is

    type state is (st0, st1, st2, st3, st4, st5, st6, st7, st8, st9, st10, st11, st12);
    type operation is (LW, SW, ADDI, BEQ, R, J, UNDEFINED);
    signal current_state : state;
    signal opcode : operation;
    signal output : std_logic_vector (15 downto 0);

begin
    ir_en_o <= output(15);
    pc_data_ctrl_o(1) <= output(14);
    pc_data_ctrl_o(0) <= output(13);
    pc_write_cond_o <= output(12);
    pc_write_o <= output(11);
    mem_addr_ctrl_o <= output(10);
    mem_data_reg_en_o <= output(9);
    mem_write_en_o <= output(8);
    reg_file_write_addr_ctrl_o <= output(7);
    reg_file_write_en_o <= output(6); 
    reg_file_write_data_ctrl_o <= output(5);
    alu_op_o(1) <= output(4);
    alu_op_o(0) <= output(3);
    alu_src1_ctrl_o <= output(2);
    alu_src2_ctrl_o(1) <= output(1);
    alu_src2_ctrl_o(0) <= output(0);
    
    with op_i select
        opcode <= R when "000000",
                  ADDI when "001000",
                  BEQ when "000100",
                  J when "000010",
                  LW when "100011",
                  SW when "101011",
                  UNDEFINED when others;
                  
    transitions_p : process (rst_i, clk_i)
    begin
        if rst_i = '1' then
            current_state <= st0;
        elsif rising_edge(clk_i) and en_i = '1' then
            case current_state is
                when st0 => current_state <= st1;
                when st1 => current_state <= st2;
                when st2 =>
                    case opcode is
                        when LW | SW | ADDI => current_state <= st3;
                        when BEQ => current_state <= st9;
                        when R => current_state <= st10;
                        when J => current_state <= st12;
                        when others => current_state <= current_state;
                    end case;
                when st3 =>
                    case opcode is
                        when LW => current_state <= st4;
                        when SW => current_state <= st7;
                        when ADDI => current_state <= st8;
                        when others => current_state <= current_state;
                    end case;
                when st4 => current_state <= st5;
                when st5 => current_state <= st6;
                when st6 to st9 => current_state <= st0;
                when st10 => current_state <= st11;
                when st11 to st12 => current_state <= st0;
            end case;
        end if;
    end process;
    
    outputs_p : process (current_state)
    begin
        case current_state is
            when st0 => output <= "0000000000000000";
            when st1 => output <= "1000100000000001";
            when st2 => output <= "0000000000000011";
            when st3 => output <= "0000000000000110";
            when st4 => output <= "0000010000000000";
            when st5 => output <= "0000001000000000";
            when st6 => output <= "0000000001100000";
            when st7 => output <= "0000010100000000";
            when st8 => output <= "0000000001000000";
            when st9 => output <= "0011000000001100";
            when st10 => output <= "0000000000010100";
            when st11 => output <= "0000000011000000";
            when st12 => output <= "0100100000000000";
        end case; 
    end process;
    
end Behavioral;
