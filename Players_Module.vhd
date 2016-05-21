library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity Players_Module is
port (
	i_Players_Clk	: in std_logic;
	i_Players_Reset	: in std_logic;

	i_Players_Data	: in std_logic_vector (2 downto 0);

	o_Players_Vram_Data : out std_logic_vector (2 downto 0);
	o_Players_Vram_Address : out std_logic_vector (15 downto 0);
	o_Players_Vram_WriteEn : out std_logic

	);
end Players_Module;

architecture Behavioral of Players_Module is

begin


end Behavioral;

