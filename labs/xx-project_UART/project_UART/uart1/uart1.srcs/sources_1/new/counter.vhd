library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (11 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC);           
end counter;

----------------------------------------------------------
-- Architecture body for top level
----------------------------------------------------------

architecture behavioral of counter is

  -- 4-bit counter @ 250 ms
  signal sig_en_250ms : std_logic;                    --! Clock enable signal for Counter0
  signal sig_en_10ms : std_logic;        
  signal sig_cnt_4bit : std_logic_vector(3 downto 0); --! Counter0
  signal sig_cnt_12bit : std_logic_vector(11 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
      generic map(
          g_MAX => 25000000
      )
      port map(
          -- WRITE YOUR CODE HERE
          clk => CLK100MHZ,
          rst => BTNC,
          ce  => sig_en_250ms
      );
  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity
  --------------------------------------------------------
  clk_en1 : entity work.clock_enable
      generic map(
          g_MAX => 1000000
      )
      port map(
          -- WRITE YOUR CODE HERE
          clk => CLK100MHZ,
          rst => BTNC,
          ce  => sig_en_10ms
      );

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity
  --------------------------------------------------------
  bin_cnt0 : entity work.cnt_up_down
     generic map(
          -- WRITE YOUR CODE HERE
          g_CNT_WIDTH => 4
      )
      port map(
          -- WRITE YOUR CODE HERE
          clk => CLK100MHZ,
          rst => BTNC,
          en  => sig_en_250ms,
          cnt_up => SW,
          cnt => sig_cnt_4bit
      );
      
  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity
  --------------------------------------------------------
  bin_cnt1 : entity work.cnt_up_down
     generic map(
          -- WRITE YOUR CODE HERE
          g_CNT_WIDTH => 12
      )
      port map(
          -- WRITE YOUR CODE HERE
          clk => CLK100MHZ,
          rst => BTNC,
          en  => sig_en_10ms,
          cnt_up => SW,
          cnt => sig_cnt_12bit
      );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity
  --------------------------------------------------------
  hex2seg : entity work.hex_7seg
      port map(
          blank  => BTNC,
          hex    => sig_cnt_4bit,
          seg(6) => CA,
          seg(5) => CB,
          seg(4) => CC,
          seg(3) => CD,
          seg(2) => CE,
          seg(1) => CF,
          seg(0) => CG
      );

  --------------------------------------------------------
  -- Other settings
  --------------------------------------------------------
  -- Connect one common anode to 3.3V
  AN <= b"1111_1110";
  LED(11 downto 0) <= sig_cnt_12bit;

end architecture behavioral;