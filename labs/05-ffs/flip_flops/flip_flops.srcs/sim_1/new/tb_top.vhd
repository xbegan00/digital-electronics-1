library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
--  Port ( );
     
end tb_top;

architecture Behavioral of tb_top is

constant c_CLK_100MHZ_PERIOD : time := 10 ns;

    --Local signals
    signal sig_clk_100MHz : std_logic;
    signal sig_rst        : std_logic;
    signal sig_data       : std_logic;
    signal sig_dq        : std_logic;
    signal sig_dq_bar    : std_logic;

begin

uut_d_ff_rst : entity work.top
        port map (
            CLK100MHZ   => sig_clk_100MHz,
            BTNC   => sig_rst,
            SW     => sig_data,
            LED     => sig_dq,            
        );

end Behavioral;
