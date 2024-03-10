import OOP_tb_pkg::*;

class monitor_inputs;

        mailbox in_mbx;
        mailbox in_mbx_cov;

        virtual intf vif;

        function new (virtual intf vif , mailbox in_mbx, mailbox in_mbx_cov);
            this.in_mbx = in_mbx;
            this.in_mbx_cov = in_mbx_cov;
            this.vif=vif;
        endfunction


        task run;
            forever
            begin
                alu_trans trans;
                trans=new();
                
                @(posedge vif.clk);  
                    trans.A= vif.A;
                    trans.B= vif.B;
                    trans.a_op= vif.a_op;
                    trans.b_op = vif.b_op;
                    trans.a_en= vif.a_en;
                    trans.b_en = vif.b_en;
                    trans.ALU_en = vif.ALU_en;
                    trans.rst_n = vif.rst_n;
                    
                    in_mbx.put(trans);
                    in_mbx_cov.put(trans);                
            end
        endtask

    endclass