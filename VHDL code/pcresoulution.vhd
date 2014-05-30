Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-------------Entity Declaration------------------------------------------------------
entity pcresolve is
  port(pc1,pc2:in std_logic_vector(7 downto 0);
    pctake1,pctake2: in std_logic;
    pcout: out std_logic_vector(7 downto 0);
    pctake: out std_logic;
    -----------------------writebacksignal from decoder for interrupts and writeback stage resolution
    scratchenable,extract,wr2:in std_logic;
    rindexdec1,rindex2:in std_logic_vector(3 downto 0);
    data1,data2:in std_logic_vector(7 downto 0);
    rout: out std_logic_vector(3 downto 0);
    data: out std_logic_vector(7 downto 0);
    wrback:out std_logic
  );
end entity pcresolve;  
--------------------------------------------------------------------------------------

-----------------Architecture Body Declaration-----------------------------------------  
architecture pcresolvearchi of pcresolve is
  
  begin
    wrback<= (scratchenable and extract) or wr2;
    rout <= rindexdec1 when (scratchenable='1' and extract='1') else
            rindex2 when wr2='1' else
            "XXXX";
    data <= data1 when (scratchenable='1' and extract='1') else
	    data2 when wr2='1' else
	    "XXXXXXXX";
    pctake <= pctake1 or pctake2;
    pcout <= pc2 when (pctake2='1') else
	     pc1 when (pctake1='1') else
		"XXXXXXXX" ;
    
  end architecture pcresolvearchi;
 ----------------------------------------------------------------------------------------       
        
    
  
