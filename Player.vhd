library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Player is

port (
	i_P1_Clk	: in std_logic;
	i_P1_Hit	: in std_logic;
	i_P1_Card_Drawn	: in std_logic_vector (5 downto 0);
	i_P1_Found			: in std_logic;
	i_P1_Turn			: in std_logic_vector(1 downto 0);
	i_P1_Reset			: in std_logic;

	i_Cuori_Data	: in std_logic_vector (2 downto 0);
	o_Cuori_Address	: out std_logic_vector (9 downto 0);

	i_Quadri_Data	: in std_logic_vector (2 downto 0);
	o_Quadri_Address	: out std_logic_vector (9 downto 0);

	i_Picche_Data	: in std_logic_vector (2 downto 0);
	o_Picche_Address	: out std_logic_vector (9 downto 0);

	i_Fiori_Data	: in std_logic_vector (2 downto 0);
	o_Fiori_Address	: out std_logic_vector (9 downto 0);

	i_Asso_Data	: in std_logic_vector (2 downto 0);
	o_Asso_Address	: out std_logic_vector (7 downto 0);

	i_Due_Data	: in std_logic_vector (2 downto 0);
	o_Due_Address	: out std_logic_vector (7 downto 0);
	
	i_Tre_Data	: in std_logic_vector (2 downto 0);
	o_Tre_Address	: out std_logic_vector (7 downto 0);

	i_Quattro_Data	: in std_logic_vector (2 downto 0);
	o_Quattro_Address	: out std_logic_vector (7 downto 0);

	i_Cinque_Data	: in std_logic_vector (2 downto 0);
	o_Cinque_Address	: out std_logic_vector (7 downto 0);

	i_Sei_Data	: in std_logic_vector (2 downto 0);
	o_Sei_Address	: out std_logic_vector (7 downto 0);

	i_Sette_Data	: in std_logic_vector (2 downto 0);
	o_Sette_Address	: out std_logic_vector (7 downto 0);

	i_Otto_Data	: in std_logic_vector (2 downto 0);
	o_Otto_Address	: out std_logic_vector (7 downto 0);

	i_Nove_Data	: in std_logic_vector (2 downto 0);
	o_Nove_Address	: out std_logic_vector (7 downto 0);

	i_Dieci_Data	: in std_logic_vector (2 downto 0);
	o_Dieci_Address	: out std_logic_vector (7 downto 0);

	i_Jack_Data	: in std_logic_vector (2 downto 0);
	o_Jack_Address	: out std_logic_vector (7 downto 0);

	i_Queen_Data	: in std_logic_vector (2 downto 0);
	o_Queen_Address	: out std_logic_vector (7 downto 0);

	i_King_Data	: in std_logic_vector (2 downto 0);
	o_King_Address	: out std_logic_vector (7 downto 0);

	i_CardFront_Data : in std_logic_vector (2 downto 0);
	o_CardFront_Address	 : out std_logic_vector (12 downto 0);
	
	i_CardBack_Data : in std_logic_vector (2 downto 0);
	o_CardBack_Address	 : out std_logic_vector (12 downto 0);

	o_Vram_Data : out std_logic_vector (2 downto 0);
	o_Vram_Address : out std_logic_vector (15 downto 0);
	o_Vram_WriteEn : out std_logic
	);

end Player;

architecture Behavioral of MemoryTester is

	signal r_Memory_Card : array (4 downto 0) of std_logic_vector(5 downto 0);
	signal r_Number_Card : integer range 0 to 5;
	signal r_Current_Sum : integer range 0 to 31;
	
	signal r_HPOS	: integer range 0 to 67;
	signal r_VPOS	: integer range 0 to 100;

	signal r_Counter_card	: integer range 0 to 6700;
	signal r_Counter_seme	: integer range 0 to 1024;
	signal r_Counter_numb	: integer range 0 to 256;

	signal r_Write_Flag	: std_logic;
	signal r_Card_Flag	: std_logic;

