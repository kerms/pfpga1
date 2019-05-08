# $(addprefix pre, target)

# - - - - - - - - - - - - - - - - - - - - - - - - - - #
# ALL TB FILE NAME NEED TO BE SAME AS THE ENTITY NAME #
# - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - USE - - - - - - - #
# - compile target test bench entity name
# ex: make tb1 tb2
# 
# - simulation  (vcd files will be created)
# ex: make tb1.vcd tb2.vcd

#  - - - - - - ADD TEST TARGET  - - - - - 
# * Add testbench filename without .vhd or vhdl to EXEC
# * Then add denpency at USER DEFINE
# EXEC can have multiple target
EXEC 	 = tb

CC   = ghdl
FLAG = -a -v
SRC_DIR  = source
PKG_DIR  = package
TB_DIR	 = test_bench

# list all vhdl and vhd file
ALL_FILE = \
	$(wildcard $(SRC_DIR)/*) \
	$(wildcard $(PKG_DIR)/*) \
	$(wildcard $(TB_DIR)/*) \
	$(wildcard *.vhdl)


# tranform all vhdl and vhd file into .o
ALL_OBJ  = $(filter-out $(ALL_FILE), $(ALL_FILE:.vhdl=.o) $(ALL_FILE:.vhd=.o))
ALL_PKG  = $(filter $(PKG_DIR)%, $(ALL_OBJ))
ALL_SRC  = $(filter $(SRC_DIR)%, $(ALL_OBJ))
VCD 	 = $(EXEC:=.vcd)


all : $(EXEC)


# - - - - USER DEFINE - - - - - #
# Add here depency if needed
# generic example is to include all package and source:
# your_test_bench_target : $(ALL_PKG) $(ALL_SRC)

TB_Tempo : $(TB_DIR)/TB_Tempo.o
tb : $(PKG_DIR)/random.o $(PKG_DIR)/check.o tb.o

# - - - - END DEFINE - - - - - - #
# - - - - - - - - - - - - - - - -#








# general definition 
# not need to modify
%.o:%.vhdl
	$(CC) $(FLAG) $<

$(EXEC):
	$(CC) $(FLAG) $@.vhdl
	$(CC) -e -v $@

$(VCD):%.vcd: %
	$(CC) -r $* --vcd=$*.vcd

display :
	@echo $(ALL_SRC)

clean : 
	rm -f *.o 

mrproper : clean
	rm -f *.vcd $(EXEC) *.vbe *.cd

.PHONY: clean mrproper all $(EXEC) display