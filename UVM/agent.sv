import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class agent extends uvm_agent;

`uvm_component_utils(agent)

	monitor mon;
	driver driv;
	sequencer seqr;

	function new (string name = "agent", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

			mon=monitor::type_id::create("mon",this);
			driv=driver::type_id::create("driv",this);
			seqr=sequencer::type_id::create("seqr",this);
	endfunction


	virtual function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);

		driv.seq_item_port.connect(seqr.seq_item_export);
	endfunction

endclass