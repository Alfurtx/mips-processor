----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 01:11:56 PM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
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

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

    component ALU is
        generic ( PORT_DATA_SIZE : positive );
        port ( data1_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
               data2_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
               op_i : in STD_LOGIC_VECTOR (7 downto 0);
               zero_o : out STD_LOGIC;
               result_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0));
    end component;
    
    constant CLOCK_PERIOD : time := 10ns;
    signal din1 : std_logic_vector (31 downto 0);
    signal din2 : std_logic_vector (31 downto 0);
    signal op : STD_LOGIC_VECTOR (7 downto 0);
    signal zero : std_logic;
    signal dout : std_logic_vector (31 downto 0);
    
begin    
    uut : ALU
    generic map ( PORT_DATA_SIZE => 32)
    port map (data1_i => din1,
              data2_i => din2,
              op_i => op,
              zero_o => zero,
              result_o => dout);
    process
    begin
        op <= "00000000";
        din1 <= x"00000001";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000003"
            report "ERROR dout /= ""3"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
            
        op <= "01000000";
        din1 <= x"00000001";
        din2 <= x"00000003";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"fffffffe"
            report "ERROR dout /= ""-2"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
            
        op <= "10100000";
        din1 <= x"00000001";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000003"
            report "ERROR dout /= ""3"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
            
        op <= "10100010";
        din1 <= x"00000001";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"ffffffff"
            report "ERROR dout /= ""-1"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
            
        op <= "10100100";
        din1 <= x"00000001";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000000"
            report "ERROR dout /= ""0"""
            severity failure;
        assert zero = '1'
            report "ERROR zero /= ""1"""
            severity failure;
        
        op <= "10100100";
        din1 <= x"00000002";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000002"
            report "ERROR dout /= ""2"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
            
        op <= "10100101";
        din1 <= x"00000001";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000003"
            report "ERROR dout /= ""3"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
        
        op <= "10101010";
        din1 <= x"00000001";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000001"
            report "ERROR dout /= ""1"""
            severity failure;
        assert zero = '0'
            report "ERROR zero /= ""0"""
            severity failure;
            
        op <= "10101010";
        din1 <= x"00000002";
        din2 <= x"00000002";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000000"
            report "ERROR dout /= ""0"""
            severity failure;
        assert zero = '1'
            report "ERROR zero /= ""1"""
            severity failure;
        
        report "DONE!!";
        wait;
    end process;

end Behavioral;
