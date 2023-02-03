START_SYMBOL =  "cipher" 
MAIN_SYMBOL = "main"
HALT_SYMBOLS = ["report_done"]
IGNORE_SYMBOLS = []

RELATIVE_PATH = ""
################################################################
############## DO NOT CHANGE ANYTHING BELOW ####################
################################################################

from subprocess import Popen, PIPE
import os
import sys

def is_int(s):
    try:
        int(s, 16)
    except:
        return False
    return True

def run(cmd):
    p = Popen(cmd.split(), stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = p.communicate()
    output = output.decode('UTF-8')
    err = err.decode('UTF-8')
    if p.returncode != 0:
        print(output)
        print(err)
        sys.exit(1)
    return output, err

def num(s):
    return hex(int(s, 16))


def extract_args(FolderName):    

    args = ""

    input_parameter_list = list()
    functionContainingCipher = sys.argv[0]


    argv = sys.argv[1:] #remove function name, inputs remain

    for i in range(len(argv)):
        input_parameter_list.append(str(argv[i]))

    # if str(FolderName).rpartition("/")[0]:
    #     RELATIVE_PATH = str(FolderName).rpartition("/")[0] + str(FolderName).rpartition("/")[1]#"../example_sw/"
    # else:
    #     RELATIVE_PATH = "./"

    RELATIVE_PATH = str(FolderName).rpartition("results")[0] + "binary"

    armV = None
    out,err = run("arm-none-eabi-readelf -A " + RELATIVE_PATH + "/binary.elf")
    tmp,err = run("arm-none-eabi-readelf -A " + RELATIVE_PATH + "/binary.elf")
    # extract/verify supported architecture
    if "Tag_CPU_name:" in out:
        out = out[out.find("Tag_CPU_name:"):]
        out = out[out.find(":")+1 : out.find("\n")].strip()
        if out == '"6-M"':
            armV = "6-M"
        elif out == '"7-M"':
            armV = "7-M"
        else:
            if "Tag_CPU_arch:" in tmp:
                tmp = tmp[tmp.find("Tag_CPU_arch:"):]
                tmp = tmp[tmp.find(":")+1 : tmp.find("\n")].strip()
                if tmp == "v7E-M":
                    armV = "7E-M"
                elif tmp == "v7-M":
                    armV = "v7-M"
                elif tmp == "v6-M":
                    armV = "v6-M"
                else:
                    print("ERROR: {} is not an ARMv6-M, ARMv7-M or ARMv7E-M binary.".format(tmp))
                    sys.exit(1)
            else:
                print("ERROR: 'Tag_CPU_arch' is missing in the output of readelf.")
                sys.exit(1)
    else:
        print("ERROR: 'Tag_CPU_name' is missing in the output of readelf.")
        sys.exit(1)



    # extract addresses of symbols

    with open(RELATIVE_PATH + "/binary.map", "rt") as file:
        lines = file.readlines()

    flash = (0,0)
    end_of_flash = None
    ram = (0,0)
    start_address = None
    main_address = None
    functionContainingCipher_address = None
    halt_addresses = list()
    ignore_ranges = list()
    following_function_cipher_address = None
    following_function_cipher_found = False
    ram_edata_address = None   
    rand_section_start = None  
    rand_section_end = None    
    rand_size_detected = False
    input_parameter_addresses = dict.fromkeys(input_parameter_list)#stores ram addresses for parameters passed to emulator
    inputs_found = False

    for line in lines:
        parts = line.split()
        if len(parts) < 2: continue

        if ".data" in parts and inputs_found == False:
            lines_idx = lines.index(line)
            data_parts = lines[lines_idx].split() #first occurance of .data
            # go through data segment of .map file until data segment ends and extract all addresses for the inputs
            while(not ("_edata" in data_parts)):
                for input_param in input_parameter_list:
                    if input_param in data_parts:
                        input_parameter_addresses[input_param] = data_parts[data_parts.index(input_param)-1]
                lines_idx += 1
                data_parts = lines[lines_idx].split()
            inputs_found = True

        if "_edata" in parts: 
            ram_edata_address = num(parts[0])
        if ".randomness" in parts and not rand_size_detected: 
            rand_section_start = int(parts[1], 0)
            rand_section_end = rand_section_start + int(parts[2], 0)
            rand_size_detected = True
        if parts[0].upper() == "FLASH":
            flash = (num(parts[1]), num(parts[2])) # origin, length
            end_of_flash = int(parts[1], 0) + int(parts[2],0)
        elif parts[0].upper() == "RAM":
            ram = (num(parts[1]), num(parts[2])) # origin, length
        
        if (not following_function_cipher_found) and ("cipher" in parts):
            following_function_cipher_found = True
            following_function_cipher_address = (lines[lines.index(line) + 1].split())[0]
    # extract all symbols

    begin_ignore = None
    sections = list()
    out,err = run("arm-none-eabi-objdump " + RELATIVE_PATH + "/binary.elf -t")
    lines = sorted([l for l in out.split("\n")])
    for l in lines:
        parts = l.split()

        if len(parts) < 3: continue

        if begin_ignore != None and parts[2] == "F" and not (parts[-1] in IGNORE_SYMBOLS):
            if is_int(parts[0]):
                ignore_ranges.append((begin_ignore, hex(min(int(parts[0],16), end_of_flash))))
                begin_ignore = None

        if parts[-1] == START_SYMBOL:
            start_address = num(parts[0])
        elif parts[-1] == MAIN_SYMBOL:
            main_address = num(parts[0])
        elif parts[-1] in HALT_SYMBOLS:
            halt_addresses.append((parts[-1], num(parts[0])))
        elif (parts[-1] in IGNORE_SYMBOLS or parts[2] == "O") and begin_ignore == None:
            begin_ignore = num(parts[0])

        if parts[-1] == functionContainingCipher:
            functionContainingCipher_address = parts[0]

    if begin_ignore != None:
        ignore_ranges.append((begin_ignore, hex(end_of_flash)))

    if flash == (0,0) or ram == (0,0):
        print("flash or ram section could not be found in map file")
        sys.exit(1)

    if start_address == None:
        print("{} symbol could not be found in map file".format(START_SYMBOL))
        sys.exit(1)

    if functionContainingCipher_address == None:
        print("Could not find {} function in map file".format(functionContainingCipher))

    if ram_edata_address == None:
        print("No symbol '_edata' found in linker script in data segment. This is important for placing user input in the correct memory addresses.")
        sys.exit(1)

    if (rand_section_start == None) or (rand_section_end == None):
        print("No section for emulator randomness detected. If you need no randomness proceed otherwise reconfigure linker script.")

    for key, val in input_parameter_addresses.items():
        if val == None:
            print("No symbol {} could be found in .map file! Check in test source files if {} is declared as global variable and stored in .data section.".format(key, key))
            sys.exit(1)

    #extract all sections to binary files

    sections = list()
    out,err = run("arm-none-eabi-objdump " + RELATIVE_PATH + "/binary.elf -h")
    lines = [l for l in out.split("\n")]
    while len(lines) > 0:
        l = lines.pop(0)
        parts = l.split()
        if len(parts) == 7 and parts[1].startswith("."):
            attr = lines.pop(0)
            if "ALLOC" not in attr: continue
            if int(parts[2], 16) != 0: # size != 0
                sections.append((parts[1], num(parts[3]))) # name, offset

    for name, _ in sections:
        run("arm-none-eabi-objcopy -O binary --only-section="+name+" " + RELATIVE_PATH + "/binary.elf " + RELATIVE_PATH + "/code_section"+name)


    # check if compiler optimizations removed call to cipher from main (e.g replacing it with cipher.constprop.0)
    # if so set --start to start address of modified label

    with open(RELATIVE_PATH + "/disassembled.txt", "r") as f:
        lines = f.readlines()
        sanitised_lines = []
        for line in lines:
            sanitised_lines.append((line.replace("\n", "")).replace("\t", "    "))
        sanitised_lines = list(filter(None, sanitised_lines))
        cipher_list = []
        original_cipher_list = []
        main_list = []

        for line in sanitised_lines:
            if((functionContainingCipher_address in line) and ("<{}>".format(functionContainingCipher) in line)):
                main_list = sanitised_lines[sanitised_lines.index(line):]
                break

        for line in main_list:

            if((not line.startswith(" ")) and (main_list.index(line) != 0)):
                main_list = main_list[:main_list.index(line)]
                break

        for line in main_list:
            if("cipher" in line):
                cipher_list.append(line)
            if("<cipher>" in line):
                original_cipher_list.append(line)

        if(len(original_cipher_list) == 0):
            print("could not find <cipher> symbol in compiled main-function. Checking for compiler optimized modifications...")

            if(len(cipher_list) == 0):
                print("could not find <cipher> related functions in main. Please check disassembled.txt. Aborting...")
                sys.exit(-1)    
            else:

                print("found in {} (order of occurrance):".format(functionContainingCipher))
                found_cipher_elements = []
                for line in cipher_list:
                    elements = list(filter(None, line.split(" ")))
                    function_address = elements[-2]
                    function_name = elements[-1]
                    print("\taddress: {}\tfunction: {}\n".format(function_address, function_name))
                    found_cipher_elements.append((function_address, function_name))
                print("taking {}".format(found_cipher_elements[0][1]))
                input("press enter to continue with this function to test...")
                start_address = num(found_cipher_elements[0][0])

    # generate command line args

    args = "--start {}".format(start_address)

    args += " --main {}".format(main_address)

    for x in halt_addresses:
        args += " --halt {} {}".format(x[0], x[1])
    for start, end in ignore_ranges:
        args += " --ignore {} {}".format(start, end)

    args += " --flash {} {} --ram {} {}".format(flash[0], flash[1], ram[0], ram[1])

    args += " --edata_used_ram {}".format(ram_edata_address)

    args += " --randomness_section {} {}".format(rand_section_start, rand_section_end)

    if armV == "6-M": 
        args += " --armv6m"
    elif armV == "7-M": 
        args += " --armv7m"
    else:
        args += " --armv7e-m"

    for name, offset in sections:
        args += " --section " + RELATIVE_PATH + "/code_section{} {}".format(name, offset)

    args += " --inputs"
    for key, val in input_parameter_addresses.items():
        args += " {} {}".format(key,val)


    
    return args

