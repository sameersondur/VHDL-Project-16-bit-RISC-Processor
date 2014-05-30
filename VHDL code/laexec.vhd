Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

--------------Entity Declaration-------------------------------------
entity latch3exe is
  port(rorderi ,aluoptodrami:in std_logic_vector(3 downto 0);
      PCi,aluouti,rxtodmemi,rymuxi,rlsaddressi : in std_logic_vector(7 downto 0);
      pctakei,wreni,regindiri:in std_logic;
      clk: in std_logic;
      rorder ,aluoptodram:out std_logic_vector(3 downto 0);
      PC,aluout,rxtodmem,rymux,rlsaddress : out std_logic_vector(7 downto 0);
      pctake,wren,regindir:out std_logic);
end  latch3exe;      
----------------------------------------------------------------------------

--------------Architecture Body Declaration------------------------------------      
  Architecture lacha3exe of latch3exe is
    begin
      ---------Process Declaration----------------------
      cntr: process(clk) is  
      variable clk_count : integer := 1 ;
      begin    
      if(clk'event and clk='0') then
        if(clk_count=3) then
        rorder<= rorderi ;aluoptodram<=aluoptodrami;
        PC <= PCi ;aluout <=aluouti ;rxtodmem <=rxtodmemi ;rymux <=rymuxi;rlsaddress <= rlsaddressi;
        pctake <= pctakei; wren <= wreni;regindir  <= regindiri;
      else
        clk_count:=clk_count +1;
      end if;
        
        
      end if;
    end process cntr;
    ---------------------------------------------------------  
    
    end Architecture lacha3exe;     --architecture ends here