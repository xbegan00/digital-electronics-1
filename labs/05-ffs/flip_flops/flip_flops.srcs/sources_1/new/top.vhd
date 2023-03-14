
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (0 downto 0);
           LED : out STD_LOGIC_VECTOR (3 downto 0));
end top;

------------------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------------------
architecture behavioral of top is

  -- Internal signals between flip-flops
  signal sig_ff0 : std_logic;
  signal sig_ff1 : std_logic;
  signal sig_ff2 : std_logic;
  signal sig_ff3 : std_logic;

  -- WRITE YOUR CODE HERE
  signal sig_data : std_logic;
  
  

begin

  --------------------------------------------------------------------
  -- Four instances (copies) of D-type FF entity
  d_ff_0 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          -- WRITE YOUR CODE HERE
          q   => sig_ff0,
          d   => sig_data
      );

  d_ff_1 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          -- WRITE YOUR CODE HERE
          q   => sig_ff1,
          d   => sig_data
      );
      
-- PUT OTHER TWO FLIP-FLOP INSTANCES HERE
 d_ff_2 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          -- WRITE YOUR CODE HERE
          q   => sig_ff2,
          d   => sig_data     
      );

  d_ff_3 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          -- WRITE YOUR CODE HERE
          q   => sig_ff3,
          d   => sig_data          
      );
   
  -- Display input value on LEDs
  
      LED(0) <= sig_ff0;  
      LED(1) <= sig_ff1;
      LED(2) <= sig_ff2;
      LED(3) <= sig_ff3;  
      sig_data <= '1' when (SW(0) = '1') else
                '0';           

end architecture behavioral;
