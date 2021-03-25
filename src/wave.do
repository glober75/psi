onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate -radix unsigned -childformat {{/testbench/dut/processador/banco_reg/array_reg(3) -radix binary} {/testbench/dut/processador/banco_reg/array_reg(2) -radix unsigned} {/testbench/dut/processador/banco_reg/array_reg(1) -radix unsigned} {/testbench/dut/processador/banco_reg/array_reg(0) -radix unsigned}} -expand -subitemconfig {/testbench/dut/processador/banco_reg/array_reg(3) {-height 15 -radix binary} /testbench/dut/processador/banco_reg/array_reg(2) {-height 15 -radix unsigned} /testbench/dut/processador/banco_reg/array_reg(1) {-height 15 -radix unsigned} /testbench/dut/processador/banco_reg/array_reg(0) {-height 15 -radix unsigned}} /testbench/dut/processador/banco_reg/array_reg
add wave -noupdate -radix unsigned /testbench/dut/processador/pc_reg
add wave -noupdate /testbench/dut/processador/inst_mem_addr
add wave -noupdate /testbench/dut/processador/inst_mem_data
add wave -noupdate -radix unsigned /testbench/dut/processador/immediate_ldi
add wave -noupdate /testbench/dut/processador/opcode
add wave -noupdate /testbench/dut/memoria_programa/addr
add wave -noupdate -expand -group REGBANK /testbench/dut/processador/banco_reg/addr_reg1
add wave -noupdate -expand -group REGBANK /testbench/dut/processador/banco_reg/addr_reg2
add wave -noupdate -expand -group REGBANK /testbench/dut/processador/banco_reg/wr_en
add wave -noupdate -expand -group REGBANK -radix unsigned /testbench/dut/processador/banco_reg/data_wr
add wave -noupdate -expand -group REGBANK /testbench/dut/processador/banco_reg/data_r1
add wave -noupdate -expand -group REGBANK /testbench/dut/processador/banco_reg/data_r2
add wave -noupdate -expand -group ULA -radix unsigned /testbench/dut/processador/ulad/a
add wave -noupdate -expand -group ULA -radix unsigned /testbench/dut/processador/ulad/b
add wave -noupdate -expand -group ULA /testbench/dut/processador/ulad/op
add wave -noupdate -expand -group ULA -radix unsigned /testbench/dut/processador/ulad/c
add wave -noupdate -expand -group ULA /testbench/dut/processador/ulad/zero
add wave -noupdate /testbench/dut/processador/zero
add wave -noupdate -expand -group DATA_MEMORY /testbench/dut/memoria_dados/addr
add wave -noupdate -expand -group DATA_MEMORY /testbench/dut/memoria_dados/rd_wr
add wave -noupdate -expand -group DATA_MEMORY /testbench/dut/memoria_dados/data_in
add wave -noupdate -expand -group DATA_MEMORY /testbench/dut/memoria_dados/data_out
add wave -noupdate -expand -group DATA_MEMORY /testbench/dut/memoria_dados/memo
add wave -noupdate -expand -group PROGRAM_MEMORY /testbench/dut/memoria_programa/addr
add wave -noupdate -expand -group PROGRAM_MEMORY /testbench/dut/memoria_programa/data
add wave -noupdate -expand -group PROGRAM_MEMORY /testbench/dut/memoria_programa/memo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {407662398 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 342
configure wave -valuecolwidth 410
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {87196603 ps} {521726495 ps}
