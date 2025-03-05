----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 12:31:41 AM
-- Design Name: 
-- Module Name: Registro - Behavioral
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

entity Registro is
    generic ( SIZE : positive );
    port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           en_i : in STD_LOGIC;
           data_i : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
           data_o : out STD_LOGIC_VECTOR (SIZE-1 downto 0));
end Registro;

architecture Behavioral of Registro is
    signal data : std_logic_vector (SIZE-1 downto 0) := (others => '0');
begin
    data_o <= data;
    
    process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            data <= (others => '0');
        elsif rising_edge(clk_i) and en_i = '1' then
            data <= data_i;
        end if;
    end process;
       
end Behavioral;
