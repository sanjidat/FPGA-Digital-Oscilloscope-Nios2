vlib work
vmap work work

vcom sample_generator.vhd
vcom trigger_logic.vhd
vcom sample_memory.vhd
vcom capture_controller.vhd

vcom oscilloscope_top.vhd
vcom oscilloscope_top_tb.vhd

vsim  work.oscilloscope_top_tb

add wave -r *

run 2 us
