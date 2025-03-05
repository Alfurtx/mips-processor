----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 12:26:15 AM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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

entity RegisterFile is
    generic ( PORT_ADDRESS_SIZE : positive;
              PORT_DATA_SIZE : positive );
    port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           en_i : in std_logic;
           readReg1_i : in STD_LOGIC_VECTOR (PORT_ADDRESS_SIZE-1 downto 0);
           readReg2_i : in STD_LOGIC_VECTOR (PORT_ADDRESS_SIZE-1 downto 0);
           write_en_i : in STD_LOGIC;
           writeReg_i : in STD_LOGIC_VECTOR (PORT_ADDRESS_SIZE-1 downto 0);
           writeData_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
           readData1_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
           readData2_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
    type registers_t is array (0 to 2 ** PORT_ADDRESS_SIZE-1) of std_logic_vector (PORT_DATA_SIZE-1 downto 0);
    signal registers : registers_t;
begin
    readData1_o <= registers(to_integer(unsigned(readReg1_i)));
    readData2_o <= registers(to_integer(unsigned(readReg2_i)));
    
    process (clk_i, rst_i)    
    begin  
        if rst_i = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk_i) and en_i = '1' then
            if write_en_i = '1' then
                registers(to_integer(unsigned(writeReg_i))) <= writeData_i;
            end if;     
        end if;
    end process;

end Behavioral;
