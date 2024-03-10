module ALU #(parameter DATA_WIDTH = 5)
    (       
        output  wire    signed   [DATA_WIDTH:0]      C,
        input   wire    signed   [DATA_WIDTH-1:0]    A,B,
        input   wire             [2:0]               a_op,
        input   wire             [1:0]               b_op,
        input   wire                                 a_en,b_en,
        input   wire                                 ALU_en,
        input   wire                                 clk,rst_n
    );


reg signed [DATA_WIDTH:0] C_temp;

typedef enum logic [1:0] { 
    op_a_set,
    op_b_set1,
    op_b_set2,
    no_op

} OP_SET;

typedef enum logic [2:0] { 
    A_ADD,
    A_SUB,
    A_BW_XOR,
    A_BW_AND1,
    A_BW_AND2,
    A_BW_OR,
    A_BW_XNOR,
    A_NULL
} A_OP;

typedef enum logic [1:0] { 
    B_NAND,
    B_ADD1,
    B_ADD2,
    B_NULL
} B_OP1;

typedef enum logic [1:0] { 
    B_BW_XOR,
    B_BW_XNOR,
    B_SUB_1,
    B_ADD_2
} B_OP2;

OP_SET op_set;
A_OP A_op;
B_OP1 B_op1;
B_OP2 B_op2;

assign op_set = (a_en & !b_en )? op_a_set : ( (!a_en & b_en )? op_b_set1 : ( (a_en & b_en)? op_b_set2 : no_op )   );

assign A_op = a_op==0 ? A_ADD : a_op==1? A_SUB : a_op==2? A_BW_XOR : a_op==3? A_BW_AND1 : a_op==4? A_BW_AND2 : a_op==5? A_BW_OR : a_op==6? A_BW_XNOR : A_NULL;

assign B_op1 = b_op==0? B_NAND : b_op==1? B_ADD1 : b_op==2? B_ADD2 : B_NULL;

assign B_op2 = b_op==0? B_BW_XOR : b_op==1? B_BW_XNOR : b_op==2? B_SUB_1 : B_ADD_2;

always @(posedge clk or negedge rst_n)
begin
    if (rst_n==0)
        begin
            C_temp<=0;
        end 

    else
        begin
            if(ALU_en)
            begin
                
                case (op_set)

                op_a_set :
                begin
                    case(A_op)
                        A_ADD:        C_temp <= A+B;
                        A_SUB:        C_temp <= A-B;
                        A_BW_XOR:     C_temp <= A^B;
                        A_BW_AND1:    C_temp <= A&B;
                        A_BW_AND2:    C_temp <= A&B;
                        A_BW_OR:      C_temp <= A|B;
                        A_BW_XNOR:    C_temp <= ~(A^B);
                        A_NULL:       C_temp <= C_temp;
                        default :     C_temp <= 0;
                    endcase                    
                end

                op_b_set1 :
                begin
                    case(B_op1)
                        B_NAND:       C_temp <= {1'b0,~(A&B)};
                        B_ADD1:       C_temp <= A+B;
                        B_ADD2:       C_temp <= A+B;
                        B_NULL:       C_temp <=C_temp;
                        default :     C_temp <=0;
                    endcase                    
                end

                
                op_b_set2 :
                begin
                    case(B_op2)
                        B_BW_XOR:     C_temp <= A^B;
                        B_BW_XNOR:    C_temp <= ~(A^B);
                        B_SUB_1:       C_temp <= A-1;
                        B_ADD_2:       C_temp <= B+2;
                        default :      C_temp <=0;
                    endcase                     
                end
       
                
                no_op : C_temp <=C_temp;
                
                default : C_temp <=0;
                endcase
            end
            else 
                C_temp <=C_temp;
        end

end

assign C=C_temp;


endmodule
