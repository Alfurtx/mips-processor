----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2024 01:28:00 AM
-- Design Name: 
-- Module Name: FrequencyDivider_tb - Behavioral
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

entity FrequencyDivider_tb is
end FrequencyDivider_tb;

architecture Behavioral of FrequencyDivider_tb is
    component FrequencyDivider is
        generic ( N : positive );
        Port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               freq_o : out STD_LOGIC);
    end component;
    signal clk : std_logic := '0';
    signal en : std_logic;
    signal rst : std_logic;
    signal f : std_logic;
    constant PERIOD : time := 10ns;
begin

    clk <= not clk after PERIOD / 2;
    
    fq : FrequencyDivider
    generic map ( N => 4 )
    port map ( clk_i => clk,
               rst_i => rst,
               en_i => en,
               freq_o => f);
               
   process
   begin
    rst <= '1';
    en <= '0';
    wait for PERIOD *3;
    rst <= '0';
    en <= '1';
    wait for PERIOD *3;
    wait;
   end process;

end Behavioral;
