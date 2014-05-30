
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

----------Entity Declaration------------------
entity vande is
  port (
  clk: in std_logic
  );
end entity vande;
-----------------------------------------------

----------------Architecture Body Declaration---------------------------------------------------------------  
  architecture mataram of vande is
    ------------ signal declarations------------------------------------------------------------------------
    signal rst,ctrl, clki,clkout, wrback,pctake,wren,regindir : std_logic;
    signal pctodefet,pcfede, wrdatatoreg, aluout,rxtodmem,rymux,rlsaddress : std_logic_vector(7 downto 0);
    signal instruction :std_logic_vector(15 downto 0);
    signal wrindextoreg ,rorder ,aluoptodram: std_logic_vector(3 downto 0);     
    -------------------------------------------------------------------------------------------------------
  ---------------- component declarations----------------------------------------------      
  component fetch is
	port ( clk : in std_logic;
		  rst : in std_logic; 
		  ctrl : in std_logic;
		  pc_in : in std_logic_vector(7 downto 0);
		  pc_out : out std_logic_vector(7 downto 0);
		  instruction : out std_logic_vector (15 downto 0);
		  clk_out: out std_logic  					);
  end component fetch; 


  component combined is 
    port (clk: in std_logic;
      instruction : in std_logic_vector(15 downto 0);
      Pcifetct,wrdatatoreg: in std_logic_vector(7 downto 0);
      wrback: in std_logic;
      wrindextoreg :in std_logic_vector(3 downto 0);
      rorder ,aluoptodram:out std_logic_vector(3 downto 0);
      PC,aluout,rxtodmem,rymux,rlsaddress : out std_logic_vector(7 downto 0);
      pctake,wren,regindir:out std_logic);
  end component combined;
 
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
 ----------------------------------------------------------------------------------------
 
 
 begin      --architecture begins here
    
  c0: fetch port map(clk,rst,ctrl,pctodefet,pcfede,instruction,clkout);
    
  c1: combined port map(clk,instruction,pcfede,wrdatatoreg,wrback,wrindextoreg,rorder,aluoptodram,pctodefet,aluout,rxtodmem,rymux,rlsaddress,ctrl,wren,regindir);
    
  c2: writeback port map(clk,aluoptodram,regindir,rorder,rlsaddress,rymux,rxtodmem,aluout,wrdatatoreg,wrback,wrindextoreg);  
 
 end architecture mataram;  --architecture ends here
  