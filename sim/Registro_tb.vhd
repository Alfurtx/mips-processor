----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 01:11:56 PM
-- Design Name: 
-- Module Name: Registro_tb - Behavioral
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

entity Registro_tb is
end Registro_tb;

architecture Behavioral of Registro_tb is
    component Registro is
        generic ( SIZE : positive );
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               data_i : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
               data_o : out STD_LOGIC_VECTOR (SIZE-1 downto 0));
    end component;
    
    constant CLOCK_PERIOD : time := 10ns;
    
    signal clk : std_logic := '0';
    signal en : std_logic;
    signal rst : std_logic;
    signal din : std_logic_vector(31 downto 0);
    signal dout : std_logic_vector(31 downto 0);
    
begin

    clk <= not clk after CLOCK_PERIOD / 2;

    reg : Registro
    generic map( SIZE => 32 )
    port map(clk_i => clk,
             rst_i => rst,
             en_i => en,
             data_i => din,
             data_o => dout);
             
    process
    begin
        rst <= '1';
        wait for CLOCK_PERIOD * 2;
        assert dout = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
            
        rst <= '0';
        en <= '0';
        wait for CLOCK_PERIOD * 3;
        assert dout = x"00000000"
            report "ERROR dout /= ""00"""
            severity failure;
            
        rst <= '0';
        en <= '1';
        din <= x"FFFFFFFF";
        wait for CLOCK_PERIOD * 3;
        assert dout = x"FFFFFFFF"
            report "ERROR dout /= ""FF"""
            severity failure;
        
        report "DONE!!";
        wait; 
    end process;         

end Behavioral;
