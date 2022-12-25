##################################################
##                                              ##
##      Simple Universal C/C++ Makefile         ##
##                                              ##
##   Targets:                                   ##
##   help      show usage information           ##
##   all       build debug and release          ##
##   release   build in release mode            ##
##   debug     build in debug mode              ##
##   clean     remove output directories        ##
##                                              ##
##################################################

##################################################
##                CONFIGURATION                 ##
##################################################

# Include directories with .h files. Separate multiple directories with a space.
INC_DIRS = inc

# Source directories with the .c and .cpp files. Separate multiple directories with a space.
SRC_DIRS = src

LIB_DIR = lib

# Output directories for release and debug configurations.
# If both point to the same directory, the final binaries will be suffixed with "_release" and "_debug".
RELEASE_DIR = release
DEBUG_DIR = debug

# Compiler options
C_RELEASE_FLAGS   = -Wall -Wextra -Wshadow -pedantic -fopenmp -O3 -fomit-frame-pointer -std=c11
C_DEBUG_FLAGS     = -Wall -Wextra -Wshadow -pedantic -fopenmp -g -O2 -fsanitize=address -std=c11

CXX_RELEASE_FLAGS = -Wall -Wextra -Wshadow -pedantic -fopenmp -O3 -fomit-frame-pointer -std=c++17
CXX_DEBUG_FLAGS   = -Wall -Wextra -Wshadow -pedantic -fopenmp -g -O2 -fsanitize=address -std=c++17

# Linker options. Add libraries you want to link against here.
RELEASE_LINK_FLAGS = -L$(LIB_DIR) -fopenmp -ldl
DEBUG_LINK_FLAGS = -L$(LIB_DIR) -fsanitize=address -fopenmp -ldl

# Output file name
OUTPUT = PROLEAD

# Compilers. Change only if you need to
# CC  = clang
# CXX = clang++

#############################################
##          CORE (do not touch)            ##
#############################################

.PHONY: all release debug clean help compile directories check

HELP_MESSAGE = Simply use any combination of 'make {debug, release, help, clean}'. Just calling 'make' will build release and debug. By adding 'V=1' prints more verbose output.

# switch between debug and release config
ifeq ($(D),1)
	C_FLAGS = $(C_DEBUG_FLAGS)
	CXX_FLAGS = $(CXX_DEBUG_FLAGS)
	LINK_FLAGS = $(DEBUG_LINK_FLAGS)
	OBJ_DIR = obj_debug
ifeq ($(DEBUG_DIR),$(RELEASE_DIR))
	OUTPUT := $(basename $(OUTPUT))_debug$(suffix $(OUTPUT))
endif
else
	C_FLAGS = $(C_RELEASE_FLAGS)
	CXX_FLAGS = $(CXX_RELEASE_FLAGS)
	LINK_FLAGS = $(RELEASE_LINK_FLAGS)
	OBJ_DIR = obj_release
ifeq ($(DEBUG_DIR),$(RELEASE_DIR))
	OUTPUT := $(basename $(OUTPUT))_release$(suffix $(OUTPUT))
endif
endif

# list all .c and .cpp files
C_LIST := $(foreach dir,$(SRC_DIRS),$(patsubst $(dir)/%,$(OUTPUT_DIRECTORY)/$(OBJ_DIR)/$(dir)/%,$(shell find $(dir) -name "*.c")))
CXX_LIST := $(foreach dir,$(SRC_DIRS),$(patsubst $(dir)/%,$(OUTPUT_DIRECTORY)/$(OBJ_DIR)/$(dir)/%,$(shell find $(dir) -name "*.cpp")))

# create object file names in the obj directory
OBJ_FILES := $(C_LIST:.c=.o) $(CXX_LIST:.cpp=.o)

# Verbosity flag defaults to 0
V = 0

# if verbosity is set to 0, pipe outputs to null and supress command printing
ifeq ($(V),0)
	SUPPRESS_CMD := @
	PIPE := > /dev/null
endif

# clang/gcc options to generate dependency files
DEP_FLAGS = -MT $@ -MMD -MP -MF $(OUTPUT_DIRECTORY)/$(OBJ_DIR)/$*.d

# select appropriate linker
ifeq ($(CXX_LIST),)
	LINK := $(CC)
else
	LINK := $(CXX)
endif

# store make invocation time
START_TIME := $(shell date +%s%3N)

# tell make to not print spam on recursive calls
MAKEFLAGS += --no-print-directory

######################################
# targets for the user

all: debug release

debug:
	@+make compile D=1 OUTPUT_DIRECTORY=$(DEBUG_DIR)

release:
	@+make compile D=0 OUTPUT_DIRECTORY=$(RELEASE_DIR)

clean:
	@echo  Removing build artifacts...
	$(SUPPRESS_CMD)rm -rf $(DEBUG_DIR)
	$(SUPPRESS_CMD)rm -rf $(RELEASE_DIR)
	$(SUPPRESS_CMD)rm -f *.stackdump

help:
	@echo $(HELP_MESSAGE)


######################################
# internal targets

# check whether the user used an internal command directly
check:
ifeq ($(OUTPUT_DIRECTORY),)
	$(info You used an unsupported command combination)
	$(info $(HELP_MESSAGE))
	$(error )
endif

# create obj directory and compile
compile: check directories $(OUTPUT_DIRECTORY)/$(OUTPUT)
ifeq ($(D), 1)
	@diff=$$(($(shell date +%s%3N) - $(START_TIME))); echo 'Debug build completed in '$$(($$diff / 1000))'.'$$(($$diff % 1000))'s'
else
	@diff=$$(($(shell date +%s%3N) - $(START_TIME))); echo 'Release build completed in '$$(($$diff / 1000))'.'$$(($$diff % 1000))'s'
endif
	@echo

# create the obj directory
directories: check
ifeq ($(D), 1)
	@echo  '_______Building Debug_______'
else
	@echo  '______Building Release______'
endif
	@mkdir -p $(OUTPUT_DIRECTORY)/$(OBJ_DIR)/

# link output
$(OUTPUT_DIRECTORY)/$(OUTPUT): $(OBJ_FILES)
	@echo
ifeq ($(V), 0)
	@echo  -e 'LINK\t$(OUTPUT)'
endif
	$(SUPPRESS_CMD)$(LINK) -o $(OUTPUT_DIRECTORY)/$(OUTPUT) $(OBJ_FILES) $(LINK_FLAGS) $(PIPE)
	@echo

# compile code files
$(OUTPUT_DIRECTORY)/$(OBJ_DIR)/%.o: %.c Makefile
ifeq ($(V), 0)
	@echo  -e 'CC\t$<'
endif
	@mkdir -p '$(dir $@)'
	$(SUPPRESS_CMD)$(CC) -c $< -o $@ $(DEP_FLAGS) $(C_FLAGS) $(foreach dir,$(INC_DIRS),-I $(dir)) $(PIPE)
	@touch $@

$(OUTPUT_DIRECTORY)/$(OBJ_DIR)/%.o: %.cpp Makefile
ifeq ($(V), 0)
	@echo  -e 'CXX\t$<'
endif
	@mkdir -p '$(dir $@)'
	$(SUPPRESS_CMD)$(CXX) -c $< -o $@ $(DEP_FLAGS) $(CXX_FLAGS) $(foreach dir,$(INC_DIRS),-I $(dir)) $(PIPE)
	@touch $@

#Pull in dependency info for *existing* .o files
-include $(OBJ_FILES:.o=.d)
