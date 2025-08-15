# Variables
IVERILOG = iverilog
VVP      = vvp
FILES    = modules/counter.sv \
           modules/two_d_counter.sv \
           modules/seg7_dec.sv \
           modules/sevenseg_mux.sv \
           modules/debouncer.sv \
           modules/flip_flop_d.sv \
           top_module.sv \
           top_module_tb.sv

TOP      = top_module_tb
OUT      = sim.out

# Default target: compile and run
run: $(OUT)
	$(VVP) $(OUT)

# Compile target
$(OUT): $(FILES)
	$(IVERILOG) -g2012 -o $(OUT) -s $(TOP) $(FILES)

# Clean target
clean:
	rm -f $(OUT) *.vcd

.PHONY: run clean
