import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class test extends uvm_test;

`uvm_component_utils(test)

	environment env;
	random_sequence random_seq;

	function new (string name = "test", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

			env=environment::type_id::create("env",this);
	endfunction

	virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);

		random_seq=random_sequence::type_id::create("random_seq",this);
		phase.raise_objection(this);
			random_seq.start(env.agnt.seqr);
		phase.drop_objection(this);
	endtask

endclass