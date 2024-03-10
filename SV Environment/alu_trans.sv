class alu_trans;
    rand    bit    signed   [4:0]     A,B;
    rand    bit             [2:0]     a_op;
    rand    bit             [1:0]     b_op;
    rand    bit                       a_en,b_en;
    rand    bit                       ALU_en;
    rand    bit                       rst_n;

            logic  signed   [5:0]     C;


    localparam	RST_OFF_DIST =98,
                ALU_OFF_DIST=10,
                AOP_ON_DIST=199,
                BOP_ON_DIST=299,
                OP_ON_DIST=99;

    constraint rst_assertion {
        rst_n dist {1:=RST_OFF_DIST  ,0:=100-RST_OFF_DIST };
    }

    constraint alu_enable_assertion {
        ALU_en dist {0:=ALU_OFF_DIST  ,1:=100-ALU_OFF_DIST };
    }
   
    constraint a_b_enable_assertion {
        {a_en,b_en} dist {0:=100-OP_ON_DIST  ,[1:3]:=OP_ON_DIST };
    }

    constraint a_op_assertion {
        a_op dist {[0:6]:=AOP_ON_DIST  ,7:=200-AOP_ON_DIST };
    }
    
    constraint b_op_assertion { (a_en==0 && b_en ==1) ->
                                b_op dist {[0:2]:=BOP_ON_DIST  ,3:=300-BOP_ON_DIST };
    }

/*
    constraint A_assertion {
        A dist {[0:2]:=ENABLE_DIST , 15:=20 , 31:=20};
    }

    constraint B_assertion {
        B dist {[0:2]:=ENABLE_DIST  ,3:=100-ENABLE_DIST };
    }
*/
endclass