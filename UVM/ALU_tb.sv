import uvm_pkg::*;
import alu_pkg::*;

module ALU_tb;

    intf vif ();

    ALU DUT (  .clk(vif.clk), .rst_n(vif.rst_n),
                        .a_op(vif.a_op), .b_op(vif.b_op), .ALU_en(vif.ALU_en),
                        .a_en(vif.a_en), .b_en(vif.b_en),
                        .A(vif.A), .B(vif.B),  .C(vif.C)
                    );

initial
begin
    uvm_config_db#(virtual intf )::set(null , "*", "vif", vif);
    run_test("test");
    $dumpfile("ALU.vcd");
    $dumpvars(0,ALU_tb);
end

endmodule