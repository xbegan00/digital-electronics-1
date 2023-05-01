library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity tb_receiver is
-- empty
end tb_receiver;

architecture testbench of tb_receiver is
    
    --constant c_MAX               : natural := 10;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    -- Local signals
    signal sig_clk_100mhz : std_logic;
    signal sig_rst        : std_logic;
    signal sig_clk_baud   : std_logic;
    signal sig_Rx_en : STD_LOGIC;
    signal sig_Rx_out : STD_LOGIC_VECTOR (7 downto 0);   
    signal sig_Rx_in : STD_LOGIC;
    signal sig_par_bit: STD_LOGIC;
    signal sig_par_bit_t : std_logic;
    signal sig_in_parity : std_logic; 
    signal sig_parity : std_logic;          

begin

   -- Connecting testbench signals with clk_baud entity
  -- (Unit Under Test)
 
  uut_cf : entity work.receiver
    port map (
      clk => sig_clk_100mhz,
      rst => sig_rst,
      Rx_en => sig_Rx_en,
      Rx_data => sig_Rx_in,  
      led_bytes => sig_Rx_out,
      par_bit => sig_par_bit,
      par_bit_t => sig_par_bit_t,
      clk_baud  => sig_clk_baud,
      in_parity => sig_in_parity,
      parity => sig_parity
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
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen_baud : process is
  begin

    while now < 2000 ns loop             -- 75 periods of 100MHz clock

        sig_clk_baud <= '0';
        wait for c_CLK_100MHZ_PERIOD / 1;
        sig_clk_baud <= '1';
        wait for c_CLK_100MHZ_PERIOD / 1;         
        
    end loop;
    wait;                               -- Process is suspended forever

  end process p_clk_gen_baud;

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
    
  p_stimulus_rx : process is
  begin  
        --start bit 0, data 10010101, parity 1, stop bit 1
        sig_Rx_in <= '1';
        wait for 25ns;
        while now < 2000 ns loop        
        --1._b start
        sig_Rx_in <= '0';
        wait for 20ns;
        --2._b frame
        sig_Rx_in <= '1';
        wait for 20ns;
        --3._b
        sig_Rx_in <= '0';
        wait for 20ns;
        --4._b
        sig_Rx_in <= '0';
        wait for 20ns;
        --5._b
        sig_Rx_in <= '1';
        wait for 20ns;
        --6._b
        sig_Rx_in <= '0';
        wait for 20ns;
        --7._b
        sig_Rx_in <= '1';
        wait for 20ns;
        --8._b 
        sig_Rx_in <= '0';
        wait for 20ns;
        --9._b frame
        sig_Rx_in <= '1';
        wait for 20ns;
        --10._b parity
        sig_Rx_in <= '0';
        wait for 20ns;
        --11._b stop
        sig_Rx_in <= '1';
        wait for 20ns;   
        end loop;                           
  end process p_stimulus_rx;
  
  p_stimulus_r : process is
  begin                  
        sig_Rx_en <= '1';  
        sig_par_bit <= '1';
        sig_par_bit_t <= '0';
        wait;       
  end process p_stimulus_r;
    
end architecture testbench;