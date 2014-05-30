Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

--------------------------------Entity Declaration------------------------------------------------------------------------------------------------
entity decoder is
  port(clk, zflg,irq0,irq1,irq2,irq3: in std_logic;
       instruction: in std_logic_vector(15 downto 0);
       PCi: in std_logic_vector(7 downto 0);
       immed, rlsaddress : out std_logic_vector(7 downto 0);
       rdx,rdy : out std_logic_vector(3 downto 0);
       PC : out std_logic_vector(7 downto 0);   -- output PC
       aluoptodram, offset: out std_logic_vector(3 downto 0); -- offset for the jump if zero and not zero, aluopdraam for the dram operations
       aluop: out std_logic_vector(4 downto 0);       
       aluopse, wr, ryimmed,regindir,put,extract, scratchenable: out std_logic);  -- pctake is the signal to accept the new PC
     end decoder;
--------------------------------------------------------------------------------------------------------------------------------------------------
 
------------------------------------ Architecture Body Declaration-------------------------------------------------------
architecture decod of decoder is

  begin
    --aluoptodram <= instruction(15 downto 12);
  
  ----------------Process Declaration-----------------------------------  
  wrr: process(clk,instruction) is
      
      ----------Variable Declarations------------------------------
      variable statusreg : std_logic_vector(7 downto 0):= "00000000";
      variable PCd :std_logic_vector(7 downto 0):="00000001";
      variable tmp2: integer :=1;
      variable tmp1: integer :=0;
      variable tmp3: integer :=1;
      variable tmp4: integer :=0;
      variable interrupt:integer:=0;  --whether interrupt is goin on or not
      variable int0:integer :=0;
      variable int1:integer :=0;
      variable int2:integer :=0;
      variable int3:integer :=0;
      
      begin
      if(clk'event and clk='1') then
        if(zflg = '1') then
          statusreg:= statusreg or "10000000";
        end if;
        
        ------------------Extraction------------------
        if(tmp4>=1 ) then
          tmp4:=tmp4+1;
          
          scratchenable<='0';
          put<='0';
          extract<='0';
          aluop <="00000";
          aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
          aluoptodram<= "0001";
	      if (tmp4>=3) then
	         scratchenable<='1';
            put<='0';
            extract<='1';
            rdx<=  conv_std_logic_vector((tmp4-3),4);
	      if(tmp4=16) then 
	         if(int0=1) then	----HIGHEST PRIORITY
              int0:=0;
		       elsif(int1=1) then
			        int1:=0;
			     elsif(int2=1) then
				      int2:=0;
				   elsif(int3=1) then
					    int3:=0;
	         end if;
		    if(int0+int1+int2+int3 >=1) then
		      interrupt:=1;
			if(int0=1) then	----HIGHEST PRIORITY
              			aluop<="11000";
				elsif(int1=1) then
					aluop<="11001";
				elsif(int2=1) then
					aluop<="11010";
				elsif(int3=1) then
					aluop<="11011";
	    		end if;
		  end if;	

	   end if;
	
          if(tmp4=19) then
            statusreg:=statusreg or "00001111";
            tmp4:=0; 
	  if(int0+int1+int2+int3 >=1) then	
            interrupt:=1;
	  else
		interrupt:=0;
	  end if; 
	    
	    wr<='0';
	    scratchenable<='0';
            put<='0';
            extract<='0';
	    
          end if;
	end if;
        end if;
          
        
        
        ------------------Putting inside the scratchpad-----------------
        if(tmp2=3) then
           scratchenable<='1';
           put<='1';
           extract<='0';
           case tmp3 is   --send the registers to the scratchpad
            when 1 =>
              rdx <= "0000";
              rdy<= "0001";
              PC<=PCd+1;
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              aluop<="00000";
              aluoptodram<= "0001";
            
            when 2 =>
              rdx <= "0010";
              rdy <= "0011";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              aluop<="00000";
              aluoptodram<= "0001";
              
            when 3 =>
              rdx <= "0100";
              rdy <= "0101";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              aluop<="00000";
              aluoptodram<= "0001";
              
            when 4 =>
              rdx <= "0110";
              rdy <= "0111";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              aluop<="00000";
              aluoptodram<= "0001";
              
            when 5 =>
              rdx <= "1000";
              rdy <= "1001";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              aluop<="00000";
              aluoptodram<= "0001";
              
            when 6 =>
              rdx <= "1010";
              rdy <= "1011";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              aluop<="00000";
              aluoptodram<= "0001";
              
            when 7 => --check if the thing to continue is taking 1 more clock cycle then make changes for the aluop here
              rdx <= "1100";
              rdy <= "1101";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              --PC <= PC +1;
              if(int0=1) then	----HIGHEST PRIORITY
              aluop<="11000";
		elsif(int1=1) then
			aluop<="11001";
			elsif(int2=1) then
				aluop<="11010";
				elsif(int3=1) then
					aluop<="11011";
	      end if;
              aluoptodram<= "0001";
              
              
            when 8 =>
              rdx <= "1110";
              rdy <= "1111";
              aluop <="00000";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              aluoptodram<= "0001";
            	
	    when 9=>
		rdx <= "1110";
              rdy <= "1111";
              aluop <="00000";
              aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
              aluoptodram<= "0001";
  
            when 10 =>
              tmp1:=0;
              tmp2:=1;
              tmp3:=0;
              scratchenable<='0';
              put<='0';
              extract<='0';
            when others=>
              null;
            end case;
            tmp3:=tmp3+1;
            
         --elsif(tmp4=0) then 
           
           
        end if;
        
        if(tmp1=1 and tmp2/=3) then  --ONCE THE INTR IS DETECTED WAIT FOR 2 CYCLES
          tmp2:=tmp2+1;
          aluoptodram<= "0001";      
        end if;
      ------EXECUTE THE INSTRUCTIONS ONLY WHEN TMP1=0
      
      if(tmp2/=3 and tmp4<1 and tmp1=0) then
      
      
       case instruction(15 downto 12) is
       when  "0000" =>          -- Doubtful
         aluopse <='0'; ryimmed<='0'; wr<='0'; regindir<='0';
         --PC <= PC +1;
         aluop<="00000";
         aluoptodram<= "0001";  --- this is given so that the wren signal will not be high
        when "0001" =>
          aluopse <= '1'; ryimmed<='1'; wr<='0'; regindir<='0';
          rdx <= instruction(11 downto 8);
          immed <= instruction(7 downto 0);
          aluop<="00001";    --addition
          aluoptodram<= "0000"; 
          
        when "0010" =>
          aluopse <= '1'; ryimmed<='0'; wr<='0'; regindir<='0';
          rdx <= instruction(7 downto 4);
          rdy <= instruction(3 downto 0);
          aluoptodram<= "0000"; 
          if(instruction (11 downto 8) = "0000") then
           aluop <= "00001";
          elsif(instruction(11 downto 8) = "0001") then
           aluop <= "00010";  --subtraction
          end if;
          
        when "0011" =>
          aluopse <= '1'; ryimmed<='0'; wr<='0';  regindir<='0';
          rdx <= instruction(7 downto 4);
          rdy <= instruction(3 downto 0);
          aluoptodram<= "0000"; 
           if(instruction(11 downto 8) = "0000") then
           aluop <= "00011";  --increment
          elsif(instruction(11 downto 8) = "0001") then
           aluop <= "00100";  --decrement
          end if;
          
        when "0100" =>
          aluopse <= '1'; ryimmed<='0'; wr<='0';regindir<='0';
          rdx <= instruction(7 downto 4);
          rdy <= instruction(3 downto 0);
          aluoptodram<= "0000"; 
          if(instruction(11 downto 8) = "0000") then
           aluop <= "00101";  --shift left
          elsif(instruction(11 downto 8) = "0001") then
           aluop <= "00110";  --shift right
          end if;
          
        when "0101" =>
          aluopse <= '1'; ryimmed<='0'; wr<='0';  regindir<='0';
          rdx <= instruction(7 downto 4);
          rdy <= instruction(3 downto 0);
          aluoptodram<= "0000"; 
          if(instruction(11 downto 8) = "0000") then
           aluop <= "00111";  --not rx
          elsif(instruction(11 downto 8) = "0001") then
           aluop <= "01000";  --nor rx , ry
          elsif(instruction(11 downto 8) = "0010") then
           aluop <= "01001";   -- nand rx, ry
          elsif(instruction(11 downto 8) = "0011") then
           aluop <= "01010";   -- xor rx, ry
          elsif(instruction(11 downto 8) = "0100") then
           aluop <= "01011";   -- and rx, ry
          elsif(instruction(11 downto 8) = "0101") then
           aluop <= "01100";   -- or rx, ry
          elsif(instruction(11 downto 8) = "0110") then
           aluop <= "01101";   -- clr rx
          elsif(instruction(11 downto 8) = "0111") then
           aluop <= "01110";   -- set rx
          elsif(instruction(11 downto 8) = "1111") then
           aluop <= "01111";   -- set if less than
           
           elsif(instruction(11 downto 8) = "1000") then
           aluop <= "10000";   -- Mov
            
          end if;
          
        when "0111" =>
          aluopse <= '0'; ryimmed<='0'; wr<='0';  regindir<='0';
          if(interrupt=0) then
          statusreg := statusreg or "00001111";
        end if;  
          aluoptodram<= "0111"; 
          aluop <= "11111";
        
      when "1000" =>
        aluoptodram<= "1000";
        rdx <= instruction(7 downto 4);
        rdy <= instruction(3 downto 0);
        aluopse <= '0'; ryimmed<='0'; wr<='0';  regindir<='1';
        aluop <= "10110";
        
      when "1001" =>
        aluoptodram<= "1001";
        rdx <= instruction(7 downto 4);
        rdy <= instruction(3 downto 0);
        aluopse <= '0'; ryimmed<='0'; wr<='0';  regindir<='1';
        aluop <= "11111";
             
      when "1010" =>
        aluoptodram<= "1010";
        rdx <= instruction(11 downto 8);
         aluopse <= '0'; ryimmed<='0'; wr<='0'; regindir<='0';
         rlsaddress <= instruction(7 downto 0);
         aluop <= "10111";
         
      when "1011" =>
        aluoptodram<= "1011";
        rdx <= instruction(11 downto 8);
         aluopse <= '0'; ryimmed<='0'; wr<='0'; regindir<='0';
         rlsaddress <= instruction(7 downto 0);
         aluop <= "11111";
         
         
             
        when "1100" =>
          aluopse <= '0'; ryimmed<='0'; wr<='0';  regindir<='0';
          PC <= instruction(7 downto 0);
          
          rlsaddress <= "XXXXXXXX";
          rdx <= instruction(11 downto 8);  
          aluoptodram<= "1100";
          aluop <="10101";
          
         when "1101" =>
          aluoptodram<= "1101";
          rdx <= instruction(7 downto 4);
          aluopse <= '1'; ryimmed<='0'; wr<='0';  regindir<='0';
          rlsaddress <= "XXXXXXXX";
          aluop <="10010";
          offset<=instruction(3 downto 0);
          PC <=Pci;
          
        when "1110" =>
          aluoptodram <= "1110";
          rdx <= instruction(7 downto 4);
          aluopse<='1';  ryimmed<='0'; wr<='0'; regindir<='0';
          rlsaddress <= "XXXXXXXX";
          aluop <="10011";
          offset<=instruction(3 downto 0);
          Pc<=Pci;
          
        when "1111" =>
          aluoptodram <= "1111";
          
          --PC <= PCd;
          aluopse<='0';  ryimmed<='0'; wr<='0'; regindir<='0';
          rlsaddress <= "XXXXXXXX";
          aluop <="10100";
          offset<="XXXX";  
          if(interrupt=1) then 
            --interrupt:=0;
            tmp4:=1;
          end if;
          
        when others =>
          null;
          
          
      end case;
      
    end if;
    
    -----------------------------------------------
      if(irq0='1' or irq1='1' or irq2='1' or irq3='1') then

      if((statusreg and "00001111")="00001111") then
        statusreg:= statusreg and "11110000";       --Once the ISR starts the interrupts should be disabled
	if(irq0='1') then int0:=1; end if;
	if(irq1='1') then int1:=1; end if;
	if(irq2='1') then int2:=1; end if;
	if(irq3='1') then int3:=1; end if; 
        PCd:=Pci;
        tmp1:=1;
        interrupt:=1;  
      end if;
      end if;
    end if;
    end process wrr;      ---process ends here
    
  end architecture decod;   --architecture body ends here
