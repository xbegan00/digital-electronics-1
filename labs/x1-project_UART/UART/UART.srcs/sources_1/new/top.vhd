library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is --TOP of Program
Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           LED : in STD_LOGIC_VECTOR (15 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           JA : out STD_LOGIC; --TX
           JB : out STD_LOGIC; --RX
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNL : in STD_LOGIC
           );
end top;

architecture Behavioral of top is
  signal sig_clk       : std_logic;
  signal sig_clk_baud  : std_logic;
  signal sig_rst       : std_logic;
  signal sig_bit_t       : std_logic;
  signal sig_data0     : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data1      : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data2       : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data3       : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data4       : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data5       : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data6       : STD_LOGIC_VECTOR (3 downto 0);
  signal sig_data7       : STD_LOGIC_VECTOR (3 downto 0); 
  signal sig_frame_width     : STD_LOGIC_VECTOR (3 downto 0); 
  signal sig_en_250ms : std_logic;
  
begin

    clk_baud : entity work.clk_baud     
        port map(          
          clk => CLK100MHZ,
          rst => BTNC,
          baud_sw  => SW(15 downto 13),
          clk_baud  => sig_clk_baud,
          data0 => sig_data0,
          data1 => sig_data1,
          data2 => sig_data2,
          data3 => sig_data3,
          data4 => sig_data4
        );
    display : entity work.driver_7seg_8digits
         port map( 
            clk => CLK100MHZ,
            rst => BTNC,
            data0 => sig_data0,
            data1 => sig_data1,
            data2 => sig_data2,
            data3 => sig_data3,
            data4 => sig_data4,
            data5 => sig_data5,
            data6 => sig_data6,
            data7 => sig_data7,
            dp_vect => "11110111",
            dp => DP,  
            dig => AN,          
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG    
         );
    trasnmitter : entity work.transmitter 
         generic map(
          g_CNT_MAX => 8         
         )
         port map( 
            rst => BTNC,
            Tx_data => SW(7 downto 0),              --always 8bits
            --par_bit_t => sig_bit_t,                 --type of parity (even, odd)
            --par_bit => SW(11),                      --add par bit to packet
            clk_baud => sig_clk_baud,               --clk signal from baud
            Tx_en => SW(10),                        --start or stop transmitt
            --stop_bit => SW(12),                    --1 or 2 stop bits
            Tx_out => JA                      -- completed packet to send               
         );     
     clk_en1 : entity work.clock_enable
         generic map(
          g_MAX => 25000000          
         )
         port map( 
            rst => BTNC,
            clk => CLK100MHZ,
            ce  => sig_en_250ms
         ); 
     p_settings : process (CLK100MHZ) is --options with buttons
     begin
     
        if (rising_edge(CLK100MHZ)) then
            sig_bit_t <= '0';
            sig_data5 <= "0000";
            sig_data7 <= "1001";
            if (SW(12) = '1') then
                sig_data6 <= "0010";
            elsif (SW(12) = '0') then
                sig_data6 <= "0001";
            end if;
            if (SW(11) = '1') then
                sig_data5 <= "0001";
            elsif (SW(12) = '0') then
                sig_data5 <= "0000";
            end if;
            if (BTNC = '0') then
                if (BTNU = '1') then
                    sig_bit_t <= '1';
                end if;
                if (BTND = '1') then
                    sig_bit_t <= '0';
                end if;
                if (BTNR = '1') then
                    sig_bit_t <= '1';
                end if;
                if (BTNL = '1') then
                    sig_bit_t <= '0';
                end if;
            end if;
        end if;
     end process p_settings;
    --XA_N <= '0';
end Behavioral;
