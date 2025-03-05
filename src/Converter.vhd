----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2024 12:19:12 AM
-- Design Name: 
-- Module Name: Converter - Behavioral
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

entity Converter is
    Port ( hex_i : in STD_LOGIC_VECTOR (3 downto 0);
           seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end Converter;

architecture Behavioral of Converter is

begin

    with hex_i select
        seg_o <= "00000011" when "0000",
                 "10011111" when "0001",
                 "00100101" when "0010",
                 "00001101" when "0011",
                 "10011001" when "0100",
                 "01001001" when "0101",
                 "01000001" when "0110",
                 "00011111" when "0111",
                 "00000001" when "1000",
                 "00001001" when "1001",
                 
                 "00010001" when "1010",
                 "11000001" when "1011",
                 "01100011" when "1100",
                 "10000101" when "1101",
                 "01100001" when "1110",
                 "01110001" when "1111",
                 "00000001" when others;

end Behavioral;
