----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Mojmir Began
-- 
-- Create Date: 02/28/2023 01:33:19 PM
-- Design Name: hex_7seg
-- Module Name: tb_hex_7seg - Behavioral
-- Project Name: display
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top is
 --  Port ( );    
end tb_top;

architecture Behavioral of tb_top is

-- Testbench local signals
     signal sig_SW :   STD_LOGIC_VECTOR (3 downto 0);
     signal sig_LED :  STD_LOGIC_VECTOR (7 downto 0);
     signal sig_CA :   STD_LOGIC;
     signal sig_CB :   STD_LOGIC;
     signal sig_CC :   STD_LOGIC;
     signal sig_CD :   STD_LOGIC;
     signal sig_CE :   STD_LOGIC;
     signal sig_CF :   STD_LOGIC;
     signal sig_CG :   STD_LOGIC;
     signal sig_AN :   STD_LOGIC_VECTOR (7 downto 0);
     signal sig_BTNC : STD_LOGIC;
     
begin

uut_top : entity work.top
    port map (
     SW   => sig_SW, 
     LED  => sig_LED,
     CA   => sig_CA,
     CB   => sig_CB,
     CC   => sig_CC,
     CD   => sig_CD,
     CE   => sig_CE,
     CF   => sig_CF,
     CG   => sig_CG,
     AN   => sig_AN,
     BTNC   => sig_BTNC
    );

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";

    sig_BTNC <= '0';    -- Normal operation
    sig_AN   <= b"1111_0111"; -- Some default value      
    sig_SW <= "0000";
    wait for 50 ns;

    sig_BTNC <= '1';    -- Blank display
    wait for 150 ns;
    sig_BTNC <= '0';    -- Normal operation
    wait for 15 ns;

    -- Loop for all hex values
    for iiii in 0 to 15 loop

      sig_SW <= std_logic_vector(to_unsigned(iiii, 4));
      wait for 50 ns;
    
    end loop;
    
    report "Stimulus process finished";
    wait;
    
    
   end process p_stimulus;
   
end Behavioral;
