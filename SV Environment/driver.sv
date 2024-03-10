import OOP_tb_pkg::*;

class driver;
    
    virtual intf vif;

    mailbox tr_drv_mbx;
    
    function new (virtual intf vif , mailbox tr_drv_mbx) ;
        this.vif = vif;
        this.tr_drv_mbx= tr_drv_mbx;
    endfunction

    task reset;
        
        vif.clk=1'b0;
        vif.rst_n=1'b0;
        
        repeat(5)
        begin
            @(posedge vif.clk);               
        end
        
        vif.rst_n=1'b1;

    endtask
    
    task run;
    forever 
    begin
        alu_trans trans;
        tr_drv_mbx.get(trans);

        @(posedge vif.clk);        
            vif.A<= trans.A;
            vif.B<= trans.B;
            vif.a_op<= trans.a_op;
            vif.b_op <= trans.b_op;
            vif.a_en<= trans.a_en;
            vif.b_en <= trans.b_en;
            vif.ALU_en <= trans.ALU_en;
            vif.rst_n <= trans.rst_n; 
    end
    endtask
endclass