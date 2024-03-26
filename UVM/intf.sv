interface intf;
    parameter DATA_WIDTH=5;
    
    logic    signed  [DATA_WIDTH:0]      C;
    logic    signed  [DATA_WIDTH-1:0]    A,B;
    logic            [2:0]               a_op;
    logic            [1:0]               b_op;
    logic                                a_en,b_en;
    logic                                ALU_en;
    logic                                clk,rst_n;

//Clock Generation
always #10 clk=~clk;

initial 
  begin
    clk=1'b0;
    rst_n=1'b0;
    
    repeat(5)
    begin
        @(posedge clk);               
    end
    
    rst_n=1'b1;
  end

sequence add_op_check;
  ALU_en==1 && ((a_en==1  && b_en==0 && a_op == 0) || (a_en==0  && b_en==1 && (b_op == 1 || b_op==2)));
endsequence

sequence sub_op_check;
  ALU_en==1 && (a_en==1  && b_en==0) && a_op == 1;
endsequence

sequence xor_op_check;
  ALU_en==1 && ( (a_en==1  && b_en==0 && a_op == 2) || (a_en==1  && b_en==1 && b_op == 0) );
endsequence

sequence and_op_check;
  ALU_en==1 && a_en==1  && b_en==0 && (a_op == 3 || a_op==4);
endsequence

sequence or_op_check;
  ALU_en==1 && (a_en==1  && b_en==0) && a_op == 5;
endsequence

sequence subone_op_check;
  ALU_en==1 && (a_en==1  && b_en==1) && b_op == 2;
endsequence

sequence addtwo_op_check;
  ALU_en==1 && (a_en==1  && b_en==1) && b_op == 3;
endsequence

sequence xnor_op_check;
  ALU_en==1 && ((a_en==1  && b_en==0 && a_op == 6) || (a_en==1  && b_en==1 && b_op == 1 ) );
endsequence

sequence nand_op_check;
  ALU_en==1 && (a_en==0  && b_en==1 && b_op == 0) ;
endsequence

sequence illegal_op_check;
  ALU_en==1 && ((a_en==1  && b_en==0 && a_op == 7) || (a_en==0  && b_en==1 && b_op == 3 ) );
endsequence

//assertions
property add_check;
    @(posedge clk) disable iff (!rst_n )
     add_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== $past(A)+$past(B)) );
endproperty


property sub_check;
    @(posedge clk) disable iff (!rst_n) 
        sub_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== $past(A)-$past(B)) );
endproperty

property xor_check;
    @(posedge clk) disable iff (!rst_n) 
        xor_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== $past(A)^$past(B)) );
endproperty


property and_check;
    @(posedge clk) disable iff (!rst_n) 
        and_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== ($past(A)&$past(B))) );
endproperty

property or_check;
    @(posedge clk) disable iff (!rst_n) 
        or_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== $past(A)|$past(B)) );
endproperty

property xnor_check;
    @(posedge clk) disable iff (!rst_n) 
        xnor_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== ~($past(A)^$past(B))) );
endproperty

property subone_check;
    @(posedge clk) disable iff (!rst_n) 
        subone_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== $past(A)-1) );
endproperty

property addtwo_check;
    @(posedge clk) disable iff (!rst_n) 
        addtwo_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== $past(B)+2) );
endproperty

property nand_check;
    @(posedge clk) disable iff (!rst_n) 
        nand_op_check |=> ( ( !ALU_en && $stable(C)) || ( !$past(rst_n) && C==0) || (C== {1'b0,~($past(A)&$past(B))}) );
endproperty

property alu_en_check;
    @(posedge clk) disable iff (!rst_n) 
        !ALU_en |=> $stable(C);
endproperty

//Error Injection
property illegal_check;
    @(posedge clk) disable iff (!rst_n) 
        illegal_op_check |=> $stable(C);
endproperty

//PROPERTY ASSERTION
ADD_ASSERTION : assert property (add_check);
            
SUB_ASSERTION : assert property (sub_check);

XOR_ASSERTION : assert property (xor_check);
                
AND_ASSERTION : assert property (and_check);

OR_ASSERTION : assert property (or_check);
                
XNOR_ASSERTION : assert property (xnor_check);

SUBONE_ASSERTION : assert property (subone_check);

ADDTWO_ASSERTION : assert property (addtwo_check);   

NAND_ASSERTION : assert property (nand_check);

ALU_EN_ASSERTION : assert property (alu_en_check); 

ILLEGAL_ASSERTION : assert property (illegal_check); 


//PROPERTY COVER
ADD_COVER : cover property (add_check);
            
SUB_COVER : cover property (sub_check);

XOR_COVER : cover property (xor_check);
                
AND_COVER : cover property (and_check);

OR_COVER : cover property (or_check);
                
XNOR_COVER : cover property (xnor_check);

SUBONE_COVER : cover property (subone_check);

ADDTWO_COVER : cover property (addtwo_check);   

NAND_COVER : cover property (nand_check);

ALU_EN_COVER : cover property (alu_en_check); 

ILLEGAL_COVER : cover property (illegal_check); 
endinterface 