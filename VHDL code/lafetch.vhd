Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

---------------Entity Declaration -------------------------
entity latchfetch is
  port(pc_outi : in std_logic_vector(7 downto 0);
		  instructioni : in std_logic_vector (15 downto 0);
      clk,pctake: in std_logic;
      pc_out : out std_logic_vector(7 downto 0);
		  instruction : out std_logic_vector (15 downto 0));
end  latchfetch;      
-----------------------------------------------------------

------------Architecture Body Declaration------------------      
  Architecture lachafetch of latchfetch is
    begin
     -------------Process 1 declaration------------ 
      cntr: process(clk,pctake) is  
	    variable tmp: integer :=0;
      begin    
      if(clk'event and clk='0') then
        pc_out <= pc_outi;
        instruction <= instructioni;
        
      end if;
	    if(tmp=2) then  
	     tmp:=0;
	    end if;
      if(tmp=0) then
      if(pctake ='1') then
      instruction <="0000000000000000";
      tmp:=tmp+1;
      end if;
      end if;
      
      end process cntr;
     --------------------------------------------------
     
     -----------Process 2 declaration-----------------
     cntr2: process(pctake)
    
      begin
         
      end process cntr2;
     --------------------------------------------------
      
    end Architecture lachafetch;    --architecture ends here
