----------------------------------------------------------------------------------
-- Engineer		: MUHAMMED KOCAOĞLU
-- E-mail  		: mdkocaoglu@gmail.com
-- VHDL DIALECT	: VHDL '2008
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package linked_list_pkg is
    type linked_list_t is protected
        procedure init_linked_list;
        procedure push_front(din : in integer);
        procedure push_front(din : in std_logic_vector);
        procedure push_back(din  : in integer);
        procedure push_back(din  : in std_logic_vector);
        impure function pop_front return integer;
        impure function pop_back  return integer;
        impure function is_empty  return boolean;
        impure function get_count return integer;
        procedure print_count;
    end protected;
end package linked_list_pkg;

package body linked_list_pkg is

    type linked_list_t is protected body

        type linked_list_item_t; 
        type ptr_t is access linked_list_item_t;
        type linked_list_item_t is record
            PrevAddr : ptr_t;
            Data     : integer;
            NextAddr : ptr_t;
        end record;

        variable tail  : ptr_t;
        variable head  : ptr_t;
        variable count : integer;

        procedure init_linked_list is
        begin
            count := 0;
            report "linked list is initalized";
        end procedure;

        procedure push_back(din : in integer) is
            variable new_item       : ptr_t;
            variable node           : ptr_t;
        begin
            report "pushing back " & integer'image(din);
            new_item      := new linked_list_item_t;
            new_item.Data := din;
            if count = 0 then
                tail  := new_item;
                head  := new_item;
                count := 1;
            else
                count         := count + 1;
                node          := head;
                node.NextAddr := new_item;
                head          := head.NextAddr;
                head.PrevAddr := node;
            end if;
        end procedure;

        procedure push_back(din : in std_logic_vector) is
        begin
            push_back(to_integer(unsigned(din)));
        end procedure;

        procedure push_front(din : in integer) is
            variable new_item        : ptr_t;
            variable node            : ptr_t;
        begin
            report "pushing front " & integer'image(din);
            new_item      := new linked_list_item_t;
            new_item.Data := din;
            if count = 0 then
                tail  := new_item;
                head  := new_item;
                count := 1;
            else
                count := count + 1;
                node  := tail;
                tail  := new_item;
                tail.NextAddr := node;
                tail.NextAddr.PrevAddr := tail;
            end if;
        end procedure;

        procedure push_front(din : in std_logic_vector) is
        begin
            push_front(to_integer(unsigned(din)));
        end procedure;
        
        impure function pop_front return integer is
            variable node : ptr_t;
            variable dout : integer;
        begin
            count := count - 1;
            node  := tail;
            tail  := tail.NextAddr;
            dout  := node.Data;
            deallocate(node);
            return dout;
        end function;

        impure function pop_back return integer is
            variable node : ptr_t;
            variable dout : integer;
        begin
            count := count - 1;
            node  := head;
            head  := head.PrevAddr;
            dout  := node.Data;
            deallocate(node);
            return dout;
        end function;

        impure function is_empty return boolean is
        begin
            return count = 0;
        end;
        
        impure function get_count return integer is
        begin
            return count;
        end function;

        procedure print_count is 
        begin
            report "there are " & integer'image(count) & " elements in linked list";
        end procedure;

    end protected body;

end package body linked_list_pkg;