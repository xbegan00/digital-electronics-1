------------------------------------------------------------
--
-- Copyright (c) 2023 Mojmir Began
-- Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------

entity tb_mux_3bit_4to1 is
    -- Entity of testbench is always empty
end tb_mux_3bit_4to1;
------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture Behavioral of tb_mux_3bit_4to1 is
    signal s_a           : std_logic_vector(3 - 1 downto 0);
    signal s_b           : std_logic_vector(3 - 1 downto 0);
    signal s_c           : std_logic_vector(3 - 1 downto 0);
    signal s_d           : std_logic_vector(3 - 1 downto 0);
    signal s_f           : std_logic_vector(3 - 1 downto 0);
    signal s_sel         : std_logic_vector(2 - 1 downto 0);
    
begin
-- Connecting testbench signals with mux_3bit_4to1
    -- entity (Unit Under Test)
    uut_mux_3bit_4to1 : entity work.mux_3bit_4to1
        port map(
            a           => s_a,
            b           => s_b,
            c           => s_c,
            d           => s_d,
            f           => s_f,
            sel         => s_sel
    );

    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        -- Report a note at the beginning of stimulus process
        report "Stimulus process started";

        -- Report a note at the beginning of stimulus process
        report "Stimulus process started";
		
        -- First test case ...
        
        s_a <= "100"; s_b <= "111"; s_c <= "101"; s_d <= "110"; s_sel <= "00"; wait for 100 ns;
        -- ... and its expected outputs
        assert (s_sel = "00")
        -- If false, then report an error
        -- If true, then do not report anything
        report "Input combination 00, 00 FAILED" severity error;
        
        
        s_a <= "100"; s_b <= "111"; s_c <= "101"; s_d <= "110"; s_sel <= "01"; wait for 100 ns;
        -- ... and its expected outputs
        assert (s_sel = "01")
        -- If false, then report an error
        -- If true, then do not report anything
        report "Input combination 01, 01 FAILED" severity error;
        
       
        s_a <= "100"; s_b <= "111"; s_c <= "101"; s_d <= "110"; s_sel <= "10"; wait for 100 ns;
        -- ... and its expected outputs
        assert (s_sel = "10")
        -- If false, then report an error
        -- If true, then do not report anything
        report "Input combination 10, 10 FAILED" severity error;
       
        s_a <= "100"; s_b <= "111"; s_c <= "101"; s_d <= "110"; s_sel <= "11"; wait for 100 ns;
        -- ... and its expected outputs
        assert (s_sel = "11")
        -- If false, then report an error
        -- If true, then do not report anything
        report "Input combination 11, 11 FAILED" severity error;
        
    end process p_stimulus;
end Behavioral;
