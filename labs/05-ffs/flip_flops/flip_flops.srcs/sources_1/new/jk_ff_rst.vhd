library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity jk_ff_rst is
--  Port ( );
    Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               j : in STD_LOGIC;
               k_bar : in STD_LOGIC;
               q : out STD_LOGIC;
               q_bar : out STD_LOGIC);
end jk_ff_rst;

architecture Behavioral of jk_ff_rst is
-- It must use this local signal instead of output ports
    -- because "out" ports cannot be read within the architecture
    signal sig_q : std_logic;
begin
    --------------------------------------------------------
    -- p_t_ff_rst:
    -- T type flip-flop with a high-active synchro reset and
    -- rising-edge clk.
    -- q(n+1) = j./q(n) + /k.q(n)
    -- sig_q = j./sig_q + /k.sig_q
    --------------------------------------------------------
    p_jk_ff_rst : process (clk)
    begin
        if rising_edge(clk) then

        -- WRITE YOUR CODE HERE
            if (rst = '1') then
                sig_q <= '0';
            elsif (j = '0' and  k_bar  = '1') then
                sig_q <= '0'; 
            elsif (j = '1' and  k_bar  = '0') then
                sig_q <= '1';    
            elsif (j = '0' and  k_bar  = '0') then
                sig_q <= sig_q;                
            elsif (j = '1' and k_bar  = '1') then
                sig_q <= not sig_q;
            end if;    
        end if;
    end process p_jk_ff_rst;

    -- Output ports are permanently connected to local signal
    q     <= sig_q;
    q_bar <= not sig_q;

end Behavioral;
