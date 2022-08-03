----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/03/2022 07:21:39 PM
-- Design Name: 
-- Module Name: fifo_sync - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package ram_pkg is
    function clogb2 (depth: in natural) return integer;
end ram_pkg;

package body ram_pkg is

function clogb2( depth : natural) return integer is
variable temp    : integer := depth;
variable ret_val : integer := 0;
begin
    while temp > 1 loop
        ret_val := ret_val + 1;
        temp    := temp / 2;
    end loop;
return ret_val;
end function;

end package body;


library IEEE;
library work;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.ram_pkg.all;

entity fifo_sync is
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
end fifo_sync;

architecture Behavioral of fifo_sync is

    type mem_type is array (0 to FIFO_DEPTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal fifo_mem : mem_type;

   --  attribute ram_style             : string;
   --  attribute ram_style of fifo_mem : signal is "block"; -- "distributed", "block", "registers", "ultra"

    signal wr_ptr_Int    : integer range 0 to FIFO_DEPTH - 1;
    signal rd_ptr_Int    : integer range 0 to FIFO_DEPTH - 1;
    signal dataCount_Int : integer range 0 to FIFO_DEPTH;

begin

    count_o <= std_logic_vector(to_unsigned(dataCount_Int, count_o'length));

    process (all)
    begin
        if dataCount_Int = FIFO_DEPTH then
            full_o <= '1';
        else
            full_o <= '0';
        end if;

        if dataCount_Int = 0 then
            empty_o <= '1';
        else
            empty_o <= '0';
        end if;
    end process;

    P_WRITE : process (clk, rst_n)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                wr_ptr_Int <= 0;
            else
                if wr_en_i = '1' then
                    fifo_mem(wr_ptr_Int) <= data_i;
                    if wr_ptr_Int = FIFO_DEPTH - 1 then
                        wr_ptr_Int <= 0;
                    else
                        wr_ptr_Int <= wr_ptr_Int + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    P_READ : process (clk, rst_n)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                rd_ptr_Int <= 0;
            else
                if rd_en_i = '1' then
                    data_o <= fifo_mem(rd_ptr_Int);
                    if rd_ptr_Int = FIFO_DEPTH - 1 then
                        rd_ptr_Int <= 0;
                    else
                        rd_ptr_Int <= rd_ptr_Int + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (clk, rst_n)
        variable wr_rd : std_logic_vector(1 downto 0);
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                dataCount_Int <= 0;
                wr_rd := "00";
            else
                wr_rd := wr_en_i & rd_en_i;
                case wr_rd is
                    when "01" =>
                        dataCount_Int <= dataCount_Int - 1;

                    when "10" =>
                        if dataCount_Int = FIFO_DEPTH then
                            dataCount_Int <= 0;
                        else
                            dataCount_Int <= dataCount_Int + 1;
                        end if;

                    when others =>
                        dataCount_Int <= dataCount_Int;
                end case;
            end if;
        end if;
    end process;

end Behavioral;