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

BINARY_PATH = "../../binary"


#   check if directory exists
if not os.path.exists(BINARY_PATH):
    os.mkdir(BINARY_PATH)
elif not os.path.isdir(BINARY_PATH):
    raise FileExistsError("'{}' is not a directory.".format(BINARY_PATH))

if(sys.argv[-1] == '0'):
    
    LINKER_PATH = sys.argv[1]

    #generate source file list for gcc call
    source_file_args = ""
    for arg_idx in range(2, len(sys.argv[:-1]) - 1):
        source_file_args += (sys.argv[arg_idx])
        source_file_args += " "

    compiler_flags = sys.argv[len(sys.argv) - 2]
    # build the ARM binary
    sub.run(
            f"arm-none-eabi-gcc {compiler_flags} -Wl,-T{LINKER_PATH} -Wl,-Map,{BINARY_PATH}/binary.map -o {BINARY_PATH}/binary.elf {source_file_args}",
            shell=True,
            check=True,
            )
else:
    map_path = sys.argv[-3]
    disassembled_path = sys.argv[-2]
    elf_path = sys.argv[-4]

    map_name = map_path.rsplit("/", 1)[-1]
    disassembled_name = disassembled_path.rsplit("/", 1)[-1]
    elf_name =  elf_path.rsplit("/", 1)[-1]
    #copy to binary directory
    try:
        shutil.copyfile(map_path, "../../binary/binary.map")
        shutil.copyfile(disassembled_path, "../../binary/disassembled.txt")
        shutil.copyfile(elf_path, "../../binary/binary.elf")
    except OSError as e:
        raise FileExistsError("File or directory to program file not found") from e


# create disassembly for looking up armory results later
with open(BINARY_PATH + "/disassembled.txt", "w") as dis_file:
    sub.run(
            ["arm-none-eabi-objdump", BINARY_PATH + "/binary.elf",  "-d"],
            stdout=dis_file,
            check=True,
            )

