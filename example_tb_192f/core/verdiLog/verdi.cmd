debImport "-f" "../../cv32e40p_manifest.flist" "include/perturbation_pkg.sv" \
          "cv32e40p_random_interrupt_generator.sv" "dp_ram.sv" "tb_top.sv" \
          "cv32e40p_tb_subsystem.sv" "riscv_rvalid_stall.sv" \
          "riscv_gnt_stall.sv" "amo_shim.sv" "mm_ram.sv"
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "318" "82" "900" "700"
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/ic_contest/diclab008/project/cv32e40p/example_tb/core/riscy_tb.vcd.fsdb}
verdiWindowResize -win $_Verdi_1 "318" "82" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
debExit
