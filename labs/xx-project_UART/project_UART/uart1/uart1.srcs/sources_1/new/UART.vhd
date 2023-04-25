----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:10:52 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
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
           XA_P : out STD_LOGIC_VECTOR (15 downto 0); --TX
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNL : in STD_LOGIC
           );
end UART;

architecture Behavioral of UART is
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
  signal sig_frame_width     : integer:= 5; 
  
begin

    baud : entity work.baud      
        port map(          
          clk => CLK100MHZ,
          rst => '0',
          baud_sw  => SW(15 downto 14),
          clk_baud  => sig_clk,
          data0 => sig_data0,
          data1 => sig_data1,
          data2 => sig_data2,
          data3 => sig_data3,
          data4 => sig_data4
          
        );
    display : entity work.driver_7seg_8digits
         port map( 
            clk => sig_clk,
            rst => sig_rst,
            data0 => sig_data0,
            data1 => sig_data1,
            data2 => sig_data2,
            data3 => sig_data3,
            data4 => sig_data4,
            data5 => sig_data5,
            data6 => sig_data6,
            data7 => sig_data7,
            dp_vect => "11110111",
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG    
         );
    trasnmitter : entity work.Transmitter 
         generic map(
          g_CNT_WIDTH => 4,
          g_FRAME_WIDTH => 9,
          g_PACKET_WIDTH => 9
         )
         port map( 
            clk => sig_clk,
            rst => sig_rst,
            Tx_data => SW(8 downto 0),         -- always 9bits
            Tx_frame_width => sig_frame_width,   -- frame width
            sig_bit_t
            par_bit => SW(11),                       --add par bit to packet
            --par_bit_t : in STD_LOGIC;                            -- type of parity (odd or even)
            clk_baud => sig_clk_baud,                           --clk signal from baud
            Tx_en => SW(10),                                --start or stop transmitt
            stop_bit => SW(12),                             --1 or 2 stop bits
            Tx_packet => XA_P   -- completed packet to send               
         ); 
    
end Behavioral;
