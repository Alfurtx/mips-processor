----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2024 01:09:00 AM
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;  
        en_i : in std_logic;     
        anode_o : out std_logic_vector(7 downto 0);
        segments_o : out std_logic_vector(7 downto 0)
    );
end Top;

architecture Behavioral of Top is
    component Processor is
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               mem_addr_i : in STD_LOGIC_VECTOR (9 downto 0);
               mem_dout_o : out STD_LOGIC_VECTOR (31 downto 0);
               mem_en_i : in STD_LOGIC);
    end component;
    component Converter is
        Port ( hex_i : in STD_LOGIC_VECTOR (3 downto 0);
               seg_o : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component DisplayController is
        port (
            clk_i : in std_logic;
            rst_i : in std_logic;
            en_i : in std_logic;
            addr_o : out std_logic_vector( 9 downto 0 );
            anode_o : out std_logic_vector( 7 downto 0 ));
    end component;
    component FrequencyDivider is
        generic ( N : positive );
        Port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               freq_o : out STD_LOGIC);
    end component;
    
    signal fproc : std_logic;
    signal fdisp : std_logic;
    signal addr : std_logic_vector( 9 downto 0 );
    signal data : STD_LOGIC_VECTOR (31 downto 0);
    signal seg : std_logic_vector( 7 downto 0 );
    signal proc_en : std_logic;
    signal disp_en : std_logic;
    
begin    
    
    proc_en <= fproc and en_i;
    disp_en <= fdisp and en_i;
    
    proc : Processor
    port map (
        clk_i => clk_i,
        rst_i => rst_i,
        en_i => proc_en,
        mem_addr_i => addr,
        mem_dout_o => data,
        -- mem_en_i => fdisp
        mem_en_i => disp_en
    );
    disp : DisplayController
    port map (
        clk_i => clk_i,
        rst_i => rst_i,
        en_i => disp_en,
        addr_o => addr,
        anode_o => anode_o
    );
    conv : Converter
    port map(
        hex_i => data(3 downto 0),
        seg_o => segments_o   
    );
    feqa : FrequencyDivider
    generic map ( N => 500000)
    port map (clk_i => clk_i,
              en_i => en_i,
              rst_i => rst_i,
              freq_o => fproc);
    feqb : FrequencyDivider
    generic map ( N => 12500)
    port map (clk_i => clk_i,
              en_i => en_i,
              rst_i => rst_i,
              freq_o => fdisp);

end Behavioral;
