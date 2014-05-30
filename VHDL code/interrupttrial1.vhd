Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

----------Entity Declaration-----------------
entity interrupt1 is
port(clk,irq0,irq1,irq2,irq3:in std_logic
);
end interrupt1;
----------------------------------------------

---------------Architecture Body Declaration-----------------------------------------------
architecture interrupt1archi of interrupt1 is
  
  --================SIGNALS======================================
  signal pc_outi,pc_out, pctofetch,pcfromalu,pcfromdeci,pcfromdeco, aluout,rlsaddressfromramo,rlsaddressfromaluo,rxdatao,rydatao: std_logic_vector(7 downto 0);     --all the i/o references are w.r.t the latches
    signal instructi, instructo : std_logic_vector(15 downto 0);
    signal  rst, ctrl,ctrl1, clkout ,zflg ,aluopsei, wri, ryimmedi,regindiri, aluopseo, wro, ryimmedo,regindiro, wrofram, wrfloating, Reg_Ind_Wr, regindirotoalui, regindirotoaluo,put,scratchenable,extract,pctakefromscra, wrtoresolve : std_logic;
    signal immedi, rlsaddressi,immedo, rlsaddresso ,rxdata, rydata, wrbkdata,pcfromscra,regfromscra,wrbkRESOLVED: std_logic_vector(7 downto 0);
    signal rdxi,rdyi, rdxo,rdyo ,aluoptodrami, offseti, aluoptodramo, offseto,rxorder, ryorder , wrindex ,regwrite,aluoptodramtowrb,wrindexfrompcresolve,wrindextoresolve: std_logic_vector(3 downto 0); 
    signal aluopi, aluopo: std_logic_vector(4 downto 0);
  
  
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

-----------------DECODE-----------------------------------DECODE------------------

COMPONENT decoder is
  port(clk, zflg,irq0,irq1,irq2,irq3: in std_logic;
       instruction: in std_logic_vector(15 downto 0);
       PCi: in std_logic_vector(7 downto 0);
       immed, rlsaddress : out std_logic_vector(7 downto 0);
       rdx,rdy : out std_logic_vector(3 downto 0);
       PC : out std_logic_vector(7 downto 0);   -- output PC
       aluoptodram, offset: out std_logic_vector(3 downto 0); -- offset for the jump if zero and not zero, aluopdraam for the dram operations
       aluop: out std_logic_vector(4 downto 0);       
       aluopse, wr, ryimmed,regindir,put,extract, scratchenable: out std_logic);  -- pctake is the signal to accept the new PC
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
end component latch2dec; 

component scratchpad is
  port(
    clk,scratchenable,extract,put:in std_logic;
    r0i,r1i,pci: in std_logic_vector(7 downto 0);
    rout,pco:out std_logic_vector(7 downto 0);
    pctake: out std_logic
    
  
  );
end component scratchpad;

---------------------------Exrcute---------------------------Exrcute-------------------

component aluproj1 is
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
end component aluproj1;


component ram is 
  port(
    Rdx, Rdy: in std_logic_vector(3 downto 0);
    rxorder,ryorder:out std_logic_vector(3 downto 0);
    wrindex: in std_logic_vector(3 downto 0);
    Rx, Ry,rlsaddresso: out std_logic_vector(7 downto 0);
     wr,clk,regindir: in std_logic;      --take wr from pratik  --regindir is for propogation to the write back
    regindiro : out std_logic;
     wrb,rlsaddressi:in std_logic_vector(7 downto 0)
    );
 end component ram; 
 
 --------pcresolution
 
 component pcresolve is
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
end component pcresolve;
 
 
 ------------------------writeback-------------------------------
 component writeback is 
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
end component writeback;


begin     --architecure starts here
  c0: fetch port map(clk, rst, ctrl, pctofetch, pc_outi,instructi,clkout);
  c1: latchfetch port map(pc_outi,instructi,clk,ctrl, pc_out, instructo);
  c2: decoder port map(clk,zflg,irq0,irq1,irq2,irq3,instructo,pc_out,immedi,rlsaddressi,rdxi, rdyi, pcfromdeci, aluoptodrami, offseti, aluopi,aluopsei, wri, ryimmedi,regindiri,put,extract, scratchenable);
  c3: latch2dec port map(immedi, rlsaddressi,rdxi,rdyi,pcfromdeci,aluoptodrami, offseti, aluopi, aluopsei, wri, ryimmedi,regindiri,ctrl1,clk, immedo,	 rlsaddresso,rdxo,rdyo,pcfromdeco,aluoptodramo, offseto, aluopo, aluopseo, wro, ryimmedo,regindiro);	--here i have changed from ctrl to ctrl1
  c10: scratchpad port map(clk,scratchenable,extract,put,rxdata,rydata,pcfromdeci,regfromscra,pcfromscra,pctakefromscra);
  c4: ram port map(rdxo,rdyo,rxorder,ryorder,wrindexfrompcresolve,rxdata,rydata,rlsaddressfromramo,wrofram,clk,regindiro,regindirotoalui, wrbkRESOLVED,rlsaddresso );
  c5: aluproj1 port map(rxdata,rydata,immedo, pcfromdeco,rlsaddressfromramo, aluopo, aluoptodramo,ryimmedo,clk,regindirotoalui,rxorder, ryorder, offseto,regwrite, aluoptodramtowrb,aluout,pcfromalu,rlsaddressfromaluo,rxdatao,rydatao, zflg, wrfloating,ctrl1 ,regindirotoaluo  );
  c6: writeback port map(clk,aluoptodramtowrb,regindirotoaluo,regwrite, rlsaddressfromaluo, rydatao,rxdatao,aluout,wrbkdata,wrtoresolve,wrindextoresolve  );
  c7: pcresolve port map(pcfromscra,pcfromalu,pctakefromscra,ctrl1,pctofetch,ctrl,scratchenable,extract,wrtoresolve,rdxi,wrindextoresolve,regfromscra,wrbkdata,wrindexfrompcresolve,wrbkRESOLVED,wrofram );


end architecture interrupt1archi;     --architecture ends here

    
  








