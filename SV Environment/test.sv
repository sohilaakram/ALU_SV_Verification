import OOP_tb_pkg::*;

program test(intf intf0);

int count =10000;

env env0;

initial
begin
    env0= new(intf0,count);
    env0.run_test();
end
 
endprogram