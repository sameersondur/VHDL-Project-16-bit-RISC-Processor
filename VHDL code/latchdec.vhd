Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

-------------------------Entity Declaration--------------------------------------------------------
entity latch2dec is
  port(immedi, rlsaddressi : in std_logic_vector(7 downto 0);
       rdxi,rdyi : in std_logic_vector(3 downto 0);
       PCi : in std_logic_vector(7 downto 0);   -- output PC
       aluoptodrami, offseti: in std_logic_vector(3 downto 0); -- offset for the jump if zero and not zero, aluopdraam for the dram operations
       aluopi: in std_logic_vector(4 downto 0);      
       aluopsei, wri, ryimmedi,regindiri: in std_logic;
       ---------------------------------------------------------------
      pctake,clk: in std_logic;
      ----------------------------------------------------------------
      immed, rlsaddress : out std_logic_vector(7 downto 0);
       rdx,rdy : out std_logic_vector(3 downto 0);
       PC : out std_logic_vector(7 downto 0);   -- output PC
       aluoptodram, offset: out std_logic_vector(3 downto 0); -- offset for the jump if zero and not zero, aluopdraam for the dram operations
       aluop: out std_logic_vector(4 downto 0);
       
       aluopse, wr, ryimmed,regindir: out std_logic);
end  latch2dec;      
---------------------------------------------------------------------------------------------------------

-------------------------Architecture Body Declaration---------------------------------------------------      
  Architecture lacha2dec of latch2dec is
    begin
      --------------Process Declaration----------------------
      cntr: process(clk,pctake) is  
      variable clk_count : integer := 1 ;
      begin    
      if(clk'event and clk='0') then
        if(clk_count=2) then
        immed <=immedi;
        rlsaddress <= rlsaddressi;
        rdx <= rdxi;
        rdy <=rdyi;
        PC <= PCi;
        aluoptodram <=aluoptodrami;
        offset <= offseti;
        aluop <=aluopi;
        aluopse <= aluopsei; wr <= wri; ryimmed <= ryimmedi;regindir <=regindiri;
        
        
      else
        clk_count:=clk_count +1;
      end if;
        
        
      end if;
      
      if(pctake ='1') then
      aluop<="00000";
    end if;
    end process cntr;
    -----------------------------------------------------------------------------
    
    ---------------Process 2 declaration----------------------------------------
    cntr2: process(pctake)
    
    begin
      
      
    
    end process cntr2;
    ----------------------------------------------------------------------------
      
    end Architecture lacha2dec;     --architecture ends here