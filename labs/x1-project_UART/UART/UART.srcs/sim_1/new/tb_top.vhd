library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity tb_top is
 -- Entity of testbench is always empty  
end tb_top;
----------------------------------------------------------
-- Architecture body for testbench
----------------------------------------------------------
architecture testbench of tb_top is

  constant c_MAX               : natural := 10;
  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
  -- Local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_clk_100mhz_t : std_logic;
  
  signal sig_rst        : std_logic;
  signal sig_clk_baud   : std_logic;
  signal sig_baud_sw    : std_logic_vector(2 downto 0);
  signal sig_data0    : std_logic_vector(3 downto 0);
  signal sig_data1    : std_logic_vector(3 downto 0);
  signal sig_data2    : std_logic_vector(3 downto 0);
  signal sig_data3    : std_logic_vector(3 downto 0);
  signal sig_data4    : std_logic_vector(3 downto 0);
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
        sig_baud_sw <= "000";
        wait for 150 ns;
        sig_baud_sw <= "001";
        wait for 150 ns;
        sig_baud_sw <= "010";
        wait for 150 ns;
        sig_baud_sw <= "011";
        wait for 150 ns;
        sig_baud_sw <= "100";
        wait for 150 ns;
        sig_baud_sw <= "101";    
        wait for 150 ns;
        sig_baud_sw <= "110";
        wait for 150 ns;
        sig_baud_sw <= "111";
        wait for 150 ns;
  end process p_stimulus;
end architecture testbench;