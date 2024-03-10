import OOP_tb_pkg::*;

class generator;
    
    rand alu_trans trans;

    mailbox tr_drv_mbx;

    int count;

    event done;

    function new(mailbox tr_drv_mbx, int count);
        this.tr_drv_mbx=tr_drv_mbx;
        this.count=count;
    endfunction

    task main();
        repeat (count)
        begin
            //creating object of the transaction class
            trans=new();

            //randomizing the transaction
            if (!trans.randomize())
                $display("RANDOMAIZATION FAILED!");
            
            tr_drv_mbx.put(trans);
        end

        ->done;
    endtask

endclass