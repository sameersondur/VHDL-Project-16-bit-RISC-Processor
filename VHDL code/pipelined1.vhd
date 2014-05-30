Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

-------------ENTITY------------------
entity pipeline1 is
  port(clk: in std_logic);
    
  end pipeline1;
------------------------------------  
  
  architecture pipeline1arch of pipeline1 is
    --=======================SIGNALS===============================
    signal pc_outi,pc_out, pctofetch,pcfromdeci,pcfromdeco, aluout,rlsaddressfromramo,rlsaddressfromaluo,rxdatao,rydatao: std_logic_vector(7 downto 0);     --all the i/o references are w.r.t the latches
    signal instructi, instructo : std_logic_vector(15 downto 0);
    signal  rst, ctrl, clkout ,zflg ,aluopsei, wri, ryimmedi,regindiri, aluopseo, wro, ryimmedo,regindiro, wrofram, wrfloating, Reg_Ind_Wr, regindirotoalui, regindirotoaluo: std_logic;
    signal immedi, rlsaddressi,immedo, rlsaddresso ,rxdata, rydata, wrbkdata: std_logic_vector(7 downto 0);
    signal rdxi,rdyi, rdxo,rdyo ,aluoptodrami, offseti, aluoptodramo, offseto,rxorder, ryorder , wrindex ,regwrite,aluoptodramtowrb: std_logic_vector(3 downto 0); 
    signal aluopi, aluopo: std_logic_vector(4 downto 0);
    
    
    --=============================================================
    
    --================COMPONENTS===================================
    --------fetch--------------------fetch--------------------fetch------------
    component fetch is
	port ( clk : in std_logic;
		  rst : in std_logic; 
		  ctrl : in std_logic;
		  pc_in : in std_logic_vector(7 downto 0);
		  pc_out : out std_logic_vector(7 downto 0);
		  instruction : out std_logic_vector (15 downto 0);
		  clk_out: out std_logic  					);
end component fetch;


component latchfetch is
  port(pc_outi : in std_logic_vector(7 downto 0);
		  instructioni : in std_logic_vector (15 downto 0);
      clk,pctake: in std_logic;
      pc_out : out std_logic_vector(7 downto 0);
		  instruction : out std_logic_vector (15 downto 0));
end component latchfetch;

  ---------decode-------------------------decode-------------------------decode----------------
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
    
    
    
     
     component latch2dec is
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
end  component latch2dec; 

---------------EXECUTE-----------------------------EXECUTE-----------------------------EXECUTE--------------

    COMPONENT ram is 
  port(
    Rdx, Rdy: in std_logic_vector(3 downto 0);
    rxorder,ryorder:out std_logic_vector(3 downto 0);
    wrindex: in std_logic_vector(3 downto 0);
    Rx, Ry,rlsaddresso: out std_logic_vector(7 downto 0);
     wr,clk,regindir: in std_logic;      --take wr from pratik
    regindiro: out std_logic;
     wrb,rlsaddressi:in std_logic_vector(7 downto 0)
    );
 end component ram;


  component aluproj1 is
  port(
    Rx,Ry,Immed,PCi,rlsaddressi: in std_logic_vector(7 downto 0);
    aluop: in std_logic_vector(4 downto 0);
    aluoptodrami :in std_logic_vector(3 downto 0);
    ryimm,clk, regindiri: in std_logic;
    rxorder,ryorder,offset: in std_logic_vector(3 downto 0);
    rwrite,aluoptodramo : out std_logic_vector(3 downto 0);
    aluout,PCo, rlsaddresso,rxo,ryo: out std_logic_vector(7 downto 0);
    zflag, wren,pctake,regindiro: out std_logic
  );
end component aluproj1;



-------------------WRITE BACK----------------------------------------------WRITE BACK---------------------------


COMPONENT writeback is 
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
end COMPONENT writeback;

  --===============================================================
  
  --====================ARCHITECTURE===============================
  begin
    
  c0: fetch port map(clk, rst, ctrl, pctofetch, pc_outi,instructi,clkout);
  c1: latchfetch port map(pc_outi,instructi,clk,ctrl, pc_out, instructo);
  c2: decoder port map(clk,zflg,instructo,pc_out,immedi,rlsaddressi,rdxi, rdyi, pcfromdeci, aluoptodrami, offseti, aluopi,aluopsei, wri, ryimmedi,regindiri); 
  c3: latch2dec port map(immedi, rlsaddressi,rdxi,rdyi,pcfromdeci,aluoptodrami, offseti, aluopi, aluopsei, wri, ryimmedi,regindiri,ctrl,clk, immedo, rlsaddresso,rdxo,rdyo,pcfromdeco,aluoptodramo, offseto, aluopo, aluopseo, wro, ryimmedo,regindiro);
  c4: ram port map(rdxo,rdyo,rxorder,ryorder,wrindex,rxdata,rydata,rlsaddressfromramo,wrofram,clk,regindiro,regindirotoalui, wrbkdata,rlsaddresso );
  c5: aluproj1 port map(rxdata,rydata,immedo, pcfromdeco,rlsaddressfromramo, aluopo, aluoptodramo,ryimmedo,clk,regindirotoalui,rxorder, ryorder, offseto,regwrite, aluoptodramtowrb,aluout,pctofetch,rlsaddressfromaluo,rxdatao,rydatao, zflg, wrfloating,ctrl ,regindirotoaluo   );
  c6: writeback port map(clk,aluoptodramtowrb,regindirotoaluo,regwrite, rlsaddressfromaluo, rydatao,rxdatao,aluout,wrbkdata,wrofram,wrindex  );
    
    
  end architecture pipeline1arch;
    
    
    
  