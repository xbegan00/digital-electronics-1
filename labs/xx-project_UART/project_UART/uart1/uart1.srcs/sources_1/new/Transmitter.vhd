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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transmitter is
    Port ( Tx_data : in STD_LOGIC_VECTOR (7 downto 0);
           par_bit : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Tx_en : in STD_LOGIC;
           Tx_frame : out STD_LOGIC_VECTOR (11 downto 0));
end Transmitter;

architecture Behavioral of Transmitter is

begin


end Behavioral;
