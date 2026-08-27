vlib work
vmap work work
vcom sample_memory.vhd
vcom sample_memory_tb.vhd

vsim  work.sample_memory_tb

add wave -r *

run 500 ns
