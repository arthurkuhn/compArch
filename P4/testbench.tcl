vlib work

;# Compile components
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
vcom Memory.vhd
vcom MEMWB.vhd
vcom PC.vhd
vcom registers.vhd
vcom mainfunction.vhd

;# Start simulation
vsim mainFunction

;# Run
run
