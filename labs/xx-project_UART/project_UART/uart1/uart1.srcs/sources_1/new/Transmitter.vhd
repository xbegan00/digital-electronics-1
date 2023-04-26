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
    
    
    signal sig_rst : std_logic := '1';
    signal sig_par_bit : std_logic := '0';   
    shared variable a : integer:= 0;
    shared variable fw : integer:= 0;
    shared variable c : integer:= 0;
    shared variable d : integer:= 0;
    
begin
  process(clk_baud, rst)
   begin
         
         if (rising_edge(clk_baud)) then --clk_baud
            if (rst = '1') then
                sig_rst <= '1';                                
            else                
                if (Tx_en = '1') then
                    sig_rst <= '0';    
                    --START_bit
                    Tx_output <= '0';
                    --Set number for FRAME, so How mane bits from data will be send
                    a:= 0;
                    fw:= 5;
                    d:= 0;                    
                    if (Tx_frame_width = "0101") then 
                        fw:= 5;  --5bits
                    elsif (Tx_frame_width = "0110") then
                        fw:= 6;   --6bits
                    elsif (Tx_frame_width = "0111") then
                        fw:= 7;   --7bits
                    elsif (Tx_frame_width = "1000") then
                        fw:= 8;   --8bits
                    elsif (Tx_frame_width = "1001") then
                        fw:= 9;   --9bits
                    end if; 
                     
                    --FRAME_Bits + PARITY --nedokoncene vzpise vsetky 9 bitov
                    while a < g_FRAME_WIDTH loop                             
                            Tx_output <= Tx_data(a);
                            if (Tx_data(a) = '1') then
                                Tx_output <= Tx_data(a);
                                d:= d + 1;                                                                                
                            end if;
                            a:= a + 1;                        
                    end loop;
                    --PARITY_bit
                    if(par_bit = '1')then
                    
                        if (par_bit_t = '1') then --EVEN PARITY
                            if(d mod 2 = 0) then
                                Tx_output <= '1';
                            else
                                Tx_output <= '0';
                            end if;
                        elsif (par_bit_t = '0') then --ODD PARITY
                            if(d mod 2 = 0) then
                                Tx_output <= '0';
                            else
                                Tx_output <= '1';
                        end if;                         
                    end if;
                    --STOP_Bits
                    if (stop_bit = '1') then
                        c:= 0;
                        while c < 2 loop
                            Tx_output <= '1';
                            c:= c + 1;
                        end loop;
                    else
                        Tx_output <= '1';
                    end if;
                else  
                    Tx_output <= '1';                 
                end if;
                end if;
            end if;
         end if;
   end process;    
end Behavioral;
