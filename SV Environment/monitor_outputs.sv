import OOP_tb_pkg::*;

class monitor_outputs;

    mailbox out_mbx;
    mailbox out_mbx_cov;

    virtual intf vif;

    function new (virtual intf vif ,mailbox out_mbx, mailbox out_mbx_cov);
        this.out_mbx = out_mbx;
        this.out_mbx_cov=out_mbx_cov;
        
        this.vif=vif;
    endfunction



    task run;
        forever
        begin
            alu_trans trans;
            trans=new();
            @(posedge vif.clk);   
                trans.C= vif.C;
                out_mbx.put(trans);
                out_mbx_cov.put(trans);
        end
    endtask

endclass