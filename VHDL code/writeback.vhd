--Include libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------- Entity Declaration --------------------------------------------
entity writeback is 
  port(clk : in std_logic;
       ALUop_wr : in std_logic_vector(3 downto 0) := (others => '0');
       Reg_Ind_Wr : in std_logic := '0';
       Wr_in : in std_logic_vector(3 downto 0) := (others => '0');
       Rls_wr : in std_logic_vector(7 downto 0) := (others => '0');
       Ry_wr : in std_logic_vector(7 downto 0) := (others => '0');
       Rx_wr : in std_logic_vector(7 downto 0) := (others => '0');
       ALUout_wr : in std_logic_vector(7 downto 0) := (others => '0');
       WrBk_out : out std_logic_vector(7 downto 0) := (others => '0');
       Wen_out : out std_logic := '0';
       Wr_out : out std_logic_vector(3 downto 0) := (others => '0'));
end entity writeback;
---------------------------------------------------------------------------

-------------Architecture Body Declaration ---------------------------------
architecture writeback_arch of writeback is

-----------------component declaration -------------------------------------
component DMEM is
  port( Rls : in std_logic_vector(7 downto 0);
        Ry : in std_logic_vector(7 downto 0);
        Reg_Ind : in std_logic;
        ALUop : in std_logic_vector(3 downto 0);
        memd : in std_logic_vector(7 downto 0);
        MEM_op : out std_logic_vector(7 downto 0));
end component DMEM;    
---------------------------------------------------------------------------


signal memop :   std_logic_vector(7 downto 0) := (others => '0');     --signal declaration


begin   --architecture begins here
  DMEM_1: DMEM port map(
                        Rls => Rls_wr,
                        Ry => Ry_wr,
                        Reg_Ind => Reg_Ind_wr,
                        ALUop => ALUop_wr,
                        memd => Rx_wr,
                        MEM_op => memop);

-----------------Process Declaration---------------                        
WB_proc : process(clk,ALUop_wr,memop,ALUout_wr) is  

variable clk_count : integer := 1 ;   -- variable declaration

begin   -- process begins here
  if (clk'event and clk = '1') then 
  if(clk_count=4) then
case ALUop_wr(3 downto 0) is
when "1000"  =>  WrBk_out <= memop;
when "1010"  =>  WrBk_out <= memop;
when "1001"  =>  WrBk_out <= "00000000";
when "1011"  =>  WrBk_out <= "00000000";
when others => WrBk_out <= ALUout_wr;
end case;

  if(not(ALUop_wr = "1001" or ALUop_wr="1011" or ALUop_wr="1100" or ALUop_wr= "1101" or ALUop_wr="1110" or ALUop_wr="0001" or ALUop_wr="0111" or ALUop_wr="1111")) then
  Wen_out <= '1';
else
  Wen_out <= '0';
end if;
  Wr_out <= Wr_in;
  --clk_count :=0;
else
Wen_out <= '0';
clk_count:=clk_count +1;
end if;

end if;

end process WB_proc;  -- process ends here
end architecture writeback_arch;    --achitecture ends here

                     
