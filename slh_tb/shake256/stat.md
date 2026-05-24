### shake256 performance static

all test compiled by `riscv32-unknown-elf-gcc -O2`

|MLEN(bytes)|OUTLE(bytes)|Baseline(cycles)|Hwaccel(cycles)|
|----|---|------|----|
|  64| 16| 30697|2497|
| 256| 16| 58035|3505|
| 512| 16|112481|5444|
|1024| 16|220357|9200|
| 256|128| 58820|4351|
| 512|256|139375|7164|

