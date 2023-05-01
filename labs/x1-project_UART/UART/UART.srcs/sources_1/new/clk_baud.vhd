library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- Package for arithmetic operations

entity clk_baud is

    Port ( clk : in STD_LOGIC; --! Main clock
           rst : in STD_LOGIC; --! High-active synchronous reset
           baud_sw : in STD_LOGIC_VECTOR(2 downto 0);
           clk_baud : out STD_LOGIC; --Output baud clock for RX/TX, using code from clock_enable
           data0 : out STD_LOGIC_VECTOR(3 downto 0); --data for display
           data1 : out STD_LOGIC_VECTOR(3 downto 0);
           data2 : out STD_LOGIC_VECTOR(3 downto 0);
           data3 : out STD_LOGIC_VECTOR(3 downto 0);
           data4 : out STD_LOGIC_VECTOR(3 downto 0)
           );
end clk_baud;

architecture behavioral of clk_baud is
   --Local signal for storing baud rate
  signal baud_gen : integer:= 0;
   -- Local counter
  signal sig_cnt : natural:= 0;
  
begin

    baud_solve : process(clk) is
    begin
        if rising_edge(clk) then              -- Synchronous process  
                case baud_sw is
                    when "000" =>
                        --baud_gen <= 20833;   --4800
                        baud_gen <= 1;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "1000";
                        data3 <= "0100";
                        data4 <= "0000";
                    when "001" =>
                        --baud_gen <= 10417;   --9600
                        baud_gen <= 2;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "0110";
                        data3 <= "1001";
                        data4 <= "0000";
                    when "010" =>
                        --baud_gen <= 6944;    --14400
                        baud_gen <= 3;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "0100";
                        data3 <= "0100";
                        data4 <= "0001";
                    when "011" =>
                        --baud_gen <= 5208;    --19200
                        baud_gen <= 4;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "0010";
                        data3 <= "1001";
                        data4 <= "0001";
                    when "100" =>            
                        --baud_gen <= 3472;    --28800
                        baud_gen <= 5;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "1000";
                        data3 <= "1000";
                        data4 <= "0010";
                    when "101" =>
                        --baud_gen <= 2604;    --38400
                        baud_gen <= 6;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "0100";
                        data3 <= "1000";
                        data4 <= "0011";
                    when "110" =>
                        baud_gen <= 1736;    --57600
                        baud_gen <= 7;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "0110";
                        data3 <= "0111";
                        data4 <= "0101";
                    when "111" =>
                        baud_gen <= 868;     --115200
                        baud_gen <= 8;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "0010";
                        data3 <= "0101";
                        data4 <= "1011";
                    when others =>
                        --baud_gen <= 20833;   --4800
                        baud_gen <= 9;   --testbench
                        data0 <= "0000";
                        data1 <= "0000";
                        data2 <= "1000";
                        data3 <= "0100";
                        data4 <= "0000";
                    end case;
        end if;
     end process baud_solve;
     
  --------------------------------------------------------
  -- 1. process dava 100M signalu za sekundu 
  -- 2. slozka, ktera nabiha a ma velikost v zavislosti od baud_sw
  -- 3. kdyz dosahneme vysledny hodnoty, posle se signal na rx/tx a sloska prejde na 0
  -- 3.1 kdyz zmenime neco v baud_gen, tak sloska prejde na 0

  --------------------------------------------------------
  -- p_clk_enable:
  -- Generate clock enable signal. By default, enable signal
  -- is low and generated pulse is always one clock long.
  --------------------------------------------------------
  p_clk_enable : process (clk) is
  begin

    if rising_edge(clk) then              -- Synchronous process
       if (rst = '1') then                 -- High-active reset
         sig_cnt     <= 0;                 -- Clear local counter
         clk_baud    <= '0';               -- Set output to low

      -- Test number of clock periods
      elsif (sig_cnt >= (baud_gen - 1)) then
        sig_cnt <= 0;                     -- Clear local counter
        clk_baud      <= '1';             -- Generate clock enable pulse
      else
        sig_cnt <= sig_cnt + 1;
        clk_baud      <= '0';
      end if;
    end if;

  end process p_clk_enable;  
end Behavioral;