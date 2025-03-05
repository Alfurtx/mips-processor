----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 11:55:56 PM
-- Design Name: 
-- Module Name: Processor_tb - Behavioral
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

entity Processor_tb is
end Processor_tb;

architecture Behavioral of Processor_tb is
    component Processor is
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               mem_addr_i : in STD_LOGIC_VECTOR (9 downto 0);
               mem_dout_o : out STD_LOGIC_VECTOR (31 downto 0);
               mem_en_i : in STD_LOGIC);
    end component;
    
    constant CLOCK_PERIOD : time := 10ns;
    
    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal en : std_logic;
    signal addr : std_logic_vector(9 downto 0);
    signal dout : std_logic_vector(31 downto 0);
    signal enb : std_logic;
    
begin

    clk <= not clk after CLOCK_PERIOD / 2;
    
    proc : Processor
    port map ( clk_i => clk,
               rst_i => rst,
               en_i => en,
               mem_addr_i => addr,
               mem_dout_o => dout,
               mem_en_i => enb);
    
    process
    begin
        rst <= '1';
        en <= '0';
        wait for CLOCK_PERIOD * 2;
        
        rst <= '0';
        en <= '1';
        enb <= '1';
        wait for CLOCK_PERIOD * 2;
        
        addr <= "0000000000";
        wait for CLOCK_PERIOD * 2;
        assert dout = x"20010fe0";
        
        wait;
        
--        addr <= "0000000000";
--        enb <= '1';
--        en <= '1';
--        rst <= '0';
--        wait for CLOCK_PERIOD * 2;
        
--        addr <= "1111111000";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000000"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111001";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000001"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111010";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000005"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111011";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000004"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111100";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000003"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111101";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000002"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111110";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000001"
--        report "ERROR"
--        severity failure;
        
--        addr <= "1111111111";
--        wait for CLOCK_PERIOD * 3;
--        assert dout = x"00000000"
--        report "ERROR"
--        severity failure;
        
        
        wait;
    end process;

end Behavioral;
