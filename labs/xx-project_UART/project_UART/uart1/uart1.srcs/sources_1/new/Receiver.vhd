----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:12:25 PM
-- Design Name: 
-- Module Name: Receiver - Behavioral
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
use ieee.numeric_bit.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Receiver is
    Port ( Rx : in STD_LOGIC_VECTOR(7 downto 0); -- "01101010"
           clk : in STD_LOGIC;
           Rxd_out : out STD_LOGIC_VECTOR (7 downto 0);
           par_bit : out STD_LOGIC;
           par_error : in STD_LOGIC;
           baud_gen : in INTEGER);
end Receiver;



architecture Behavioral of Receiver is

signal par_bin : STD_LOGIC := '0';

begin
    parity_look : process (clk) is
    begin
        par_bit <= '0';
        for bit in Rx(0) to Rx(7) loop
            if (bit = '1') then
                if (par_bin = '0') then
                    par_bin <= '1';
                    par_bit <= '1';
                else
                    par_bin <= '0';
                    par_bit <= '0';
                end if;
            end if;
         end loop;
        

    end process parity_look;



end Behavioral;
