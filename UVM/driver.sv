import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class driver extends uvm_driver #(seq_item);

`uvm_component_utils(driver)

	virtual intf vif;
	seq_item pkt;

	function new (string name = "driver", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#( virtual intf)::get(this,"","vif",vif))
			`uvm_error(get_name(),"Can't find the interface!")
	endfunction


	virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);

		forever
		begin
			
			seq_item_port.get_next_item(pkt);
				
				//driving signals
				@(posedge vif.clk)
					vif.A<= pkt.A;
					vif.B<= pkt.B;
					vif.a_op<= pkt.a_op;
					vif.b_op <= pkt.b_op;
					vif.a_en<= pkt.a_en;
					vif.b_en <= pkt.b_en;
					vif.ALU_en <= pkt.ALU_en;
					vif.rst_n <= pkt.rst_n; 

			seq_item_port.item_done();
		end
	endtask

endclass