# Default compile flags.
CFLAGS=-Os -g

# Kernel path
RAVENSCAR_SRC=../../../../lib/gcc/arm-eabi/4.5.3/rts-ravenscar-sfp/ravenscar

# Main subprogram.
PRG= motor_man3

include $(RAVENSCAR_SRC)/Makefile.inc
