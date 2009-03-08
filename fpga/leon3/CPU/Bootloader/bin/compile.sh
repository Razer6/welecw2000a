zpu-elf-gcc -Os -abel ../src/crt0_phi.S ../src/bootloader.c -o bootloader.elf -Wl,--relax -Wl,--gc-sections -nostdlib
zpu-elf-strip bootloader.elf -o bootloader.bin
zpuromgen bootloader.elf > elf-table.txt
zpuromgen bootloader.bin > bin-table.txt
rm ../../src/BootloaderROM-elf-ea.vhd ../../src/BootloaderROM-bin-ea.vhd
cp ../src/ROM-template-pre-ea.vhd ../../src/BootloaderROM-elf-ea.vhd
cp ../src/ROM-template-pre-ea.vhd ../../src/BootloaderROM-bin-ea.vhd
cat elf-table.txt >> ../../src/BootloaderROM-elf-ea.vhd
cat bin-table.txt >> ../../src/BootloaderROM-bin-ea.vhd
cat ../src/ROM-template-post-ea.vhd >> ../../src/BootloaderROM-elf-ea.vhd
cat ../src/ROM-template-post-ea.vhd >> ../../src/BootloaderROM-bin-ea.vhd



