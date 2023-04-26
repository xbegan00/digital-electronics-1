library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nex_Reciever is -- transmitter
  Port ( 
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            
            rx_tx_switch : in STD_LOGIC;
            
            start_bit : in STD_LOGIC;
            data_in_sw : in STD_LOGIC_VECTOR (7 downto 0);
            
            baud_switches : in STD_LOGIC_VECTOR (2 downto 0);
            
            one_byte : in STD_LOGIC;
            
            byte_out : out STD_LOGIC
            
            -- seg : out STD_LOGIC_VECTOR(6 downto 0);
            
            -- led_bit_trigger : out STD_LOGIC_VECTOR (7 downto 0);
            -- led_baud_trigger : out STD_LOGIC_VECTOR (2 downto 0)
        );
        
end Nex_Reciever;

architecture Behavioral of Nex_Reciever is

    signal sig_baud_enable : std_logic;
    -- signal sig_hex : std_logic;
    signal parity : std_logic;
    
    signal d_byte : std_logic_vector(7 downto 0) := "10000000";
    
    signal cnt_clk_bit : natural := 0;
    
    signal data_busy : std_logic := '0';
    
    signal onebyte   : std_logic := '0';

begin

    baud_en0 : entity work.baud
        port map (
            clk => clk,
            rst => rst,
            clk_baud => sig_baud_enable,
            baud_sw => baud_switches
            );


    N_Reciever : process (clk) is
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                onebyte <= '0';
                -- sig_hex <= '0';
                -- led_bit_trigger <= "11111111";
                
            elsif (sig_baud_enable = '1') then
            
                if (one_byte = '0') then
                    onebyte <= '0';
                    end if;       
                        
                if (rx_tx_switch = '1' and onebyte = '0') then
                
                    if (data_busy = '0') then
                        
                        if (start_bit = '0') then
                            cnt_clk_bit <= 0;
                            parity <= data_in_sw(0) xor data_in_sw(1) xor data_in_sw(2) xor data_in_sw(3) xor data_in_sw(4) xor data_in_sw(5) xor data_in_sw(6) xor data_in_sw(7); 
                            d_byte <= data_in_sw;
                            data_busy <= '1';
                            byte_out <= '0';
                            
                        end if;
                        
                    else
                        if (cnt_clk_bit < 8) then
                            byte_out <= d_byte(cnt_clk_bit);
                        elsif (cnt_clk_bit = 8) then
                            byte_out <= parity;
                        else
                            byte_out <= '1';
                            data_busy <= '0';
                            d_byte <= "10000000";
                            if (one_byte = '1') then
                                onebyte <= '1';
                                end if;
                        end if;
                        cnt_clk_bit <= cnt_clk_bit + 1;
                    end if;
                    
                        
                        
                    end if;
                  end if;
                end if;
              
      end process N_Reciever;
                
                

end Behavioral;

