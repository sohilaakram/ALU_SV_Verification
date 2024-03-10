
class ALU_reference_model;

    bit     signed      [4:0]     A,B;
    bit                 [2:0]     a_op;
    bit                 [1:0]     b_op;
    bit                           a_en,b_en;
    bit                           ALU_en;
    bit                           rst_n;

    logic  signed         [5:0]   C;
  
    function void set(bit signed [4:0] A,B, bit [2:0] a_op, bit [1:0] b_op, bit a_en, bit b_en, bit ALU_en, bit rst_n);
        this.A=A;
        this.B=B;
        this.a_op=a_op;
        this.b_op=b_op;
        this.a_en=a_en;
        this.b_en=b_en;
        this.ALU_en=ALU_en;
        this.rst_n=rst_n;
    endfunction

task execute();
    if (rst_n==0)
        C = 0;
    else
    begin
        if (ALU_en)
        begin
            if (a_en==1 && b_en==0)
                begin
                C = a_op==0 ? A+B : a_op==1? A-B : a_op==2? A^B : a_op==3? A&B : a_op==4? A&B : a_op==5? A|B : a_op==6? ~(A^B) : C;       
                end

            else if (a_en==0 && b_en==1)
            begin
                case(b_op)
                0 : C= {1'b0,~(A&B)};
                1 : C=A+B;
                2 : C=A+B;
                3 : C=C;
                endcase
            end 
            else if (a_en==1 && b_en==1)
            begin
                case(b_op)
                0 : C= A^B;
                1 : C=~(A^B);
                2 : C=A-1;
                3 : C=B+2;
                endcase
            end 
            else
                C=C;
        end
        else
            begin
                if ($isunknown(C))
                    C=0;

            end
    end 

endtask

function logic signed [5:0] get_output();
    return this.C;
endfunction

endclass