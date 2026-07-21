vlib work
vlog slave.v RAM.v top.v slave_tb.v 
vsim -voptargs=+acc work.tb
add wave -position insertpoint sim:/tb/*
add wave -position insertpoint  \
sim:/tb/SPI_TOP/SPI_SLAVE/cs \
sim:/tb/SPI_TOP/SPI_SLAVE/ns \
sim:/tb/SPI_TOP/SPI_SLAVE/read_address_received \
sim:/tb/SPI_TOP/SPI_SLAVE/bit_cnt
add wave -position insertpoint  \
sim:/tb/SPI_TOP/rx_data \
sim:/tb/SPI_TOP/rx_valid \
sim:/tb/SPI_TOP/tx_data \
sim:/tb/SPI_TOP/tx_valid
run -all
#quit -sim
