----------------------------------------------------------------------------------
-- Engineer		: MUHAMMED KOCAOĞLU
-- E-mail  		: mdkocaoglu@gmail.com
-- VHDL DIALECT	: VHDL '2008
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.linked_list_pkg.all;

entity tb_linked_list is
end entity;

architecture sim of tb_linked_list is
begin

    process is
        variable list_instance : linked_list_t;
    begin
        list_instance.init_linked_list;
        wait for 50 ns;
        list_instance.push_back(1);
        list_instance.push_back(7);
        list_instance.push_back(5);
        list_instance.push_back(9);
            
        wait for 50 ns;

        list_instance.Push_front(x"ad");
        list_instance.Push_front(87);
        list_instance.Push_front(14);
        list_instance.Push_front(64);
        list_instance.Push_front(17);

        wait for 50 ns;
        
        report "popping back " & integer'image(list_instance.pop_back);
        report "popping back " & integer'image(list_instance.pop_back);
        report "popping back " & integer'image(list_instance.pop_back);

        wait for 50 ns;

        while not list_instance.is_empty loop
           report "popping front " & integer'image(list_instance.pop_front);
        end loop;

        --report "count " & integer'image(list_instance.get_count); -- should be zero
        list_instance.print_count;

        list_instance.Push_front(x"cde");
        list_instance.Push_front(45);
        list_instance.Push_front(87);
        list_instance.Push_front(64);
        list_instance.Push_front(34);
        list_instance.Push_front(19);

        wait for 50 ns;

        list_instance.print_count;

        while not list_instance.is_empty loop
            report "popping back " & integer'image(list_instance.pop_back);
        end loop; 


        list_instance.push_front(x"e1");
        report "popping front " & integer'image(list_instance.pop_back);
        list_instance.push_back(x"ab");
        report "popping front " & integer'image(list_instance.pop_front);

        list_instance.print_count;

        wait for 50 ns;
        std.env.stop;
    end process;

end architecture;
