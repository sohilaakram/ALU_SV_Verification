vlog -cover cst ../rtl/ALU.sv *.sv
restart -f
run -all
coverage exclude -src ALU.sv -line 86 -code s
coverage exclude -src ALU.sv -line 97 -code s
coverage exclude -src ALU.sv -line 109 -code s
coverage exclude -src ALU.sv -line 116 -code s
#coverage report -assert -detail -verbose -output E:/Q4E/Project/assertion_report.txt /.
#coverage report -detail -cvg -directive -comments -output E:/Q4E/Project/docs/fcover_report.txt /OOP_tb_pkg/coverg/cg

#do ../do/run.do