Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;
use ieee.numeric_std.all; 


-----------Entity Declaration---------------------------------------------
entity aluproj1 is
  port(
    Rx,Ry,Immed,PCi,rlsaddressi: in std_logic_vector(7 downto 0);
    aluop: in std_logic_vector(4 downto 0);
    aluoptodrami :in std_logic_vector(3 downto 0);
    ryimm,clk,regindiri: in std_logic;
    rxorder,ryorder,offset: in std_logic_vector(3 downto 0);
    rwrite,aluoptodramo : out std_logic_vector(3 downto 0);
    aluout,PCo, rlsaddresso, rxo, ryo: out std_logic_vector(7 downto 0);
    zflag, wren,pctake,regindiro: out std_logic
  );
end aluproj1;
---------------------------------------------------------------------------

-----------Architecture Body Declaration----------------------------------------------
architecture aluwala of aluproj1 is
  
  begin
    
    valla: process(clk) is
    variable aluouttmp: std_logic_vector(7 downto 0):="00000000";
    variable clk_count : integer := 1 ;
      begin
        if(clk_count=5) then
        if(clk'event and clk='0') then
        case aluop is
        when "00000" =>
          aluouttmp:="00000001";    
          wren <='1';
          Pctake <= '0'; 
        when "00001" =>
          if(ryimm ='1') then  --immediate
            aluouttmp:=Rx +immed;
          elsif(ryimm = '0') then
            aluouttmp:= Rx + Ry;
          end if; 
          wren <='1';
          rwrite <=rxorder;
          Pctake <= '0'; 
          
        when "00010" => 
          aluouttmp:= Rx -Ry;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "00011" =>
          aluouttmp:= Rx +1;
         wren <='1';
          rwrite <=rxorder;
          Pctake <= '0'; 
        when "00100" =>
          aluouttmp:= Rx -1;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "00101" =>           
          aluouttmp:= to_stdlogicvector(to_bitvector(Rx) sll Conv_Integer(Ry));
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "00110"  =>
          aluouttmp:= to_stdlogicvector(to_bitvector(Rx) srl Conv_Integer(Ry));
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
      when "00111" =>
          aluouttmp:= not Rx;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
      when "01000" =>
          aluouttmp:= Rx nor Ry;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01001" =>
          aluouttmp:= Rx nand Ry;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01010" =>
          aluouttmp:= Rx xor Ry;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01011" =>
          aluouttmp:= Rx and Ry;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01100" =>
          aluouttmp:= Rx or Ry;
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01101" =>
          aluouttmp:= "00000000";
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01110" =>
          aluouttmp:= "00000001";
          wren <='1';
           rwrite <=rxorder;
           Pctake <= '0'; 
        when "01111" =>
          if(Rx < Ry) then
            aluouttmp:= "00000001"; 
          else 
            aluouttmp:= Rx;
          end if;
          Pctake <= '0'; 
          wren <='1';
           rwrite <=rxorder;
       when "10000" =>
         aluouttmp := Rx;
         wren <='1';
          rwrite <=ryorder;
          Pctake <= '0'; 
          
        when "10010" =>
          if(rx="00000000") then
            PCo<= PCi +offset;
            Pctake <= '1';            
        end if;
          wren <='0';
        
        when "10011" =>
          if(rx /="00000000") then
            PCo<= PCi +offset;  
            Pctake <= '1';           
        end if;
          wren <='0';
        
        when "10100" =>
          Pco <=Pci;            
          Pctake <= '0'; 
          wren <='0';
        
        when "10101" =>
          Pco <=Pci;  
          Pctake <= '1'; 
          wren <='0';
         
        when "10110" =>
          Pctake <= '0'; 
          wren <='1'; 
          rwrite <=rxorder;
          
        when "10111" =>
          Pctake <= '0'; 
          wren <='1'; 
          rwrite <=rxorder;
          
        when "11000" =>
          PCo<= "10000000";
            Pctake <= '1'; 
            wren<='0';

	      when "11001" =>
          PCo<= "10011001";
            Pctake <= '1'; 
            wren<='0';

	      when "11010" =>
          PCo<= "10110010";
            Pctake <= '1'; 
            wren<='0';

	      when "11011" =>
          PCo<= "11001011";
            Pctake <= '1'; 
            wren<='0';	
            
           
          when others =>
          wren <= '0';
          Pctake <= '0';
           
      end case;
      if(aluouttmp ="00000000") then
        zflag<= '1';
    else
        zflag<='0';
      end if;
      regindiro<=regindiri;
      rlsaddresso<=rlsaddressi;
      aluoptodramo <= aluoptodrami;
      aluout<=aluouttmp;
      rxo <=rx;
      ryo<= ry;
    end if;
    
  else
    clk_count :=clk_count +1;
    pctake <='0';
  end if;
    end process valla;
    --aluouttmp:= aluouttmp;
          
  end aluwala;
  -----------------------------------------------------------------------------------------
