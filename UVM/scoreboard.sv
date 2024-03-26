import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;

`uvm_component_utils(scoreboard)

	uvm_analysis_imp #(seq_item,scoreboard) analysis_imp;
	ALU_reference_model ref_model;
	
	seq_item pkt_qu[$];

	logic signed [5:0] expected_output;
	logic signed [5:0] output_queue[$];
	
	function new (string name = "scoreboard", uvm_component parent=null);
		super.new(name,parent);
		analysis_imp=new("analysis_imp",this);
		ref_model=new();
	endfunction

	function void write (seq_item pkt);
		pkt_qu.push_back(pkt);
	endfunction
	
  virtual task run_phase(uvm_phase phase);
    seq_item pkt;
    
    forever begin
      	wait(pkt_qu.size() > 0);
      	pkt = pkt_qu.pop_front();
      	
		ref_model.set(pkt.A,pkt.B,pkt.a_op,pkt.b_op,pkt.a_en,pkt.b_en,pkt.ALU_en,pkt.rst_n);
    	ref_model.execute();
		expected_output = ref_model.get_output();
		output_queue.push_back(expected_output);
        
		wait(output_queue.size() > 1);
		
    	if(pkt.rst_n==0)
			expected_output=0;
        
		if(pkt.C==output_queue.pop_front())
        	`uvm_info(get_type_name(),$sformatf("------ :: SUCCESS       :: ------"),UVM_LOW)      
      
        else
			begin
				`uvm_error(get_type_name(),"------ :: FAILED :: ------")
				`uvm_info(get_type_name(),$sformatf("......   input A= %0b    ,   input B= %0b   ......",pkt.A,pkt.B),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("%t CASE FAILED:  expected outupt= %0d    ,   current output= %0d\n",$time,expected_output,pkt.C),UVM_LOW)
				`uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
			end
      end

  endtask  
endclass 