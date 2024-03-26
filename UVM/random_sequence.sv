import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class random_sequence extends uvm_sequence #(seq_item);

`uvm_object_utils(random_sequence)

	seq_item pkt;

	function new (string name = "random_sequence");
		super.new(name);
	endfunction

	virtual task body();
		pkt= seq_item::type_id::create("pkt");
		
		repeat(10000)
		begin
			start_item(pkt);
			assert (pkt.randomize())
				else 
					`uvm_error(get_type_name(),"Randomization failed!")
			finish_item(pkt);
		end
	endtask

endclass