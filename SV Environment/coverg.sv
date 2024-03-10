import OOP_tb_pkg::*;

    class coverg;

    mailbox in_mbx,out_mbx;

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


    function new(mailbox in_mbx, mailbox out_mbx);
        this.in_mbx=in_mbx;
        this.out_mbx=out_mbx;
        cg=new();
    endfunction

    task main();


        alu_trans in_trans;
        alu_trans out_trans;


        forever
        begin
            in_mbx.get(in_trans);
            out_mbx.get(out_trans);
            
            A=in_trans.A;
            B=in_trans.B;
            a_op=in_trans.a_op;
            b_op=in_trans.b_op;
            a_en=in_trans.a_en;
            b_en=in_trans.b_en;
            ALU_en=in_trans.ALU_en;
            rst_n=in_trans.rst_n;

            C=out_trans.C;
            
            cg.sample();
        end

    endtask

endclass
