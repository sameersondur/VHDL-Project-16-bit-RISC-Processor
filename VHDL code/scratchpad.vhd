Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;
use ieee.numeric_std.all; 

-----------------------Entity Declartaion-----------------------------------------------------------------
entity scratchpad is
  port(
    clk,scratchenable,extract,put:in std_logic;		---for resolution the scratchenable and extarct are given
    r0i,r1i,pci: in std_logic_vector(7 downto 0);
    rout,pco:out std_logic_vector(7 downto 0);
    pctake: out std_logic
    
  
  );
end entity scratchpad;
-------------------------------------------------------------------------------------------------------------  
  
---------------Architecture Declaration------------------------------------------------------
    architecture scratch of scratchpad is
      type dataout is array (15 downto 0) of std_logic_vector(7 downto 0);
      signal a : dataout := ("00000000", "00000000", "00000000", "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000") ;
      
      
    begin   --architecture begins here
      ------------Process Declaration-----------------------------------
      scr:process(clk,scratchenable) is
      variable tmp2: integer :=1;
      variable tmp1: integer :=1;
      variable pcscratch:std_logic_vector(7 downto 0);
      type dataout is array (15 downto 0) of std_logic_vector(7 downto 0);
      
      begin   --process begins here
        if (clk'event and clk = '0') then
          
          ---- PUSH PC and register bank into Scratchpad ----
          if(((scratchenable='1') and (put='1') and (extract='0'))) then
          tmp2:=1;
            case tmp1 is
            when 1 =>
		          pcscratch:=pci;  
            when 2 =>
              a(0)<=r0i;
              a(1)<=r1i;
              
              
            when 3  =>
              a(2)<=r0i;
              a(3)<=r1i; 
              
            when 4 =>
              a(4)<=r0i;
              a(5)<=r1i;
              
            when 5 =>
              a(6)<=r0i;
              a(7)<=r1i;
              
            when 6 =>
              a(8)<=r0i;
              a(9)<=r1i;
              
            when 7 =>
              a(10)<=r0i;
              a(11)<=r1i;
              
            when 8 =>
              a(12)<=r0i;
              a(13)<=r1i;
          
            when 9  =>
              a(14)<=r0i;
              a(15)<=r1i;
              tmp1:=0;
              
            when others =>
              tmp1:=0;
              
            end case;
          tmp1:=tmp1+1;
          pctake<='0';
          
        end if;
        --------------------------------------------------------
        
        ----------EXTRACTION------------------------------------
        if(scratchenable='1' and extract='1' and put='0') then
          tmp1:=1;
          case tmp2 is
          when 1 =>
            rout<=a(0);
            pco<=pcscratch;
          when 2 =>
            rout<=a(1);
            
          when 3 =>
            rout<=a(2);  
            
          when 4 =>
            rout<=a(3);
            
          when 5 =>
            rout<=a(4);
            
          when 6 =>
            rout<=a(5);
            
          when 7 =>
            rout<=a(6);
            
          when 8 =>
            rout<=a(7);
            
          when 9 =>
            rout<=a(8); 
            
          when 10 =>
            rout<=a(9);
            
          when 11 =>
            rout<=a(10);
            
          when 12 =>
            rout<=a(11);
            
          when 13 =>
            rout<=a(12);
            
          when 14 =>
            rout<=a(13);
            
          when 15 =>
            rout<=a(14);
            
          when 16 =>
            rout<=a(15);
            tmp2:=0;
            pco<=pcscratch;
          when others =>
            tmp2:=0;
        end case;
            if(tmp2=15) then
              pctake<='1';
            else 
              pctake<='0';
            end if;
                
            tmp2:=tmp2+1;
            
        end if;
          
      end if;
      -----------------------------------------------------
    end process scr;    --process ends here
  end architecture scratch;   --architecture ends here
    
        
