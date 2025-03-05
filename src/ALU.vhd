----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 12:26:15 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    generic ( PORT_DATA_SIZE : positive );
    port ( data1_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
           data2_i : in STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0);
           op_i : in STD_LOGIC_VECTOR (7 downto 0);
           zero_o : out STD_LOGIC;
           result_o : out STD_LOGIC_VECTOR (PORT_DATA_SIZE-1 downto 0));
end ALU;

architecture Behavioral of ALU is
    signal temp : std_logic_vector(PORT_DATA_SIZE-1 downto 0);
    constant zero_vector : std_logic_vector (PORT_DATA_SIZE-1 downto 0) := (others => '0');
begin

    temp <= std_logic_vector(signed(data1_i) + signed(data2_i)) when op_i(7 downto 6) = "00" else
            std_logic_vector(signed(data1_i) - signed(data2_i)) when op_i(7 downto 6) = "01" else
            std_logic_vector(signed(data1_i) + signed(data2_i)) when (op_i(7 downto 6) = "10" and op_i(5 downto 0) = "100000") else
            std_logic_vector(signed(data1_i) - signed(data2_i)) when (op_i(7 downto 6) = "10" and op_i(5 downto 0) = "100010") else
            data1_i and data2_i when (op_i(7 downto 6) = "10" and op_i(5 downto 0) = "100100") else
            data1_i or data2_i when (op_i(7 downto 6) = "10" and op_i(5 downto 0) = "100101") else
            (0 => '1', others => '0') when (op_i(7 downto 6) = "10" and op_i(5 downto 0) = "101010" and signed(data1_i) < signed(data2_i)) else
            -- (others => '0') when (op_i(7 downto 6) = "10") else
            (others => '0');
    zero_o <= '1' when temp = zero_vector else '0';
    result_o <= temp;
    
end Behavioral;
