----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2024 01:07:38 PM
-- Design Name: 
-- Module Name: Memory_tb - Behavioral
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

entity Memory_tb is
end Memory_tb;

architecture Behavioral of Memory_tb is
    COMPONENT blk_mem_gen_0
      PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
      );
    END COMPONENT;
    
    signal ena : STD_LOGIC;
    signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addra : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal douta : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal dina : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    signal enb : STD_LOGIC;
    signal web : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addrb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal doutb : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal dinb : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    signal clk : std_logic := '0';
    
    constant PERIOD : time := 10ns;
    
begin
    clk <= not clk after PERIOD / 2;
    
    your_instance_name : blk_mem_gen_0
      PORT MAP (
        clka => clk,
        ena => ena,
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta,
        clkb => clk,
        enb => enb,
        web => web,
        addrb => addrb,
        dinb => dinb,
        doutb => doutb
      );
      
   process
   begin
   
    ena <= '1';
    wea(0) <= '0';
    addra <= "0000000000";
    enb <= '1';
    web(0) <= '0';
    addrb <= "0000000001";
    wait for PERIOD * 3;
    assert douta = x"20010fe0";
    assert doutb = x"20020007";
    
    ena <= '1';
    wea(0) <= '1';
    addra <= "0000000000";
    dina <= x"ffffffff";
    enb <= '1';
    web(0) <= '1';
    addrb <= "0000000001";
    dinb <= x"eeeeeeee";
    wait for PERIOD * 9;
    assert douta = x"ffffffff";
    assert doutb = x"eeeeeeee";
    
    report "DONE!!!";
    wait;
    
   end process;

end Behavioral;
