vlib work
vlog SPI.V project_tb.v
vsim -voptargs=+acc work.tb
add wave -position insertpoint sim:/tb/*
add wave -position insertpoint sim:/tb/DUT/a1/*
add wave -position insertpoint sim:/tb/DUT/a2/*
run -all
#quit -sim