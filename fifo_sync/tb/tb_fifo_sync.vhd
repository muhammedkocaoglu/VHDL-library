----------------------------------------------------------------------------------
-- Engineer: Muhammed KOCAOĞLU
-- E-mail  : mdkocaoglu@gmail.com

----------------------------------------------------------------------------------
library IEEE;
library work;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.ram_pkg.all;
use work.linked_list_pkg.all;

entity tb_fifo_sync is
   generic (
      FIFO_DEPTH : natural := 40;
      DATA_WIDTH : natural := 8
   );
end tb_fifo_sync;

architecture Behavioral of tb_fifo_sync is

component fifo_sync is
   generic (
      FIFO_DEPTH : natural := 40;
      DATA_WIDTH : natural := 8
   );
   port (
      clk     : in std_logic;
      rst_n   : in std_logic;
      wr_en_i : in std_logic;
      data_i  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
      rd_en_i : in std_logic;
      data_o  : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      full_o  : out std_logic;
      empty_o : out std_logic;
      count_o : out std_logic_vector(clogb2(FIFO_DEPTH) downto 0)
   );
end component;

signal clk     : std_logic := '1';
signal rst_n   : std_logic;
signal wr_en_i : std_logic := '0';
signal data_i  : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal rd_en_i : std_logic := '0';
signal data_o  : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal full_o  : std_logic;
signal empty_o : std_logic;
signal count_o : std_logic_vector(clogb2(FIFO_DEPTH) downto 0);

shared variable list_instance : linked_list_t;

begin

   clk   <= not clk after 5 ns;

   process begin 
      rst_n <= '0';
      list_instance.init_linked_list;
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      rst_n <= '1';

      for i in 0 to 100 loop
         wait until falling_edge(clk);
         if not full_o then 
            list_instance.push_back(i);
            data_i   <= std_logic_vector(to_unsigned(i, data_i'length));
            wr_en_i  <= '1';
         else
            wr_en_i  <= '0';
         end if;
      end loop;

      wait until falling_edge(clk);
      assert list_instance.get_count = FIFO_DEPTH
         report "unexpected value"
         severity error;

      wait until falling_edge(clk);
      for i in 0 to 100 loop
         if not empty_o then 
            rd_en_i  <= '1';
            wait until falling_edge(clk);
            assert list_instance.pop_front = to_integer(unsigned(data_o))
               report "unexpected value"
               severity error;
         else
            rd_en_i  <= '0';
         end if;
      end loop;    
         
      wait until falling_edge(clk);
      assert list_instance.get_count = to_integer(unsigned(count_o))
         report "unexpected value"
         severity error;

      wait for 100 ns;
      std.env.stop;
   end process;

   fifo_sync_inst : fifo_sync 
      generic map (
         FIFO_DEPTH  => FIFO_DEPTH,
         DATA_WIDTH  => DATA_WIDTH
      )
      port map (
         clk         =>  clk,     
         rst_n       =>  rst_n,   
         wr_en_i     =>  wr_en_i, 
         data_i      =>  data_i,  
         rd_en_i     =>  rd_en_i, 
         data_o      =>  data_o,  
         full_o      =>  full_o,  
         empty_o     =>  empty_o, 
         count_o     =>  count_o 
      );

end Behavioral;
