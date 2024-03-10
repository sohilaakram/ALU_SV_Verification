import OOP_tb_pkg::*;

class env;

    virtual intf vif;


    generator gen0;
    driver    drv0;
    monitor_inputs mon_in0;
    monitor_outputs mon_out0;
    scoreboard scb;
    coverg cov0;

    mailbox tr_drv_mbx;
    mailbox in_mbx_scb;
    mailbox out_mbx_scb;
    mailbox in_mbx_cov;
    mailbox out_mbx_cov;

    int count;
    
    function new (virtual intf vif, int count);
        this.vif=vif;
        this.count=count;
        
        tr_drv_mbx = new();
        in_mbx_scb = new();
        out_mbx_scb = new();
        in_mbx_cov = new();
        out_mbx_cov = new();

        gen0 = new(tr_drv_mbx,count);
        drv0  = new(vif, tr_drv_mbx);
        mon_in0 = new(vif,in_mbx_scb,in_mbx_cov);
        mon_out0 = new(vif,out_mbx_scb,out_mbx_cov);
        scb =new(in_mbx_scb,out_mbx_scb);
        cov0 = new(in_mbx_cov,out_mbx_cov);

    endfunction

    task run_test();
        
        drv0.reset();
        
        fork
            gen0.main();
            drv0.run();
            mon_in0.run();
            mon_out0.run();
            cov0.main();
            scb.main_checker();
        
        join_any

            wait (gen0.done.triggered);
            wait(scb.checker_count==count);
            $display("************************************************");
            $display("Reporting:");
            $display("----------\n");
            $display("TOTAL NUMBER OF TEST CASES: %0d \n",count);
            $display("NUMBER OF SUCCEEDED CASES: %0d \n",scb.successed);
            $display("NUMBER OF FAILED CASES: %0d \n",scb.failed);
            $display("************************************************");
    endtask

endclass