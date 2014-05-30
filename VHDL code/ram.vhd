Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

------------------------Entity Declaration -----------------------------------------------
entity ram is 
  port(
    Rdx, Rdy: in std_logic_vector(3 downto 0);
    rxorder,ryorder:out std_logic_vector(3 downto 0);
    wrindex: in std_logic_vector(3 downto 0);
    Rx, Ry,rlsaddresso: out std_logic_vector(7 downto 0);
     wr,clk,regindir: in std_logic;      --take wr from pratik  --regindir is for propogation to the write back
    regindiro : out std_logic;
     wrb,rlsaddressi:in std_logic_vector(7 downto 0)
    );
 end ram; 
 -----------------------------------------------------------------------------------------
 
-----------------Architecture Body Declaration------------------------------------------- 
architecture rama of ram is
  
  begin
      --------- Process 1 -----------------------------------------------
      cntr:process(wr,wrb,wrindex,rdx,rdy) is
      variable clk_count : integer := 1 ;
      type dataout is array (15 downto 0) of std_logic_vector(7 downto 0);
      variable a : dataout := ("00000001", "00000010", "00000100", "00000110","00000011","00001000","00000000","01000000","00000011","10101010","00000101","00010000","10000000","00000111","00000101","00001111") ;
      begin
      
      --if(clk_count=4) then
      if(wr='1') then
          --wait for 10 ns;     -- check the clock freq
          a(Conv_Integer(wrindex)) := wrb  ;
        end if;
      
        --if(clk'event and clk='1') then
        Rx <= a(Conv_Integer(Rdx));
        Ry <= a(Conv_Integer(Rdy));
        rxorder <= Rdx;
        ryorder <= Rdy;
               
      end process cntr;
      --------------------------------------------------------------------
      
      -------------Process 2 ---------------------------------------------
      cntr2: process(clk) is
      begin
      if(clk'event and clk='1') then  
      regindiro <= regindir;
        rlsaddresso<=rlsaddressi;
      end if;
        
       
      end process cntr2;
      -----------------------------------------------------------------------
     end architecture rama;   --architecture ends here
  