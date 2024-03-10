import OOP_tb_pkg::*;

module ALU_tb;

intf intf0 ();

test test0 (intf0);

ALU DUT (  .clk(intf0.clk), .rst_n(intf0.rst_n),
                    .a_op(intf0.a_op), .b_op(intf0.b_op), .ALU_en(intf0.ALU_en),
                    .a_en(intf0.a_en), .b_en(intf0.b_en),
                    .A(intf0.A), .B(intf0.B),  .C(intf0.C)
                );



initial 
begin

  	$dumpfile("ALU.vcd");
    $dumpvars(0,ALU_tb);

end

endmodule