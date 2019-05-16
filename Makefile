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
EXEC 	 = TB_Counter_Auto TB_Clock_Divider TB_Bit TB_Reg Simple_TB_User_Interface Simple_TB_Frame_Builder \
	Simple_TB_Frame_Reg_Param Simple_TB_Frame_Generator

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


all : $(ALL_PKG) $(EXEC) 


# - - - - USER DEFINE - - - - - #
# Add here depency if needed
# generic example is to include all package and source:
# your_test_bench_target : $(ALL_SRC)

TB_Tempo : $(TB_DIR)/TB_Tempo.o
tb : tb.o
TB_Counter_Auto :  $(SRC_DIR)/Counter_Auto.o
TB_Clock_Divider : $(SRC_DIR)/Clock_Divider.o
TB_Bit : $(SRC_DIR)/DCC_Bit.o
TB_Reg : $(SRC_DIR)/DCC_Reg.o
Simple_TB_User_Interface : $(SRC_DIR)/User_Interface.o
Simple_TB_Frame_Builder : $(SRC_DIR)/DCC_Frame_Builder.o
Simple_TB_Frame_Reg_Param : $(SRC_DIR)/DCC_Frame_Reg_Param.o
Simple_TB_Frame_Generator : $(SRC_DIR)/DCC_Frame_Reg_Param.o \
	$(SRC_DIR)/User_Interface.o \
	$(SRC_DIR)/DCC_Frame_Builder.o \
	$(SRC_DIR)/DCC_Frame_Generator.o 

# - - - - END DEFINE - - - - - - #
# - - - - - - - - - - - - - - - -#








# general definition 
# not need to modify
%.o:%.vhdl
	$(CC) $(FLAG) $<

$(EXEC):%: $(TB_DIR)/%.o
	$(CC) -e -v $@

$(VCD):%.vcd: $(ALL_PKG) % 
	$(CC) -r $* --vcd=$*.vcd

display :
	@echo $(ALL_SRC)

clean : 
	rm -f *.o 

mrproper : clean
	rm -f *.vcd $(EXEC) *.vbe *.cd

.PHONY: clean mrproper all $(EXEC) display