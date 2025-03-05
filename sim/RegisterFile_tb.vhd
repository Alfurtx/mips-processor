----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 01:10:17 PM
-- Design Name: 
-- Module Name: RegisterFile_tb - Behavioral
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

entity RegisterFile_tb is
end RegisterFile_tb;

architecture Behavioral of RegisterFile_tb is
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
    
    signal clk : std_logic := '0';
    signal en : std_logic ;
    signal rst : std_logic;
    signal wen : std_logic;
    signal reg1 : std_logic_vector(4 downto 0);
    signal reg2 : std_logic_vector(4 downto 0);
    signal wreg : std_logic_vector(4 downto 0);
    signal din : std_logic_vector(31 downto 0);
    signal dout1 : std_logic_vector(31 downto 0);
    signal dout2 : std_logic_vector(31 downto 0);
    
    constant CLOCK_PERIOD : time := 10ns;
    
begin
    clk <= not clk after CLOCK_PERIOD / 2;
    
    regfile : RegisterFile
    generic map (PORT_ADDRESS_SIZE => 5,
                 PORT_DATA_SIZE => 32)
    port map(clk_i => clk,
             rst_i => rst,
             en_i => en,
             write_en_i => wen,
             readReg1_i => reg1,
             readReg2_i => reg2,
             writeReg_i => wreg,
             writeData_i => din,
             readData1_o => dout1,
             readData2_o => dout2);
    process
    begin
        rst <= '1';
        en <= '0';
        reg1 <= "00001";
        reg2 <= "00010";
        wait for CLOCK_PERIOD * 2;
        assert dout1 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
        assert dout2 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
         
        rst <= '0';
        en <= '0';
        reg1 <= "00001";
        reg2 <= "00010";
        wait for CLOCK_PERIOD * 3;
        assert dout1 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
        assert dout2 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
             
        rst <= '0';
        en <= '1';
        reg1 <= "00001";
        reg2 <= "00010";
        wreg <= "00100";
        wen <= '1';
        din <= x"FFFFFFFF";
        wait for CLOCK_PERIOD * 3;
        assert dout1 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
        assert dout2 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
        
        rst <= '0';
        en <= '1';
        reg1 <= "00100";
        reg2 <= "00100";
        wen <= '0';
        wait for CLOCK_PERIOD * 3;
        assert dout1 = x"FFFFFFFF"
            report "ERROR dout /= ""FF"""
            severity failure;
        assert dout2 = x"FFFFFFFF"
            report "ERROR dout /= ""FF"""
            severity failure;
            
        rst <= '0';
        en <= '1';
        reg1 <= "11111";
        reg2 <= "00010";
        wreg <= "00010";
        wen <= '1';
        din <= x"EEEEEEEE";
        wait for CLOCK_PERIOD * 3;
        assert dout1 = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
        assert dout2 = x"EEEEEEEE"
            report "ERROR dout /= ""EE"""
            severity failure;
 
        report "DONE!!";
        wait; 
    end process;    
end Behavioral;
