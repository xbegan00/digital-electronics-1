----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2023 01:02:54 PM
-- Design Name: 
-- Module Name: UART_RX - Behavioral
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

entity UART_RX is
    generic(
      g_CLKS_PER_BIT : integer := 868); -- rychlost p?edavaní (nexys_frequency) / (bound(115200))
    
    Port ( CLK100MHZ : in STD_LOGIC; -- frekvence Nexys a7-50t
           RX_Serial : in STD_LOGIC;
           RX_DV : out STD_LOGIC;
           RX_Byte : out STD_LOGIC_VECTOR (0 to 7)); -- datove bity
end UART_RX;

architecture Behavioral of UART_RX is

begin


end Behavioral;
