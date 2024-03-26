import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class environment extends uvm_env;

`uvm_component_utils(environment)

	agent agnt;
	scoreboard scrbd;
	coverage covg;

	function new (string name = "environment", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

			agnt=agent::type_id::create("agnt",this);
			scrbd=scoreboard::type_id::create("scrbd",this);
			covg=coverage::type_id::create("covg",this);
	endfunction


	virtual function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);

		agnt.mon.mon_analysis_port.connect(scrbd.analysis_imp);
		agnt.mon.mon_analysis_port.connect(covg.analysis_export);

	endfunction

endclass