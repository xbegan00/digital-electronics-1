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
           --par_bit : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Tx_en : in STD_LOGIC;
           Tx_frame : out STD_LOGIC_VECTOR (10 downto 0));
end Transmitter;

architecture Behavioral of Transmitter is
    --signal count : integer range 0 to CLK_FREQ / BAUD_RATE - 1 := 0;
    signal par_bit: std_logic;
    signal count_bit : integer := 0;
    signal shift_reg : std_logic_vector(10 downto 0) := (others => '1');
    signal Tx : std_logic;
begin
  process(clk, rst)
   begin
         -- vypocet hodnot 1 v datach
         if (Tx_data(0) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(1) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(2) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(3) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(4) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(5) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(6) = '1') then 
             count_bit <= count_bit + 1;
         elsif (Tx_data(7) = '1') then 
             count_bit <= count_bit + 1;                     
         end if;
         --vypocet par_bit
         par_bit <= '1' when (count_bit = 2 or count_bit = 4 or count_bit = 6 or count_bit = 8) else
                    '0';         
        --frame creation
        if rst = '1' then
            count_bit <= 0;
            shift_reg <= (others => '1');
            Tx <= '1';
        elsif rising_edge(CLK) then
            if Tx_en = '1' then                
                    shift_reg(0) <= '0'; -- start bit
                    shift_reg(8 downto 1) <= Tx_data;
                    --shift_reg(9) <= Tx_data; -- parry bit
                    shift_reg(10) <= '0'; -- stop bit      
            else
                shift_reg <= (others => '1');                
            end if;
        end if;
    end process;
    
    Tx <= '1'; 
    
end Behavioral;
