import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;

`uvm_component_utils(monitor)

	virtual intf vif;
	
	uvm_analysis_port#(seq_item) mon_analysis_port;

	function new (string name = "monitor", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		mon_analysis_port= new("mon_analysis_port",this);

		if (!uvm_config_db#( virtual intf)::get(this,"","vif",vif))
			`uvm_error(get_name(),"Can't find the interface!")
	endfunction


	virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);

		forever
		begin
			seq_item pkt;
			pkt=seq_item::type_id::create("pkt",this);

			@(posedge vif.clk )
			//capturing data
				pkt.A= vif.A;
				pkt.B= vif.B;
				pkt.a_op= vif.a_op;
				pkt.b_op = vif.b_op;
				pkt.a_en= vif.a_en;
				pkt.b_en = vif.b_en;
				pkt.ALU_en = vif.ALU_en;
				pkt.rst_n = vif.rst_n;
				pkt.C= vif.C;


			mon_analysis_port.write(pkt);

		end
	endtask

endclass