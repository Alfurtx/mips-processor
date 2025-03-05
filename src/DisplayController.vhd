----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2024 09:41:31 PM
-- Design Name: 
-- Module Name: DisplayController - Behavioral
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

entity DisplayController is
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;
        en_i : in std_logic;
        addr_o : out std_logic_vector( 9 downto 0 );
        anode_o : out std_logic_vector( 7 downto 0 ));
end DisplayController;

architecture Behavioral of DisplayController is

    type anode is (an0, an1, an2, an3, an4, an5, an6, an7);
    signal display : anode;
    signal delay : anode;
    signal segments : std_logic_vector( 7 downto 0 ); 
    
    constant init_addr : integer range 1016 to 1023 := 1016;
    
begin

    with display select
        anode_o <= "01111111" when an0,
                   "10111111" when an1,
                   "11011111" when an2,
                   "11101111" when an3,
                   "11110111" when an4,
                   "11111011" when an5,
                   "11111101" when an6,
                   "11111110" when an7;

    address_p : process(display)
    begin
        case display is
            when an0 => addr_o <= std_logic_vector(to_unsigned(init_addr + 0, addr_o'length));
            when an1 => addr_o <= std_logic_vector(to_unsigned(init_addr + 1, addr_o'length));
            when an2 => addr_o <= std_logic_vector(to_unsigned(init_addr + 2, addr_o'length));
            when an3 => addr_o <= std_logic_vector(to_unsigned(init_addr + 3, addr_o'length));
            when an4 => addr_o <= std_logic_vector(to_unsigned(init_addr + 4, addr_o'length));
            when an5 => addr_o <= std_logic_vector(to_unsigned(init_addr + 5, addr_o'length));
            when an6 => addr_o <= std_logic_vector(to_unsigned(init_addr + 6, addr_o'length));
            when an7 => addr_o <= std_logic_vector(to_unsigned(init_addr + 7, addr_o'length));
        end case;
    end process;

    -- proceso para rotar entre los display que hay que activar
    display_p : process(rst_i, clk_i)
    begin
        if rst_i = '1' then 
            display <= an0;
            delay <= an0;
        elsif rising_edge(clk_i) and en_i = '1' then
            case display is
                when an0 => delay <= an1;
                when an1 => delay <= an2;
                when an2 => delay <= an3;
                when an3 => delay <= an4;
                when an4 => delay <= an5;
                when an5 => delay <= an6;
                when an6 => delay <= an7;
                when an7 => delay <= an0;
            end case;
            display <= delay;
        end if;
    end process;

end Behavioral;
