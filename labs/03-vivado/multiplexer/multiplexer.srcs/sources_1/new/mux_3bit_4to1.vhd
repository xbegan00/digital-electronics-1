------------------------------------------------------------
-- Copyright (c) 2023 Mojmir Began
-- Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_3bit_4to1 is
 port(
        a       : in  std_logic_vector(3 - 1 downto 0);
        b       : in  std_logic_vector(3 - 1 downto 0);
        c       : in  std_logic_vector(3 - 1 downto 0);
        d       : in  std_logic_vector(3 - 1 downto 0);-- COMPLETE THE ENTITY DECLARATION
        sel     : in  std_logic_vector(2 - 1 downto 0);
        f       : out std_logic_vector(3 - 1 downto 0)
    );
end mux_3bit_4to1;

architecture Behavioral of mux_3bit_4to1 is
begin
    f <=    a when (sel = "00") else
            b when (sel = "01") else
            c when (sel = "10") else
            d;                

end Behavioral;
