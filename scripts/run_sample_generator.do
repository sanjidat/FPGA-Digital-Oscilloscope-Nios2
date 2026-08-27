vlib work
vmap work work
vcom sample_generator.vhd
vcom sample_generator_tb.vhd

vsim  work.sample_generator_tb

add wave -r *

run 2 us
