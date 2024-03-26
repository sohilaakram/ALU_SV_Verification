import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class coverage extends uvm_subscriber #(seq_item);

`uvm_component_utils(coverage)


    bit   signed    [4:0]     A,B;
    bit             [2:0]     a_op;
    bit             [1:0]     b_op;
    bit                       a_en,b_en;
    bit                       ALU_en;
    bit                       rst_n;

    bit   signed    [5:0]     C;


    covergroup cg;
    c_A: coverpoint A;
    c_B: coverpoint B;
    c_C: coverpoint C;
    c_a_op: coverpoint a_op;
    c_b_op: coverpoint b_op; 
    c_a_en: coverpoint a_en {
                                bins enabled = {1};
                                bins disabled = {0};
                            }
    c_b_en: coverpoint b_en {
                                bins enabled = {1};
                                bins disabled ={0};
                            }
    c_ALU_en: coverpoint ALU_en;
    c_rst_n: coverpoint rst_n;

    c_valid_a_op: cross c_a_op,c_a_en,c_b_en iff (rst_n & ALU_en){

        ignore_bins  ignore_other_sets1= binsof(c_a_en) intersect {0};
        ignore_bins  ignore_other_sets2= binsof(c_b_en) intersect {1};

        illegal_bins illegal_null = binsof(c_a_op) intersect {7} && 
                                    binsof(c_a_en) intersect {1} && 
                                    binsof(c_b_en) intersect {0};
        
    }

    c_valid_b_op1: cross c_b_op,c_a_en,c_b_en iff (rst_n & ALU_en) {

        ignore_bins  ignore_other_sets1= binsof(c_a_en) intersect {1};
        ignore_bins  ignore_other_sets2= binsof(c_b_en) intersect {0};

        illegal_bins illegal_null = binsof(c_b_op) intersect {3} && 
                                    binsof(c_a_en) intersect {0} && 
                                    binsof(c_b_en) intersect {1};
    
    }

    c_valid_b_op2: cross c_b_op,c_a_en,c_b_en iff (rst_n & ALU_en) {

        ignore_bins  ignore_other_sets1= binsof(c_a_en) intersect {0};
        ignore_bins  ignore_other_sets2= binsof(c_b_en) intersect {0};
    }

    c_no_op: cross c_a_en,c_b_en iff (rst_n & ALU_en) {

        ignore_bins  ignore_other_sets1= binsof(c_a_en) intersect {1};
        ignore_bins  ignore_other_sets2= binsof(c_b_en) intersect {1};
    }

    endgroup

	function new (string name = "coverage", uvm_component parent=null);
		super.new(name,parent);
		cg=new();
	endfunction
    
	function void write (seq_item t);
        A=t.A;
        B=t.B;
        a_op=t.a_op;
        b_op=t.b_op;
        a_en=t.a_en;
        b_en=t.b_en;
        ALU_en=t.ALU_en;
        rst_n=t.rst_n;

        C=t.C;
        
        cg.sample();
	endfunction
	

endclass