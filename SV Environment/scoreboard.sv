import OOP_tb_pkg::*;

class scoreboard;

    mailbox in_mbx,out_mbx;
    
    int checker_count;
    int successed,failed;
    ALU_reference_model ref_model=new();
    
    function new(mailbox in_mbx, mailbox out_mbx);
        this.in_mbx=in_mbx;
        this.out_mbx=out_mbx;
    endfunction

    task main_checker();

        bit signed   [4:0] A_scb   , B_scb;

        logic signed [5:0] C_ref,expected_output;

        bit signed   [4:0] input_queue[$];
        logic signed [5:0] output_queue[$];

        alu_trans in_trans;
        alu_trans out_trans;
        
        forever
        begin
            in_mbx.get(in_trans);
            out_mbx.get(out_trans);
            
             
            input_queue.push_back(in_trans.A);
            input_queue.push_back(in_trans.B);                
            
            ref_model.set(in_trans.A,in_trans.B,in_trans.a_op,in_trans.b_op,in_trans.a_en,in_trans.b_en,in_trans.ALU_en,in_trans.rst_n);
            ref_model.execute();
            expected_output = ref_model.get_output();
            output_queue.push_back(expected_output);
        
            if (input_queue.size()!=0 && output_queue.size()!=0)
            begin
                checker_count +=1;
                
                A_scb=input_queue.pop_front;
                B_scb=input_queue.pop_front;
                
                C_ref=output_queue.pop_front;

                
                
                if (in_trans.rst_n == 0)
                    C_ref=0;

                if (out_trans.C == C_ref)
                    begin
                        //$display ("CASE %0d SUCCESS: expected outupt= %0d    ,   current output= %0d\n",checker_count,C_ref,out_trans.C);
                        successed+=1;
                    end
                    else
                        begin
                        $display ("......   input A= %0b    ,   input B= %0b   ......",A_scb,B_scb);
                        $display ("%t CASE %0d FAILED:  expected outupt= %0d    ,   current output= %0d\n",$time,checker_count,C_ref,out_trans.C);
                        failed+=1;
                        end
            end

        end


    endtask
endclass