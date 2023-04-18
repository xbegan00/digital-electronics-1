
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_register is
    Port ( clk_reg : in STD_LOGIC;
           rst_reg : in STD_LOGIC;           
           led_reg : out STD_LOGIC_VECTOR (7 downto 0));
end shift_register;

------------------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------------------
architecture behavioral of shift_register is

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
          clk => clk_reg,
          rst => rst_reg,
          -- WRITE YOUR CODE HERE
          q   => sig_ff0,
          d   => sig_data
      );

  d_ff_1 : entity work.d_ff_rst
      port map (
          clk => clk_reg,
          rst => rst_reg,
          -- WRITE YOUR CODE HERE
          q   => sig_ff1,
          d   => sig_ff0
      );
      
-- PUT OTHER TWO FLIP-FLOP INSTANCES HERE
 d_ff_2 : entity work.d_ff_rst
      port map (
          clk => clk_reg,
          rst => rst_reg,
          -- WRITE YOUR CODE HERE
          q   => sig_ff2,
          d   => sig_ff1     
      );

  d_ff_3 : entity work.d_ff_rst
      port map (
          clk => clk_reg,
          rst => rst_reg,
          -- WRITE YOUR CODE HERE
          q   => sig_ff3,
          d   => sig_ff2          
      );
   
        sig_data <= '1';           

end architecture behavioral;