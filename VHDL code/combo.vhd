Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

------------Entity Declaration--------------------------------------------------------
entity combined is 
  port (clk: in std_logic;
  instruction : in std_logic_vector(15 downto 0);
  Pcifetct,wrdatatoreg: in std_logic_vector(7 downto 0);
  wrback: in std_logic;
  wrindextoreg :in std_logic_vector(3 downto 0);
  rorder ,aluoptodram:out std_logic_vector(3 downto 0);
  PC,aluout,rxtodmem,rymux,rlsaddress : out std_logic_vector(7 downto 0);
  pctake,wren,regindir:out std_logic);
 end combined;
 -------------------------------------------------------------------------------------
  
 ------------Architectire Body Declaration--------------------------------------------- 
  architecture volvo of combined is
   --------------signals--------------------------------------------
    signal rdx,rdy, offset,ryorder,rxorder,wrindex: std_logic_vector(3 downto 0);
    signal zflg, aluopse, wr, ryimmed : std_logic;
    signal immed, Rx, Ry ,PCtmp: std_logic_vector(7 downto 0);
    signal aluop:std_logic_vector(4 downto 0);
    signal wrb : std_logic_vector(7 downto 0);
    
   ---------Components----------------------------------------------
    component decoder is
    port(clk, zflg: in std_logic;
       instruction: in std_logic_vector(15 downto 0);
       PCi: in std_logic_vector(7 downto 0);
       immed, rlsaddress : out std_logic_vector(7 downto 0);
       rdx,rdy : out std_logic_vector(3 downto 0);
       PC : out std_logic_vector(7 downto 0);   -- output PC
       aluoptodram, offset: out std_logic_vector(3 downto 0); -- offset for the jump if zero and not zero, aluopdraam for the dram operations
       aluop: out std_logic_vector(4 downto 0);
       
       aluopse, wr, ryimmed,regindir: out std_logic);  -- pctake is the signal to accept the new PC
     end component decoder;
     
     component ram is 
    port(
      Rdx, Rdy: in std_logic_vector(3 downto 0);
      rxorder,ryorder:out std_logic_vector(3 downto 0);
      wrindex: in std_logic_vector(3 downto 0);
      Rx, Ry: out std_logic_vector(7 downto 0);
      wr,clk: in std_logic;
      wrb: std_logic_vector(7 downto 0)
      );
    end component ram; 
 
    component aluproj1 is
    port(
      Rx,Ry,Immed,PCi: in std_logic_vector(7 downto 0);
      aluop: in std_logic_vector(4 downto 0);
      ryimm,clk: in std_logic;
      rxorder,ryorder,offset: in std_logic_vector(3 downto 0);
      rwrite : out std_logic_vector(3 downto 0);
      aluout,PCo: out std_logic_vector(7 downto 0);
      zflag, wren,pctake: out std_logic
     );
    end component aluproj1;
    -------------------------------------------------------------------------------------------------------------------------------------------------
    
    begin   --architecture begins here
         
      ----------------Port Maps  --------------------------------------------------------------------
      Co: decoder port map(clk,zflg,instruction, Pcifetct,immed, rlsaddress,rdx,rdy,PCtmp, aluoptodram, offset, aluop, aluopse, wr, ryimmed ,regindir);
        
      C1: ram port map(rdx,rdy,rxorder,ryorder,wrindextoreg,rx,ry,wrback,clk,wrdatatoreg);
        
      C2: aluproj1 port map(rx,ry,immed,PCtmp,aluop,ryimmed,clk,rxorder,ryorder,offset,rorder,aluout,PC,zflg,wren,pctake);
        
      rxtodmem<=Rx;
      rymux <= Ry;
    end architecture volvo;
      
  



  
    
    
    
    