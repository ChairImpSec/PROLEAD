from asyncio import subprocess
import subprocess as sub
import os
import sys
import shutil

from pkg_resources import BINARY_DIST

dir = os.getcwd()
sys.path.append(dir)

from pathlib import Path
path = Path(dir)
sys.path.append(str(path.parent.absolute()))

BINARY_PATH = "./"



#   check if directory exists
if not os.path.isdir(BINARY_PATH):
    print("\n{} is not a directory".format(BINARY_PATH))
    exit(1)

#   if leftovers from past executions exist remove them
try:
    shutil.rmtree(BINARY_PATH + "tmp_data/")
except FileNotFoundError:
    pass



try:
    # dir for tmp data
    os.makedirs(BINARY_PATH + "tmp_data/", exist_ok=True)
    if(sys.argv[-1] == '0'):
        
        LINKER_PATH = sys.argv[1]

        #generate source file list for gcc call
        source_file_args = ""
        for arg_idx in range(2, len(sys.argv[:-1]) - 1):
            source_file_args += (sys.argv[arg_idx])
            source_file_args += " "

        compiler_flags = sys.argv[len(sys.argv) - 2]
        # build the ARM binary
        if os.system("arm-none-eabi-gcc " + compiler_flags + " -Wl,-T" + LINKER_PATH +" -Wl,-Map," + BINARY_PATH + "tmp_data/binary.map" + " -o " + BINARY_PATH + "tmp_data/binary.elf " + source_file_args) != 0: sys.exit(1)
    else:
        map_path = sys.argv[-3]
        disassembled_path = sys.argv[-2]
        elf_path = sys.argv[-4]

        map_name = map_path.rsplit("/", 1)[-1]
        disassembled_name = disassembled_path.rsplit("/", 1)[-1]
        elf_name =  elf_path.rsplit("/", 1)[-1]
        #copy to tmp_data directory
        shutil.copyfile(map_path, "tmp_data/binary.map")
        shutil.copyfile(disassembled_path, "tmp_data/disassembled.txt")
        shutil.copyfile(elf_path, "tmp_data/binary.elf")


except Exception as e:
    shutil.rmtree(BINARY_PATH + "tmp_data/")
    print(str(e))
    print("\nFile or directory to program file not found")
    exit(1)

# create disassembly for looking up armory results later
if os.system("arm-none-eabi-objdump " + BINARY_PATH + "tmp_data/binary.elf -d > " + BINARY_PATH + "tmp_data/disassembled.txt") != 0: sys.exit(1)

