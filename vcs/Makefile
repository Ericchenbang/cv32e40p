MAKE = make
TEST ?= hello_world

# ==============================================================================
# VCS Configuration
# ==============================================================================
VCS           = vcs
VCS_FLAGS     = -sverilog -full64 -debug_access -fsdbon -ntb_opts uvm -timescale=1ns/10ps +define+CV32E40P_TRACE_EXECUTION
VCS_SIM_FLAGS = +fsdb

# ==============================================================================
# RTL & Testbench Source Files
# ==============================================================================
RTLSRC_HOME      := ..
CV_CORE_MANIFEST := $(RTLSRC_HOME)/cv32e40p_slh_manifest.flist
TB_CORE          := $(RTLSRC_HOME)/example_tb/core
RTLSRC_TB_PKG    := $(TB_CORE)/include/perturbation_pkg.sv
RTLSRC_TB_TOP    := tb_top.sv
RTLSRC_TB        := $(filter-out $(TB_CORE)/cv32e40p_fp_wrapper.sv $(TB_CORE)/tb_top.sv $(RTLSRC_TB_TOP), $(wildcard $(TB_CORE)/*.sv))
export DESIGN_RTL_DIR = $(RTLSRC_HOME)/rtl

TEST_DIR      := $(TEST)
PROG          := $(TEST_DIR)/prog.hex

$(PROG):
	$(MAKE) -C $(TEST_DIR)

simv: $(CV_CORE_MANIFEST) $(RTLSRC_TB_PKG) $(RTLSRC_TB) $(RTLSRC_TB_TOP)
	$(VCS) $(VCS_FLAGS) -f $(CV_CORE_MANIFEST) $(RTLSRC_TB_PKG) $(RTLSRC_TB) $(RTLSRC_TB_TOP)

run: simv $(PROG)
	./simv $(VCS_SIM_FLAGS) +firmware=$(PROG)

all: run

clean: custom-clean
	$(MAKE) -C $(TEST_DIR) clean
	rm -rf simv simv.daidir csrc ucli.key vc_hdrs.h DVEfiles inter.vpd *.vcd *.log
	
.PHONY: all clean run
