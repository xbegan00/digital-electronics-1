library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity tb_transmitter is
-- empty
end tb_transmitter;

architecture testbench of tb_transmitter is

    --constant c_MAX               : natural := 10;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    -- Local signals
    signal sig_clk_100mhz : std_logic;
    signal sig_rst        : std_logic;
    signal sig_clk_baud   : std_logic;    
    signal sig_Tx_en : STD_LOGIC;
    signal sig_Tx_data : STD_LOGIC_VECTOR (7 downto 0);   
    signal sig_Tx_out : STD_LOGIC;
    signal sig_par_bit: STD_LOGIC;
    signal sig_par_bit_t : std_logic;    
    signal sig_stop_bit : std_logic;          
        
begin
    
  -- Connecting testbench signals with clk_baud entity
  -- (Unit Under Test)
 
  uut_cf : entity work.transmitter   
    port map (
      clk => sig_clk_100mhz,
      rst => sig_rst,
      Tx_en => sig_Tx_en,
      Tx_data => sig_Tx_data,  
      Tx_out => sig_Tx_out,
      par_bit => sig_par_bit,
      par_bit_t => sig_par_bit_t,        
      stop_bit => sig_stop_bit,    
      clk_baud  => sig_clk_baud
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
    
  p_stimulus_t : process is
  begin  
        sig_Tx_en <= '0';                    
        sig_Tx_data <= "10010010";
        sig_par_bit <= '1';
        sig_par_bit_t <= '0';
        sig_stop_bit <= '0';  
        wait for 150ns; 
        sig_Tx_en <= '1';                    
        sig_Tx_data <= "10010010";
        sig_par_bit <= '1';
        sig_par_bit_t <= '0';
        sig_stop_bit <= '0'; 
        wait;       
  end process p_stimulus_t;
end architecture testbench;
