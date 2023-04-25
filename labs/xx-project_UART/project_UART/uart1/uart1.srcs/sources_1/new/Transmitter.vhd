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
           clk : in STD_LOGIC;                                  --clk signal from top
           clk_baud : in STD_LOGIC;                             --clk signal from baud
           rst : in STD_LOGIC;                                  --rst from top
           Tx_en : in STD_LOGIC;                                --start or stop transmitt
           stop_bit : in STD_LOGIC;                             --1 or 2 stop bits
           Tx_packet : out STD_LOGIC_VECTOR (g_PACKET_WIDTH - 1 downto 0));     -- completed packet to send           
end Transmitter;

architecture Behavioral of Transmitter is
    type t_state is (
        START_STOP,
        PARITY,
        FRAME,
        PACKET,
        SEND
    );
    signal Tx_frame : STD_LOGIC_VECTOR (g_FRAME_WIDTH - 1 downto 0);        -- allocated data to frame from Tx_data
    signal sig_state : t_state := START_STOP;                               -- signal for state          
    signal sig_rst : std_logic := '1';
    signal sig_par_bit : std_logic := '0';
    signal sig_cnt : unsigned(g_CNT_WIDTH - 1 downto 0);                    --! Local counter  
    signal sig_frame_width : integer:= 0;
    signal sig_data_width : integer:= 9;
    signal sig_packet_width : integer:= 1;
    signal sig_cnt_par : integer:= 0;
begin
  process(clk, rst)
   begin
         if (rising_edge(clk)) then
            if (rst = '1') then
                sig_rst <= '1';
                sig_state <= START_STOP;                
            else
                case sig_state is
                --START
                  when START_STOP =>
                    sig_rst <= '0'; 
                    if (Tx_en = '1') then                                        
                        sig_state <= PARITY; 
                    elsif (Tx_en = '0') then
                        sig_state <= START_STOP;                        
                    end if;
                --FRAME
                  when FRAME =>                     
                     while sig_frame_width < g_FRAME_WIDTH and sig_data_width < 9 loop
                        Tx_frame(sig_frame_width) <= Tx_data(sig_data_width);
                        sig_frame_width <= sig_frame_width + 1;
                        sig_data_width <= sig_data_width + 1;
                     end loop;
                     sig_frame_width <= 0;
                     sig_data_width <= 0;
                     sig_state <= PARITY;
                --PARITY
                  when PARITY =>
                    if (par_bit = '1') then
                        while  sig_frame_width < g_FRAME_WIDTH loop
                                if (Tx_frame(sig_frame_width) = '1') then
                                    sig_cnt_par <= sig_cnt_par + 1;
                                end if;
                                sig_frame_width <= sig_frame_width + 1;
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
                    sig_state <= PACKET;
                --PACKET
                  when PACKET =>
                    Tx_packet(0)  <= '0'; 
                    while  sig_packet_width <= g_FRAME_WIDTH loop
                        Tx_packet(sig_packet_width)  <= Tx_frame(sig_packet_width-1);  
                        sig_packet_width <= sig_packet_width + 1;                  
                    end loop;
                    if (stop_bit = '0') then
                        Tx_packet(sig_packet_width + 1)  <= '0'; 
                    else
                        Tx_packet(sig_packet_width + 1)  <= '0'; 
                        Tx_packet(sig_packet_width + 2)  <= '0';
                    end if;
                    sig_packet_width <= 1;  
                --SEND
                  when SEND =>
                    if (Tx_en = '1') then                                        
                        sig_state <= SEND; 
                    elsif (Tx_en = '0') then
                        sig_state <= START_STOP;                        
                    end if;
                end case;
                
            end if;
         end if;
   end process;    
end Behavioral;
