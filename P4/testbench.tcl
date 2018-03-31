vlib work

;# Compile components if any
vcom Adder.vhd
vcom ALU.vhd
vcom ALU_Control.vhd
vcom BranchForwardingUnit.vhd
vcom Controller.vhd
vcom detectHazard.vhd
vcom EXMEM.vhd
vcom ForwardingUnit.vhd
vcom IDEX.vhd
vcom IFID.vhd
vcom mainfunction.vhd
vcom Memory.vhd
vcom MEMWB.vhd
vcom PC.vhd
vcom registers.vhd

;# Start simulation
vsim mainFunction

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Run
run
