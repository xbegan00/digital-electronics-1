----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:13:24 PM
-- Design Name: 
-- Module Name: Transmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transmitter is
    generic (
        g_FRAME_WIDTH : natural := 9;   --! Default number of frame bits
        g_PACKET_WIDTH : natural := 12;  --! Default number of packet bits
        g_CNT_WIDTH : natural := 4      --! Default number of counter bits
      );
    Port ( Tx_data : in STD_LOGIC_VECTOR (8 downto 0);          -- always 9bits
           Tx_frame_width : in STD_LOGIC_VECTOR (3 downto 0);   -- frame width
           par_bit : in STD_LOGIC;                              --add par bit to packet
           par_bit_t : in STD_LOGIC;                            -- type of parity (odd or even)
           clk_baud : in STD_LOGIC;                                  --clk signal from top
           rst : in STD_LOGIC;                                  --rst from top
           Tx_en : in STD_LOGIC;                                --start or stop transmitt
           stop_bit : in STD_LOGIC;                             --1 or 2 stop bits
           Tx_packet : out STD_LOGIC_VECTOR (g_PACKET_WIDTH - 1 downto 0);     -- completed packet to send    
           Tx_output : out STD_LOGIC
           );         
end Transmitter;

architecture Behavioral of Transmitter is
    type t_state is ( --BIT by BIT
        START_BIT, 
        PARITY_BIT,
        FRAME_BIT,
        STOP_BITS        
    );
    signal Tx_frame : STD_LOGIC_VECTOR (g_FRAME_WIDTH - 1 downto 0);        -- allocated data to frame from Tx_data
    signal sig_state : t_state := START_BIT;                               -- signal for state          
    signal sig_rst : std_logic := '1';
    signal sig_par_bit : std_logic := '0';
    signal sig_cnt : unsigned(g_CNT_WIDTH - 1 downto 0);                    --! Local counter  
    signal sig_frame_width : integer:= 0;
    signal sig_data_width : integer:= 9;
    signal sig_packet_width : integer:= 1;
    signal sig_cnt_par : integer:= 0;
    shared variable i : integer:= 0;
    shared variable y : integer:= 0;
    
begin
  process(clk_baud, rst)
   begin
         
         if (rising_edge(clk_baud)) then --clk_baud
            if (rst = '1') then
                sig_rst <= '1';
                sig_state <= START_BIT;                
            else
                case sig_state is
                --START
                  when START_BIT =>
                    sig_rst <= '0'; 
                    if (Tx_en = '1') then                                        
                        sig_state <= PARITY_BIT; 
                    elsif (Tx_en = '0') then
                        sig_state <= START_BIT;                        
                    end if;
                --FRAME
                  when FRAME_BIT =>   
                     i := 0;   
                     y := 0;                                 
                     while (i < 9) loop
                        Tx_frame(i) <= Tx_data(i);
                         i := i + 1;   
                         y := y + 1;  
                     end loop;
                     sig_frame_width <= 0;
                     sig_data_width <= 0;
                     sig_state <= PARITY_BIT;
                --PARITY
                  when PARITY_BIT =>
                    i := 0;   
                    y := 0; 
                    if (par_bit = '1') then
                        while  (i < 9) loop
                           if (Tx_frame(i) = '1') then
                                sig_cnt_par <= sig_cnt_par + 1;
                                i := i + 1;
                           else
                                i := i + 1;
                           end if;                           
                        end loop;
                        if ((par_bit_t = '0') and (sig_cnt_par mod 2 = 0)) then --even parity
                            sig_par_bit <= '1'; 
                        else
                            sig_par_bit <= '0';                          
                        end if;
                        if ((par_bit_t = '1') and (sig_cnt_par mod 2 = 0)) then --odd parity
                            sig_par_bit <= '0'; 
                        else
                            sig_par_bit <= '1';                          
                        end if;                        
                         sig_cnt_par <= 0;                     
                    end if;
                    sig_state <= STOP_BITS;
                --PACKET
                  when STOP_BITS =>
                    i := 0;
                    y := 0;
                    Tx_packet(0)  <= '0'; 
                    while  i < 9 loop
                        Tx_packet(i)  <= Tx_frame(i);  
                        i := i + 1;                  
                    end loop;
                    if (stop_bit = '0') then
                        Tx_packet(sig_packet_width + 1)  <= '0'; 
                    else
                        Tx_packet(sig_packet_width + 1)  <= '0'; 
                        Tx_packet(sig_packet_width + 2)  <= '0';
                    end if;
                    sig_packet_width <= 1; 
                    sig_state <= START_BIT;                  
                end case;
                
            end if;
         end if;
   end process;    
end Behavioral;
