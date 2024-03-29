library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver is -- reciever
  generic (
        g_CNT_MAX : natural := 8;   --! Default number of frame bits  
        g_PARITY : natural := 9   --! Default number for parity       
      );
  Port (
        clk : in std_logic;
        clk_baud : in std_logic;
        rst : in std_logic;          
        par_bit_t : in std_logic;               
        par_bit : in std_logic;       
        Rx_data : in std_logic;        
        led_bytes : out std_logic_vector(7 downto 0);     
        parity : out std_logic;  
        in_parity : out std_logic;                      --calculated
        Rx_en : in std_logic                            --from input 
   );
end receiver;

architecture Behavioral of receiver is

    signal frame : std_logic_vector(7 downto 0) := (others => '0');    
    signal cnt_bits : integer range 0 to 9 := 0; 
    signal data_busy : std_logic := '0';    
    signal end_bit : std_logic := '0'; 
    signal sig_Rx_in : std_logic;      
    signal dat_led : natural := 0;
    shared variable i : integer:= 0;
    shared variable y : integer:= 0;

begin 
    inside : process(clk_baud) is
    begin
    if (rising_edge(clk_baud)) then 
        if (rst = '1') then
            cnt_bits <= 0;
            data_busy <= '0';
            frame <= "00000000";
            end_bit <= '0';
        else
        
            if (Rx_en = '1' and Rx_data = '0' and data_busy = '0') then
                    data_busy <= '1';                              
            elsif (Rx_en = '1' and data_busy = '1') then 
                            end_bit <= '0'; 
                            cnt_bits <= 0;               
                            if (cnt_bits < g_CNT_MAX) then
                                frame(cnt_bits) <= Rx_data;                            
                                cnt_bits <= cnt_bits + 1;
                            elsif (cnt_bits = g_CNT_MAX) then
                                in_parity <= Rx_data;
                                cnt_bits <= cnt_bits + 1;
                            elsif (cnt_bits = g_PARITY) then
                                end_bit <= '1';                            
                                cnt_bits <= 0;                                      
                                data_busy <= '0';
                            end if;     
                      end if;           
             end if;
         end if;                
     end process inside;
     
     --calculated parity
     P_parity : process(clk_baud) is
         begin
             if (rising_edge(clk_baud)) then
                    if (par_bit = '1') then
                        i:= 0;
                        y:= 0;
                        while i < g_CNT_MAX loop
                            if (frame(i) = '1') then
                                y:= y + 1;
                                i:= i + 1;
                            else
                                i:= i + 1;
                            end if;
                        end loop;
                        if (par_bit_t = '1' and (y mod 2 = 0)) then
                            parity <= '1';
                        elsif (par_bit_t = '1' and (y mod 2 = 1)) then
                            parity <= '0';
                        elsif (par_bit_t = '0' and (y mod 2 = 0)) then 
                            parity <= '0';
                        elsif (par_bit_t = '0' and (y mod 2 = 1)) then
                            parity <= '1';                       
                        end if;                    
                    end if;
                end if;
     end process P_parity;
     
     P_led : process(clk_baud) is
     begin
        if (rising_edge(clk_baud)) then
             if (rst = '1') then
                led_bytes <= "00000000";
             else
             
                 if (end_bit = '1') then
                   led_bytes <= frame; 
                 end if;
            end if;
        end if;
     end process P_led;
end Behavioral;
