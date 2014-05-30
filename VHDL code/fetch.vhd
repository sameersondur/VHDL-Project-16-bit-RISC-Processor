
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;


------------------------ Entity Declaration---------------------
entity fetch is
	port ( clk : in std_logic;
		  rst : in std_logic; 
		  ctrl : in std_logic;
		  pc_in : in std_logic_vector(7 downto 0);
		  pc_out : out std_logic_vector(7 downto 0);
		  instruction : out std_logic_vector (15 downto 0);
		  clk_out: out std_logic  					);
end fetch; 
--------------------------------------------------------------------

-------------------Architecture Body Declaration-----------------------
architecture arch_fetch of fetch is 

signal pcout :  std_logic_vector(7 downto 0);

  -----------component declaration------------------------
  component program_counter is
		port( 	
		clk : in std_logic;
		PC_in : in std_logic_vector(7 downto 0);  
		rst_bar: in std_logic; --Active low reset signl
		PC_ctrl : in std_logic;
		PC_out:  out std_logic_vector(7 downto 0);
		clk_out : out std_logic					);
  end component  program_counter;

  component instruction_memory is 
    port( pc: in std_logic_vector(7 downto 0);
        instruction: out std_logic_vector(15 downto 0));  
  end component instruction_memory;
  ---------------------------------------------------------

begin --achitecture starts here
p_c : program_counter port map(clk, pc_in, rst, ctrl, pcout, clk_out);

i_m : instruction_memory port map(pcout, instruction);

pc_out <= pcout;

end architecture arch_fetch ; -- architecture ends here
