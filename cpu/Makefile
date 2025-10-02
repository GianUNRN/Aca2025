SHELL := /bin/bash

# tools (allow overrides from environment)
IVERILOG ?= iverilog
VVP      ?= vvp
VLOGFLAGS ?= -g2012

# sources
MODULES := $(wildcard modules/*.sv)
UNITS   := $(wildcard units/*.sv)
MAIN    := top.sv top_tb.sv

# put everything together, sort for deterministic order
FILES   := $(sort $(MODULES) $(UNITS) $(MAIN))

# sanity check: stop early if no files found
ifeq ($(strip $(FILES)),)
$(error No SystemVerilog source files found in modules/ or units/. Check paths and extensions)
endif

TOP      := top_tb
OUT      := sim.out

.PHONY: all run clean show

all: $(OUT)

run: $(OUT)
	@echo "Running simulation: $(OUT)"
	$(VVP) $(OUT)

# target that compiles
$(OUT): $(FILES)
	@echo "Compiling $(TOP) from: $(FILES)"
	$(IVERILOG) $(VLOGFLAGS) -o $(OUT) -s $(TOP) $(FILES)

# debug helper: print variables so you can verify what's being fed to iverilog
show:
	@echo "IVERILOG = $(IVERILOG)"
	@echo "VVP      = $(VVP)"
	@echo "VLOGFLAGS= $(VLOGFLAGS)"
	@echo "TOP      = $(TOP)"
	@echo "OUT      = $(OUT)"
	@echo "FILES    = $(FILES)"

clean:
	rm -f $(OUT) *.vcd
