library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is --Transmitter
  generic (
        g_CNT_MAX : natural := 8   --! Default number of frame bits       
      );
  Port ( 
            rst : in STD_LOGIC;            
            Tx_en : in STD_LOGIC;
            Tx_data : in STD_LOGIC_VECTOR (7 downto 0);   
            Tx_out : out STD_LOGIC;
            par_bit: in STD_LOGIC;
            par_bit_t : std_logic;
            clk : std_logic;
            stop_bit : std_logic;          
            clk_baud : std_logic
        );
        
end transmitter;

architecture Behavioral of transmitter is
    
    signal sig_rst : std_logic; 
    signal parity : std_logic;    
    signal frame : std_logic_vector(7 downto 0) := "10000000";    
    signal cnt_clk_bit : natural := 0;    
    signal data_busy : std_logic := '0';
    shared variable i : integer:= 0;
       
begin
    P_Transmitting : process (clk, clk_baud) is
    begin
      if (rising_edge(clk)) then
        if (rising_edge(clk_baud)) then
            if (rst = '1') then
                sig_rst <= '1';              
            if (Tx_en = '1') then
                if (data_busy = '0') then
                        cnt_clk_bit <= 0;
                        parity <= Tx_data(0) xor Tx_data(1) xor Tx_data(2) xor Tx_data(3) xor Tx_data(4) xor Tx_data(5) xor Tx_data(6) xor Tx_data(7); 
                        frame <= Tx_data;
                        data_busy <= '1';
                        Tx_out <= '0';   -- start_bit
                        i:= 0;                 
                else
                    if (cnt_clk_bit < g_CNT_MAX) then
                        if(frame(cnt_clk_bit) = '1') then
                            i:= i + 1;
                        end if;
                        Tx_out <= frame(cnt_clk_bit);
                    elsif (cnt_clk_bit = g_CNT_MAX and par_bit = '1') then
                        if (par_bit_t = '1' and (i mod 2 = 0)) then
                            parity <= '1';
                        elsif (par_bit_t = '1' and (i mod 2 = 1)) then
                            parity <= '0';
                        elsif (par_bit_t = '0' and (i mod 2 = 0)) then 
                            parity <= '0';
                        elsif (par_bit_t = '0' and (i mod 2 = 1)) then
                            parity <= '1';                       
                        end if;
                        Tx_out <= parity;
                    else
                        Tx_out <= '1';
                        data_busy <= '0';
                        frame <= "10000000";                        
                    end if;
                    cnt_clk_bit <= cnt_clk_bit + 1;
                end if;
                end if;
              end if;
            end if;
          end if;              
      end process P_Transmitting;
                
                

end Behavioral;