begin

	process(i_reset, i_clk)

	begin

		if (rising_edge(i_clk)) then

			if (i_reset = '1') then
				r_Number_Card <= 0;
				r_Memory_Card <= (others => (others => '0'));
			else
				if (i_turn = "01") then
					if (i_found = '1') then
						--inizializzazione per la stampa
						r_HPOS <= 67;
						r_VPOS <= 100;

						r_Counter_card <= 6700;
						r_Counter_seme <= 1024;
						r_Counter_numb <= 256;

						r_Write_Flag <= '1';
						r_Card_Flag <= '1';
						r_Seme_Flag <= '1';
						r_Numb_Flag <= '1';
						--fine inizializzazione
						r_Memory_Card(r_Number_Card) <= i_P1_Card_Drawn;
						r_Current_Sum <= r_Current_Sum + to_integer(to_unsigned(r_Memory_Card(r_Number_Card)(3 downto 0)));

					end if;
					if (r_Write_Flag = '1') then
						--cicli per determinare gli indirizzi 
						if (r_HPOS = 67 and r_VPOS = 100 and r_Card_Flag = '1') then
							r_HPOS <= 0;
							r_VPOS <= 0;
						elsif (r_HPOS < 66) then
							r_HPOS <= r_HPOS + 1;
						elsif (r_HPOS = 66) then
							r_HPOS <= 0;
							if (r_VPOS < 99) then
								r_VPOS <= r_VPOS + 1;
							elsif (r_VPOS = 99) then
								r_HPOS <= 0;
								r_VPOS <= 0;
								r_Write_Flag <= '0';
								r_Number_Card <= r_Number_Card + 1;
							end if;																						
						end if;

						if (r_Counter_card < 6699) then
							r_Counter_card <= r_Counter_card + 1;
						else
							r_Counter_card <= 0;
						end if;
							--CONTROLLO FRONT O BACK		
						o_CardFront_Address <= std_logic_vector(to_unsigned(r_Counter_card, 13));
						o_Vram_Address <= std_logic_vector(to_unsigned(r_VPOS+5, 8)) & std_logic_vector(to_unsigned(r_HPOS+5, 8));
						if (r_HPOS >= 6 and r_HPOS < 22) and (r_VPOS >= 6 and r_VPOS < 22)
							if (r_Counter_numb < 255) then
								r_Counter_numb <= r_Counter_numb + 1;
							else
								r_Counter_numb <= 0;
							end if;
							--fare il controllo del numero
								case r_Memory_Card(r_Number_Card)(3 downto 0) is
									when "0001" then 
										o_Asso_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Asso_Data;
									when "0010" then 
										o_Due_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Due_Data;
									when "0011" then 
										o_Tre_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Tre_Data;
									when "0100" then 
										o_Quattro_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Quattro_Data;
									when "0101" then 
										o_Cinque_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Cinque_Data;
									when "0110" then 
										o_Sei_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Sei_Data;
									when "0111" then 
										o_Sette_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Sette_Data;
									when "1000" then 
										o_Otto_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Otto_Data;
									when "1001" then 
										o_Nove_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Nove_Data;
									when "1010" then 
										o_Dieci_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Dieci_Data;
									when "1011" then 
										o_Jack_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Jack_Data;
									when "1100" then
										o_Queen_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_Queen_Data;
									when "1101" then 
										o_King_Address <= std_logic_vector(to_unsigned(r_Counter_numb));
										o_Vram_Data <= i_King_Data;
								end case;
						elsif (r_HPOS >= 23 and r_HPOS < 55) and (r_VPOS >= 23 and r_VPOS < 55)
							if (r_Counter_seme < 1023) then
								r_Counter_seme <= r_Counter_seme + 1;
							else
								r_Counter_seme <= 0;
							end if;
							--fare il controllo del seme
								case r_Memory_Card(r_Number_Card)(5 downto 4) is
									when "00" then
										o_Cuori_Address <= std_logic_vector(to_unsigned(r_Counter_seme));
										o_Vram_Data <= i_Cuori_Data;
									when "01" then
										o_Quadri_Address <= std_logic_vector(to_unsigned(r_Counter_seme));
										o_Vram_Data <= i_Quadri_Data;
									when "10" then
										o_Fiori_Address <= std_logic_vector(to_unsigned(r_Counter_seme));
										o_Vram_Data <= i_Fiori_Data;
									when "11" then
										o_Picche_Address <= std_logic_vector(to_unsigned(r_Counter_seme));
										o_Vram_Data <= i_Picche_Data;
								end case;
						else
						o_Vram_Data <= i_CardFront_Data;
						end if;
					end if;
				end if;
			end if;

		end if;

	end process;
end Behavioral;

