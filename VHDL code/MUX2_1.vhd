library ieee;
use ieee.std_logic_1164.all;

--------Entity Declaration-------------------------------------
entity MUX_2_1 is
  port( Ry : in std_logic_vector(7 downto 0) := (others => '0');
  IM : in std_logic_vector(7 downto 0) := (others => '0');
  SEL : in std_logic := '0';
  To_ALU : out std_logic_vector(7 downto 0) := (others => '0'));
end entity MUX_2_1;
---------------------------------------------------------------

-----------Architecture Body Declaration-----------------------
architecture mux_arch_behav of MUX_2_1 is
begin
-----------Process declaration--------  
proc_mux: process(Ry, IM, SEL)
begin
if(SEL = '0') then
  To_ALU <= Ry;
elsif(SEL = '1')  then
  To_ALU <= IM;
end if;
end process proc_mux;
-------------------------------------

end architecture mux_arch_behav;    --architecture ends here