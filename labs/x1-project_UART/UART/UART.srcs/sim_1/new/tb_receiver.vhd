library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity tb_receiver is
-- empty
end tb_receiver;

architecture testbench of tb_receiver is
    
    constant c_MAX               : natural := 10;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    -- Local signals
    signal sig_clk_100mhz : std_logic;
    signal sig_rst        : std_logic;
    signal sig_clk_baud   : std_logic;
    signal sig_baud_sw    : std_logic_vector(2 downto 0);
    signal sig_data0    : std_logic_vector(3 downto 0);
    signal sig_data1    : std_logic_vector(3 downto 0);
    signal sig_data2    : std_logic_vector(3 downto 0);
    signal sig_data3    : std_logic_vector(3 downto 0);
    signal sig_data4    : std_logic_vector(3 downto 0); 
                      
    signal sig_Rx_en : STD_LOGIC;
    signal sig_Rx_out : STD_LOGIC_VECTOR (7 downto 0);   
    signal sig_Rx_in : STD_LOGIC;
    signal sig_par_bit: STD_LOGIC;
    signal sig_par_bit_t : std_logic;
    signal sig_clk : std_logic;
    signal sig_stop_bit : std_logic;         

begin

    -- Connecting testbench signals with clk_baud entity
  -- (Unit Under Test)
  uut_ce : entity work.clk_baud    
    port map (
      clk => sig_clk_100mhz,
      rst => sig_rst,
      baud_sw => sig_baud_sw,
      data0 => sig_data0,
      data1 => sig_data1,
      data2 => sig_data2,
      data3 => sig_data3,
      data4 => sig_data4,
      clk_baud  => sig_clk_baud
    );
  uut_cf : entity work.receiver   
    port map (
      clk => sig_clk_100mhz,
      rst => sig_rst,
      Rx_en => sig_Rx_en,
      Rx_data => sig_Rx_in,      
      par_bit => sig_par_bit,
      par_bit_t => sig_par_bit_t,  
      clk_baud  => sig_clk_baud,
      led_bytes => sig_Rx_out
    );  

  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen : process is
  begin

    while now < 2000 ns loop             -- 75 periods of 100MHz clock

        sig_clk_100mhz <= '0';
        wait for c_CLK_100MHZ_PERIOD / 2;
        sig_clk_100mhz <= '1';
        wait for c_CLK_100MHZ_PERIOD / 2;         
        
    end loop;
    wait;                               -- Process is suspended forever

  end process p_clk_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_reset_gen : process is
  begin

    sig_rst <= '0';
    wait for 1000 ns;
    -- Reset activated
    sig_rst <= '1';
    wait for 153 ns;
    -- Reset deactivated
    sig_rst <= '0';
    wait;

  end process p_reset_gen;

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin            
        sig_baud_sw <= "001";
        
  end process p_stimulus;
    
end architecture testbench;