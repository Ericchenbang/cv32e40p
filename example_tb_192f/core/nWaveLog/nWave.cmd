verdiSetActWin -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/ic_contest/diclab008/project/cv32e40p/example_tb/core/main.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave1 \
           "/tb_top/wrapper_i/ram_i/dp_ram_i/unnamed\$\$_0"
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvGetSignalSetScope -win $_nWave1 "/tb_top/wrapper_i/ram_i/dp_ram_i"
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave1 "/tb_top"
wvGetSignalSetScope -win $_nWave1 "/tb_top/wrapper_i"
wvGetSignalSetScope -win $_nWave1 "/tb_top/wrapper_i/ram_i"
wvGetSignalSetScope -win $_nWave1 "/tb_top/wrapper_i/ram_i/dp_ram_i"
wvGetSignalSetScope -win $_nWave1 "/tb_top/wrapper_i/ram_i/dp_ram_i"
wvGetSignalSetScope -win $_nWave1 "/tb_top"
wvExit
